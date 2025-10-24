package com.PTHTTM.nhom18.model;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToOne;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.Getter;
import lombok.Setter;

@Entity
@Getter
@Setter
@Table(name = "tblModelVersion")
public class ModelVersion {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private long id;

  @Column(nullable = false)
  private String name;

  @Column
  private String checkpointUrl;

  @Column(nullable = false)
  private boolean active;

  @Column(nullable = false)
  private String modelType;

  @OneToOne(
      mappedBy = "modelVersion",
      cascade = CascadeType.ALL
  )
  private TrainingJob trainingJob;

  @Column
  private String notes;
  @Column
  private LocalDateTime createdAt = LocalDateTime.now();
}
