package com.PTHTTM.nhom18.model;

import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "tblDataSource")
@Getter
@Setter
public class DataSource {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @Column(nullable = false)
  private String name;

  @Column(nullable = false)
  private int recordCount;

  @Column(nullable = false)
  private LocalDateTime createdAt = LocalDateTime.now();

  @OneToMany(
      mappedBy = "dataSource",
      cascade = CascadeType.ALL,
      orphanRemoval = true
  )
  private List<TrainingReview> listReview = new ArrayList<>();

}
