package com.PTHTTM.nhom18.controller;

import com.PTHTTM.nhom18.model.ModelVersion;
import com.PTHTTM.nhom18.model.TrainingResult;
import com.PTHTTM.nhom18.repository.TrainingResultRepository;
import com.PTHTTM.nhom18.service.ModelVersionService;
import com.PTHTTM.nhom18.service.TrainingResultService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin")
public class DashboardController {
  private final ModelVersionService  modelVersionService;
  private final TrainingResultService trainingResultService;

  public DashboardController(ModelVersionService modelVersionService, TrainingResultService trainingResultService) {
    this.modelVersionService = modelVersionService;
    this.trainingResultService = trainingResultService;
  }

  @GetMapping(value = {"", "/", "/dashboard"})
  public String dashboard(Model model, RedirectAttributes redirectAttributes) {
    ModelVersion modelVersion = modelVersionService.findActiveModelVersion();

    TrainingResult activeResult = trainingResultService.findByJob(modelVersion.getTrainingJob());

    model.addAttribute("activeModel",  modelVersion);
    model.addAttribute("activeResult", activeResult);
    return "dashboard";
  }
}
