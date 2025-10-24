package com.PTHTTM.nhom18.repository;

import com.PTHTTM.nhom18.model.TrainingReview;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface TrainingReviewRepository extends JpaRepository<TrainingReview,Long> {

}
