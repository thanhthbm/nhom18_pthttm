package com.PTHTTM.nhom18.model;

import jakarta.persistence.CascadeType;
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
@Table(name = "tblTrainingJob")
@Getter
@Setter
public class TrainingJob {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private long id;

  @OneToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "tblModelVersionid")
  private ModelVersion modelVersion;

  @Column
  private String status;
  @Column(columnDefinition = "TEXT")
  private String errorMessage;

  @OneToOne(
      mappedBy = "job",
      cascade = CascadeType.ALL,
      orphanRemoval = true
  )
  private TrainingResult trainingResult;
}
