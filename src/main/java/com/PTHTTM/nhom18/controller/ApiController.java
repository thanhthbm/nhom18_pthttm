package com.PTHTTM.nhom18.controller;

import com.PTHTTM.nhom18.dto.PredictRequest;
import com.PTHTTM.nhom18.dto.TrainingCallBackPayload;
import com.PTHTTM.nhom18.dto.TrainingReviewDTO;
import com.PTHTTM.nhom18.model.DataSource;
import com.PTHTTM.nhom18.model.TrainingReview;
import com.PTHTTM.nhom18.service.DataSourceService;
import com.PTHTTM.nhom18.service.PredictService;
import com.PTHTTM.nhom18.service.TrainingJobService;
import com.PTHTTM.nhom18.service.TrainingReviewService;
import java.util.List;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
public class ApiController {
  private final TrainingJobService jobService;
  private final PredictService predictService;
  private final TrainingReviewService trainingReviewService;
  private final DataSourceService dataSourceService;

  public ApiController(TrainingJobService jobService, PredictService predictService,  TrainingReviewService trainingReviewService,  DataSourceService dataSourceService) {
    this.jobService = jobService;
    this.predictService = predictService;
    this.trainingReviewService = trainingReviewService;
    this.dataSourceService = dataSourceService;
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

  @GetMapping("/reviews")
  public ResponseEntity<List<TrainingReviewDTO>> getReviewsByDataSource(@RequestParam Long dataSourceId){
    if (dataSourceId == null){
      return ResponseEntity.badRequest().build();
    }

    DataSource dataSource = this.dataSourceService.getById(dataSourceId);

    if (dataSource == null){
      return ResponseEntity.badRequest().build();
    }

    List<TrainingReviewDTO> trainingReviews = this.trainingReviewService.handleFindByDataSource(dataSource);
    return ResponseEntity.ok(trainingReviews);
  }


}
