document.addEventListener("DOMContentLoaded", function () {
  var modal = document.getElementById("reviewModal");
  var modalTitle = document.getElementById("modalTitle");
  var loader = document.getElementById("loader");
  var modalReviewList = document.getElementById("modal-review-list");
  var selectAllContainer = document.getElementById("select-all-container");
  var selectAllCheckbox = document.getElementById("selectAllReviews");
  var btnCloseModal = document.getElementById("btn-close-modal");
  var btnConfirmSelection = document.getElementById("btn-confirm-selection");
  var btnStartTrain = document.getElementById("btn-start-train");
  var selectedCountEl = document.getElementById("selected-count");
  var selectedContainer = document.getElementById("selected-reviews-container");
  var trainForm = document.getElementById("trainForm");
  var versionNameInput = document.getElementById("versionName");

  var reviewCache = {};
  var currentDataSourceId = null;

  // Bắt sự kiện open modal
  var loadButtons = document.querySelectorAll(".btn-load-reviews");
  loadButtons.forEach(function (btn) {
    btn.addEventListener("click", function () {
      currentDataSourceId = btn.getAttribute("data-id");
      var dsName = btn.getAttribute("data-name");

      modalTitle.textContent = "Chọn mẫu từ: " + dsName;
      modalReviewList.innerHTML = "";
      loader.style.display = "block";
      selectAllContainer.style.display = "none";
      modal.style.display = "block";

      if (reviewCache[currentDataSourceId]) {
        populateModal(reviewCache[currentDataSourceId]);
      } else {
        fetchReviews(currentDataSourceId);
      }
    });
  });

  function fetchReviews(dataSourceId) {
    var url = "/api/reviews?dataSourceId=" + encodeURIComponent(dataSourceId);

    fetch(url)
    .then(function (res) {
      return res.json();
    })
    .then(function (reviews) {
      reviewCache[dataSourceId] = reviews;
      populateModal(reviews);
    })
    .catch(function (err) {
      console.error("Fetch error:", err);
      loader.style.display = "none";
      modalReviewList.innerHTML = "<p style='color:red;'>Lỗi khi tải review.</p>";
    });
  }

  function populateModal(reviews) {
    loader.style.display = "none";
    modalReviewList.innerHTML = "";

    if (!reviews || reviews.length === 0) {
      modalReviewList.innerHTML = "<p>Không có mẫu nào.</p>";
      return;
    }

    // Lấy danh sách review đang được chọn (đã confirm từ trước)
    var selectedInputs = selectedContainer.querySelectorAll('input[name="reviewIds"]');
    var selectedIds = [];
    selectedInputs.forEach(function (input) {
      selectedIds.push(input.value);
    });

    var html = "";
    reviews.forEach(function (review) {
      var id = review.id;
      var content = review.content || "";
      var sentiment = review.sentiment || "";
      var checked = selectedIds.indexOf(String(id)) !== -1 ? "checked" : "";

      html +=
          '<label class="review-item">' +
          '<input type="checkbox" class="review-checkbox" value="' + id + '" ' + checked + '>' +
          content + ' <code>(' + sentiment + ')</code>' +
          '</label>';
    });

    modalReviewList.innerHTML = html;
    selectAllContainer.style.display = "block";
    selectAllCheckbox.checked = false;
  }

  // Chọn tất cả
  selectAllCheckbox.addEventListener("change", function () {
    var checkboxes = modalReviewList.querySelectorAll(".review-checkbox");
    checkboxes.forEach(function (cb) {
      cb.checked = selectAllCheckbox.checked;
    });
  });

  // Xác nhận chọn review
  btnConfirmSelection.addEventListener("click", function () {
    var checkboxes = modalReviewList.querySelectorAll(".review-checkbox");

    // Bỏ các id không chọn
    checkboxes.forEach(function (cb) {
      var id = cb.value;
      var existing = selectedContainer.querySelector('input[name="reviewIds"][value="' + id + '"]');

      if (cb.checked) {
        if (!existing) {
          var hidden = document.createElement("input");
          hidden.type = "hidden";
          hidden.name = "reviewIds";
          hidden.value = id;
          selectedContainer.appendChild(hidden);
        }
      } else {
        if (existing) {
          existing.remove();
        }
      }
    });

    var total = selectedContainer.querySelectorAll('input[name="reviewIds"]').length;
    selectedCountEl.textContent = "Đã chọn: " + total + " mẫu";
    btnStartTrain.disabled = total === 0;

    modal.style.display = "none";
  });

  // Đóng modal
  btnCloseModal.addEventListener("click", function () {
    modal.style.display = "none";
  });
  window.addEventListener("click", function (e) {
    if (e.target === modal) {
      modal.style.display = "none";
    }
  });

  // Validate form train
  trainForm.addEventListener("submit", function (e) {
    var total = selectedContainer.querySelectorAll('input[name="reviewIds"]').length;
    if (total === 0) {
      alert("Vui lòng chọn ít nhất 1 review.");
      e.preventDefault();
      return;
    }
    if (!versionNameInput.value.trim()) {
      alert("Vui lòng nhập tên phiên bản.");
      e.preventDefault();
      return;
    }
    btnStartTrain.disabled = true;
    btnStartTrain.textContent = "Đang gửi...";
  });

});
