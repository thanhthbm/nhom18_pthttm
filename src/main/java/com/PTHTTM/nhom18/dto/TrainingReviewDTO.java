package com.PTHTTM.nhom18.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@AllArgsConstructor
public class TrainingReviewDTO {
  private Long id;
  private String content;
  private String sentiment;
}
