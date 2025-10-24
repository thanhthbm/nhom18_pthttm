package com.PTHTTM.nhom18.service;

import com.PTHTTM.nhom18.model.TrainingJob;
import com.PTHTTM.nhom18.model.TrainingResult;
import com.PTHTTM.nhom18.repository.TrainingResultRepository;
import org.springframework.stereotype.Service;

@Service
public class TrainingResultService {
  private final TrainingResultRepository trainingResultRepository;

  public TrainingResultService(TrainingResultRepository trainingResultRepository) {
    this.trainingResultRepository = trainingResultRepository;
  }

  public TrainingResult findByJob(TrainingJob job) {
    return this.trainingResultRepository.findByJob(job);
  }
}
