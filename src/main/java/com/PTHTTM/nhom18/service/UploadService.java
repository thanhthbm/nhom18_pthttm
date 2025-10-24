package com.PTHTTM.nhom18.service;

import com.PTHTTM.nhom18.model.DataSource;
import com.PTHTTM.nhom18.model.TrainingReview;
import com.PTHTTM.nhom18.repository.DataSourceRepository;
import com.PTHTTM.nhom18.repository.TrainingReviewRepository;
import java.io.DataInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
public class UploadService {
  private DataSourceRepository dataSourceRepository;

  public UploadService(DataSourceRepository dataSourceRepository ) {
    this.dataSourceRepository = dataSourceRepository;
  }

  @Transactional
  public DataSource saveUploadedFile(String name, MultipartFile file) throws IOException {
    DataSource dataSource = new DataSource();
    dataSource.setRecordCount(0);
    List<TrainingReview> trainingReviews = new ArrayList<>();

    //todo: luu file thanh cac dong training review
    InputStream inputStream = new DataInputStream(file.getInputStream());
    Workbook workbook = new XSSFWorkbook(inputStream);
    //lay sheet dau tien
    Sheet sheet = workbook.getSheetAt(0);
    //lay tat ca row
    Iterator<Row> rowIterator = sheet.iterator();
    while (rowIterator.hasNext()) {
      Row row = rowIterator.next();
      if (row.getRowNum() == 0) {
        continue;
      }

      TrainingReview trainingReview = new TrainingReview();

      // lay tat ca cell
      Iterator<Cell> cellIterator = row.cellIterator();

      while (cellIterator.hasNext()) {
        Cell cell = cellIterator.next();
        Object cellValue = getCellValue(cell);

        int columnIndex = cell.getColumnIndex();
        switch (columnIndex) {
          case 1:
            trainingReview.setRawText(cellValue.toString());
            break;
          case 2:
            trainingReview.setSentiment(cellValue.toString());
            break;
          default:
            break;
        }
      }
      trainingReview.setDataSource(dataSource);
      trainingReviews.add(trainingReview);
    }

    //todo: set cac gia tri cho data source
    dataSource.setName(name);
    dataSource.setListReview(trainingReviews);
    dataSource.setRecordCount(trainingReviews.size());
    return dataSourceRepository.save(dataSource);
  }

  private Object getCellValue(Cell cell) {
    CellType cellType = cell.getCellTypeEnum();
    switch (cellType) {
      case STRING:
        return cell.getStringCellValue();
      case NUMERIC:
        return cell.getNumericCellValue();
      case BOOLEAN:
        return cell.getBooleanCellValue();
      default:
        return null;
    }
  }


}
