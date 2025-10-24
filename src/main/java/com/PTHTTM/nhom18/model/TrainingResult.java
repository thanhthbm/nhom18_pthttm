package com.PTHTTM.nhom18.model;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "tblTrainingResult")
public class TrainingResult {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private long id;

  @OneToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "tblTrainingJobid", unique = true)
  private TrainingJob job;

  @Column
  private double accuracy;
  @Column
  private double f1Score;
  @Column
  private double recall;
  @Column
  private double precision;
}
