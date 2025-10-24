package com.PTHTTM.nhom18.service;

import com.PTHTTM.nhom18.dto.TrainingCallBackPayload;
import com.PTHTTM.nhom18.dto.TrainingRequestDTO;
import com.PTHTTM.nhom18.model.ModelVersion;
import com.PTHTTM.nhom18.model.TrainingJob;
import com.PTHTTM.nhom18.model.TrainingResult;
import com.PTHTTM.nhom18.repository.ModelVersionRepository;
import com.PTHTTM.nhom18.repository.TrainingJobRepository;
import com.PTHTTM.nhom18.repository.TrainingResultRepository;
import java.util.List;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestClientException;
import org.springframework.web.client.RestTemplate;

@Service
public class TrainingJobService {
  private final TrainingJobRepository trainingJobRepository;
  private final ModelVersionService modelVersionService;
  private final ModelVersionRepository modelVersionRepository;
  private final TrainingResultRepository trainingResultRepository;
  private final RestTemplate restTemplate;

  @Value("${ml.service.train.url}")
  private String pythonTrainUrl;


  public TrainingJobService(
      TrainingJobRepository trainingJobRepository,
      ModelVersionService modelVersionService,
      RestTemplate restTemplate,
      ModelVersionRepository modelVersionRepository,
      TrainingResultRepository trainingResultRepository
      ) {
    this.trainingJobRepository = trainingJobRepository;
    this.modelVersionService = modelVersionService;
    this.restTemplate = restTemplate;
    this.modelVersionRepository = modelVersionRepository;
    this.trainingResultRepository = trainingResultRepository;
  }


  public TrainingJob findById(Long id) {
    Optional<TrainingJob> trainingJob = trainingJobRepository.findById(id);
    if (trainingJob.isPresent()) {
      return trainingJob.get();
    }
    return null;
  }

  public TrainingJob createTrainingJob(String versionName, List<Long> dataSourceIds) {
    ModelVersion version = modelVersionService.createVersion(versionName);

    TrainingJob job = new TrainingJob();
    job.setModelVersion(version);
    job.setStatus("STARTED");
    TrainingJob savedJob = trainingJobRepository.save(job);

    TrainingRequestDTO request = new TrainingRequestDTO();
    request.setJobId(savedJob.getId());
    request.setVersionName(versionName);
    request.setDataSourceIds(dataSourceIds);

    startPythonTraining(request, savedJob);
    return savedJob;
  }

  @Async
  public void startPythonTraining(TrainingRequestDTO request, TrainingJob savedJob) {
    try {
      restTemplate.postForLocation(pythonTrainUrl, request);
    } catch (RestClientException ex) {
      savedJob.setStatus("FAILED");
      savedJob.setErrorMessage("Failed to start python training job");
      trainingJobRepository.save(savedJob);
    }
  }

  @Transactional
  public void processTrainingCallback(Long jobId, TrainingCallBackPayload payload) {
    Optional<TrainingJob> jobOpt = trainingJobRepository.findById(jobId);
    if (jobOpt.isEmpty()) {
      return;
    }
    TrainingJob job = jobOpt.get();

    ModelVersion modelVersion = job.getModelVersion();
    if (modelVersion == null) {
      job.setStatus("FAILED");
      job.setErrorMessage("Không tìm thấy ModelVersion liên kết.");
      trainingJobRepository.save(job); // Lưu trạng thái FAILED
      return;
    }

    if ("COMPLETED".equals(payload.getStatus())) {
      job.setStatus("COMPLETED");
      job.setErrorMessage(null);

      modelVersion.setCheckpointUrl(payload.getModelPath());
      modelVersionRepository.save(modelVersion);

      TrainingResult trainingResult = new TrainingResult();
      trainingResult.setJob(job);

      if (payload.getMetrics() != null) {

        trainingResult.setAccuracy(payload.getMetrics().get("eval_accuracy"));
        trainingResult.setRecall(payload.getMetrics().get("eval_recall_macro"));
        trainingResult.setPrecision(payload.getMetrics().get("eval_precision_macro"));
        trainingResult.setF1Score(payload.getMetrics().get("eval_f1_macro"));
      } else {
        trainingResult.setPrecision(0.0);
        trainingResult.setF1Score(0.0);
        trainingResult.setAccuracy(0.0);
        trainingResult.setRecall(0.0);
      }
      trainingResultRepository.save(trainingResult);

      job.setTrainingResult(trainingResult);

    } else {
      job.setStatus("FAILED");
      job.setErrorMessage(payload.getErrorMessage());

    }

    trainingJobRepository.save(job);
  }
}
