package com.PTHTTM.nhom18.repository;

import com.PTHTTM.nhom18.model.TrainingJob;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TrainingJobRepository extends JpaRepository<TrainingJob, Long> {

}
