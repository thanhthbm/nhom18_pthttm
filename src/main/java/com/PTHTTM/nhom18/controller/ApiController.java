package com.PTHTTM.nhom18.controller;

import com.PTHTTM.nhom18.dto.TrainingCallBackPayload;
import com.PTHTTM.nhom18.model.ModelVersion;
import com.PTHTTM.nhom18.service.TrainingJobService;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
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

  public ApiController(TrainingJobService jobService) {
    this.jobService = jobService;
  }

  @PostMapping("/training/callback/{jobId}")
  public ResponseEntity<Void> handleTrainingCallback(
      @PathVariable Long jobId,
      @RequestBody TrainingCallBackPayload payload)
  {
    jobService.processTrainingCallback(jobId, payload);
    return ResponseEntity.ok().build();
  }



}
