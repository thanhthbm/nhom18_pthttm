package com.PTHTTM.nhom18.service;

import com.PTHTTM.nhom18.model.ModelVersion;
import com.PTHTTM.nhom18.repository.ModelVersionRepository;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class ModelVersionService {
  private final ModelVersionRepository modelVersionRepository;
  private final RestTemplate restTemplate;

  @Value("${ml.service.activate.url}")
  private String pythonActiveUrl;

  public ModelVersionService(ModelVersionRepository modelVersionRepository,  RestTemplate restTemplate) {
    this.modelVersionRepository = modelVersionRepository;
    this.restTemplate = restTemplate;
  }

  public ModelVersion createVersion(String versionName) {
    ModelVersion modelVersion = new ModelVersion();
    modelVersion.setName(versionName);
    modelVersion.setModelType("overall");
    modelVersion.setActive(false);

    return modelVersionRepository.save(modelVersion);
  }


  public boolean activateVersion(long id) {
    Optional<ModelVersion> modelVersion = modelVersionRepository.findById(id);

    if (modelVersion.isEmpty()){
      return false;
    }

    ModelVersion newVersion = modelVersion.get();
    if (newVersion.getCheckpointUrl() == null || newVersion.getCheckpointUrl().isEmpty()){
      System.out.println("There is no checkpoint for this version. Url is empty");
      return false;
    }

    List<ModelVersion> currentActiveModel = modelVersionRepository.findByActive(true);

    for  (ModelVersion modelVersion1 : currentActiveModel) {
      if (modelVersion1.getId() != id) {
        modelVersion1.setActive(false);
        modelVersionRepository.save(modelVersion1);
      }
    }

    newVersion.setActive(true);
    modelVersionRepository.save(newVersion);

    Map<String, String> payload = new HashMap<>();
    payload.put("newModelPath", newVersion.getCheckpointUrl());
    restTemplate.postForEntity(pythonActiveUrl, payload, String.class);
    return true;
  }

  public void deleteVersion(long id) {
    this.modelVersionRepository.deleteById(id);
  }
}
