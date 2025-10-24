package com.PTHTTM.nhom18.repository;

import com.PTHTTM.nhom18.model.TrainingJob;
import com.PTHTTM.nhom18.model.TrainingResult;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TrainingResultRepository extends JpaRepository<TrainingResult, Long> {

  TrainingResult findByJob(TrainingJob job);
}
