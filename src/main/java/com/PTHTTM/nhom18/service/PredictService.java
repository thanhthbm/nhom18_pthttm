package com.PTHTTM.nhom18.service;

import com.PTHTTM.nhom18.dto.PredictRequest;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class PredictService {
  private final RestTemplate restTemplate;
  @Value("${ml.service.predict.url}")
  private String predictUrl;

  public PredictService(RestTemplate restTemplate) {
    this.restTemplate = restTemplate;
  }

  public String predict(PredictRequest req){
    String result = restTemplate.postForObject(predictUrl, req, String.class);
    return result;
  }
}
