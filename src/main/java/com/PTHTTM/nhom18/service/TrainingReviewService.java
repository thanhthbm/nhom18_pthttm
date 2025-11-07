package com.PTHTTM.nhom18.service;

import com.PTHTTM.nhom18.dto.TrainingReviewDTO;
import com.PTHTTM.nhom18.model.DataSource;
import com.PTHTTM.nhom18.model.TrainingReview;
import com.PTHTTM.nhom18.repository.TrainingReviewRepository;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.xml.crypto.Data;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DataFormatter;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

@Service
public class TrainingReviewService {
  private final TrainingReviewRepository trainingReviewRepository;

  public TrainingReviewService(TrainingReviewRepository trainingReviewRepository) {
    this.trainingReviewRepository = trainingReviewRepository;
  }

  public List<TrainingReview> handleSaveAll(DataSource dataSource) throws IOException {
    List<TrainingReview> trainingReviews = new ArrayList<>();
    FileInputStream file = new FileInputStream(new File(dataSource.getFileUrl()));
    Workbook workbook = new XSSFWorkbook(file);
    DataFormatter dataFormatter = new DataFormatter();

    Sheet sheet = workbook.getSheetAt(0);
    Row headerRow = sheet.getRow(0);
    int contentCol = -1;
    int sentimentCol = -1;

    for (Cell cell : headerRow) {
      String header = dataFormatter.formatCellValue(cell).trim();
      if ("content".equalsIgnoreCase(header)) {
        contentCol = cell.getColumnIndex();
      }
      if ("sentiment".equalsIgnoreCase(header)) {
        sentimentCol = cell.getColumnIndex();
      }
    }

    for (int i = 1; i <= sheet.getLastRowNum(); i++) {
      Row row = sheet.getRow(i);

      Cell contentCell = row.getCell(contentCol);
      Cell sentimentCell = row.getCell(sentimentCol);
      TrainingReview trainingReview = new TrainingReview();
      trainingReview.setContent(dataFormatter.formatCellValue(contentCell));
      trainingReview.setSentiment(dataFormatter.formatCellValue(sentimentCell));
      trainingReview.setDataSource(dataSource);

      trainingReviews.add(trainingReview);
    }

    dataSource.setReviews(trainingReviews);

    return trainingReviewRepository.saveAll(trainingReviews);
  }

  public List<TrainingReviewDTO> handleFindByDataSource(DataSource dataSource){
    return this.trainingReviewRepository.findByDataSource(dataSource);
  }

}
