package com.PTHTTM.nhom18.repository;

import com.PTHTTM.nhom18.dto.TrainingReviewDTO;
import com.PTHTTM.nhom18.model.DataSource;
import com.PTHTTM.nhom18.model.TrainingReview;
import java.util.List;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface TrainingReviewRepository extends JpaRepository<TrainingReview, Long> {

  @Query("SELECT new com.PTHTTM.nhom18.dto.TrainingReviewDTO(tr.id, tr.content, tr.sentiment) " +
      "FROM TrainingReview tr " +
      "WHERE tr.dataSource = :dataSource")
  List<TrainingReviewDTO> findByDataSource(@Param("dataSource") DataSource dataSource);
}
