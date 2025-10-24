package com.PTHTTM.nhom18.dto;

import java.util.Map;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class TrainingCallBackPayload {
  private String status;
  private String errorMessage;
  private String modelPath;
  private Map<String, Double> metrics;
}
