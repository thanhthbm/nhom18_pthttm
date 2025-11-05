package com.PTHTTM.nhom18.controller;

import com.PTHTTM.nhom18.dto.PredictRequest;
import com.PTHTTM.nhom18.dto.TrainingCallBackPayload;
import com.PTHTTM.nhom18.service.PredictService;
import com.PTHTTM.nhom18.service.TrainingJobService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class ApiController {
  private final TrainingJobService jobService;
  private final PredictService predictService;

  public ApiController(TrainingJobService jobService, PredictService predictService) {
    this.jobService = jobService;
    this.predictService = predictService;
  }

  @PostMapping("/training/callback/{jobId}")
  public ResponseEntity<Void> handleTrainingCallback(
      @PathVariable Long jobId,
      @RequestBody TrainingCallBackPayload payload)
  {
    jobService.processTrainingCallback(jobId, payload);
    return ResponseEntity.ok().build();
  }

  @PostMapping("/predict")
  public ResponseEntity<String> handlePredict(@RequestBody PredictRequest req){
    String result = this.predictService.predict(req);
    return ResponseEntity.ok().body(result);
  }


}
