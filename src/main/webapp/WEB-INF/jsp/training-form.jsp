<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Huấn luyện Mô hình</title>

    <style>
      :root {
        --bg: #f5f6f8;
        --panel: #ffffff;
        --text: #111827;
        --muted: #6b7280;
        --primary: #2563eb;
        --primary-weak: #e6efff;
        --border: #e5e7eb;
      }
      * { box-sizing: border-box; }
      body {
        margin: 0; font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica,
      Arial, sans-serif; color: var(--text); background: var(--bg);
      }
      header {
        background: #fff; border-bottom: 1px solid var(--border); display: flex;
        justify-content: center; align-items: center; padding: 0 20px; height: 56px;
      }
      .tabs { display: flex; gap: 8px; }
      .tab {
        text-decoration: none; color: #374151; padding: 8px 12px;
        border-radius: 8px; font-weight: 500;
      }
      .tab.active { background: var(--primary-weak); color: #1e40af; }
      main { padding: 24px; max-width: 900px; margin: 0 auto; }
      .page-title { font-size: 24px; font-weight: 700; margin-bottom: 20px; }
      .panel {
        background: var(--panel); border: 1px solid var(--border);
        border-radius: 12px; padding: 24px; display: flex;
        flex-direction: column; gap: 20px; margin-bottom: 20px;
      }
      .panel-head {
        display: flex; justify-content: space-between; flex-wrap: wrap;
        border-bottom: 1px solid var(--border); padding-bottom: 16px; margin-bottom: 8px;
      }
      .panel-title { font-size: 18px; font-weight: 700; }
      .form-group { margin-bottom: 20px; }
      .form-group label {
        display: block; margin-bottom: 8px; font-weight: 600; font-size: 14px;
      }
      .form-control {
        width: 100%; padding: 10px 12px; border: 1px solid var(--border);
        border-radius: 8px; font-size: 14px; background: #fff;
      }

      .data-source-list {
        margin-bottom: 15px;
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
      }
      .data-source-item {
        background-color: #fff;
        border: 1px solid var(--border);
        padding: 10px 14px;
        border-radius: 6px;
        cursor: pointer;
        font-weight: 500;
      }
      .data-source-item:hover { background: var(--primary-weak); }

      .btn {
        align-self: start; background: var(--primary); color: #fff;
        border: none; border-radius: 8px; padding: 12px 18px;
        font-weight: 600; cursor: pointer; text-decoration: none;
        display: inline-block;
      }
      .btn:disabled { background: #9ca3af; cursor: not-allowed; }
      .message {
        padding: 12px 16px; border-radius: 8px; background: #f0fdf4;
        color: #15803d; border: 1px solid #bbf7d0; margin-bottom: 20px;
      }
      .error {
        padding: 12px 16px; border-radius: 8px; background: #fef2f2;
        color: #b91c1c; border: 1px solid #fecaca; margin-bottom: 20px;
      }
      @media (max-width: 600px) { main { padding: 16px; } }

      /* Modal */
      .modal {
        display: none; position: fixed; z-index: 1000;
        left: 0; top: 0; width: 100%; height: 100%; overflow: auto;
        background-color: rgba(0,0,0,0.4);
      }
      .modal-content {
        background-color: #fefefe; margin: 10% auto; padding: 20px;
        border: 1px solid #888; border-radius: 12px; width: 80%; max-width: 700px;
      }
      .modal-header {
        padding-bottom: 10px; border-bottom: 1px solid var(--border);
        font-size: 18px; font-weight: 600;
      }
      .modal-body {
        padding-top: 15px; max-height: 400px; overflow-y: auto;
      }
      .modal-footer {
        padding-top: 15px; border-top: 1px solid var(--border); text-align: right;
      }
      .review-item {
        display: block; margin-bottom: 8px; padding: 8px;
        font-size: 14px; border-radius: 6px;
      }
      .review-item:hover { background: #f0f9ff; }
      .review-item input { margin-right: 10px; }
      .review-item code { font-size: 12px; color: var(--muted); }
      #loader {
        display: none; text-align: center; color: var(--muted); padding: 20px;
      }
      #selected-count {
        font-size: 14px; color: var(--muted); margin-top: 10px;
      }
      .btn-secondary {
        background: #f3f4f6; color: var(--text);
      }
    </style>
</head>
<body>

<header>
    <div class="tabs">
        <a class="tab" href="/admin/dashboard">Bảng điều khiển</a>
        <a class="tab" href="/admin/data/upload">Quản lý dữ liệu</a>
        <a class="tab active" href="/admin/training/form">Huấn luyện Mô hình</a>
    </div>
</header>

<main>
    <div class="page-title">Huấn luyện phiên bản mô hình mới</div>

    <c:if test="${not empty message}">
        <p class="message">${message}</p>
    </c:if>
    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>

    <article class="panel">
        <div class="panel-head">
            <div class="panel-title">Cấu hình huấn luyện</div>
        </div>

        <form id="trainForm" method="POST" action="/admin/training/start">
            <div class="form-group">
                <label for="versionName">Tên phiên bản mô hình mới:</label>
                <input type="text" id="versionName" name="versionName" class="form-control"
                       placeholder="e.g., v1.1-improved" required>
            </div>

            <div class="form-group">
                <label>Chọn nguồn dữ liệu để thêm "mẫu":</label>

                <div class="data-source-list">
                    <c:choose>
                        <c:when test="${not empty dataSources}">
                            <c:forEach var="ds" items="${dataSources}">
                                <button type="button" class="data-source-item btn-load-reviews"
                                        data-id="${ds.id}" data-name="${ds.name}">
                                    ID: ${ds.id} ${ds.name}
                                    (${ds.reviews.size()} mẫu)
                                </button>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p>Không tìm thấy nguồn dữ liệu.
                                Vui lòng <a href="/admin/data/upload">tải lên dữ liệu</a> trước.
                            </p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- "Giỏ hàng" ẩn chứa các ID đã chọn -->
            <div id="selected-reviews-container" style="display: none;"></div>
            <div id="selected-count">Đã chọn: 0 mẫu</div>

            <button type="submit" class="btn" id="btn-start-train" disabled>
                Bắt đầu Huấn luyện
            </button>
        </form>
    </article>
</main>

<!-- MODAL -->
<div id="reviewModal" class="modal">
    <div class="modal-content">
        <div class="modal-header" id="modalTitle">Đang tải...</div>
        <div class="modal-body">
            <div id="loader">Đang tải review...</div>
            <div class="form-group" style="border-bottom: 1px solid #ccc; padding-bottom: 10px; display: none;" id="select-all-container">
                <label>
                    <input type="checkbox" id="selectAllReviews">
                    <strong>Chọn/Bỏ chọn tất cả</strong>
                </label>
            </div>
            <div id="modal-review-list"></div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" id="btn-close-modal">Đóng</button>
            <button type="button" class="btn" id="btn-confirm-selection">Xác nhận chọn</button>
        </div>
    </div>
</div>

<script>
  function esc(s){
    return String(s).replace(/[&<>"']/g, function(m){
      return ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[m]);
    });
  }

  document.addEventListener('DOMContentLoaded', function() {
    var modal = document.getElementById('reviewModal');
    var modalTitle = document.getElementById('modalTitle');
    var loader = document.getElementById('loader');
    var modalReviewList = document.getElementById('modal-review-list');
    var selectAllContainer = document.getElementById('select-all-container');
    var selectAllCheckbox = document.getElementById('selectAllReviews');
    var btnCloseModal = document.getElementById('btn-close-modal');
    var btnConfirmSelection = document.getElementById('btn-confirm-selection');
    var btnStartTrain = document.getElementById('btn-start-train');
    var selectedCountEl = document.getElementById('selected-count');
    var selectedContainer = document.getElementById('selected-reviews-container');
    var trainForm = document.getElementById('trainForm');
    var versionNameInput = document.getElementById('versionName');

    var reviewCache = new Map();
    var currentDataSourceId = null;

    // Mở modal & load reviews
    document.querySelectorAll('.btn-load-reviews').forEach(function(button){
      button.addEventListener('click', function() {
        var dsId = this.dataset.id;
        var dsName = this.dataset.name;
        currentDataSourceId = dsId;

        modalTitle.textContent = 'Chọn mẫu từ: ' + dsName;
        modalReviewList.innerHTML = '';
        selectAllContainer.style.display = 'none';
        loader.style.display = 'block';
        modal.style.display = 'block';

        if (reviewCache.has(currentDataSourceId)) {
          populateModal(reviewCache.get(currentDataSourceId));
        } else {
          fetchReviews(currentDataSourceId);
        }
      });
    });

    // Gọi API
    function fetchReviews(dataSourceId) {
      var url = '/api/reviews?dataSourceId=' + encodeURIComponent(dataSourceId);
      fetch(url)
      .then(function(response){
        if (!response.ok) throw new Error('Network error');
        return response.json();
      })
      .then(function(reviews){
        reviewCache.set(dataSourceId, reviews);
        populateModal(reviews);
      })
      .catch(function(error){
        console.error('Lỗi khi tải review:', error);
        loader.style.display = 'none';
        modalReviewList.innerHTML = '<p style="color:red;">Lỗi khi tải danh sách review.</p>';
      });
    }

    // Hiển thị review trong Modal (KHÔNG dùng template literal)
    function populateModal(reviews) {
      loader.style.display = 'none';
      modalReviewList.innerHTML = '';

      if (!reviews || reviews.length === 0) {
        modalReviewList.innerHTML = '<p>Không tìm thấy mẫu nào trong DataSource này.</p>';
        return;
      }

      var selectedIds = new Set();
      document.querySelectorAll('#selected-reviews-container input[name="reviewIds"]').forEach(function(input){
        selectedIds.add(input.value);
      });

      reviews.forEach(function(review){
        var id = (review && review.id != null) ? String(review.id) : '';
        var content = (review && review.content != null) ? String(review.content) : '';
        var sentiment = (review && review.sentiment != null) ? String(review.sentiment) : '';

        var isChecked = selectedIds.has(id);

        var label = document.createElement('label');
        label.className = 'review-item';

        var cb = document.createElement('input');
        cb.type = 'checkbox';
        cb.className = 'review-checkbox';
        cb.value = id;
        if (isChecked) cb.checked = true;

        var textNode = document.createTextNode(' ' + content + ' ');
        var code = document.createElement('code');
        code.textContent = '(' + sentiment + ')';

        label.appendChild(cb);
        label.appendChild(textNode);
        label.appendChild(code);

        modalReviewList.appendChild(label);
      });

      selectAllContainer.style.display = 'block';
      selectAllCheckbox.checked = false;
    }

    // Chọn tất cả
    selectAllCheckbox.addEventListener('change', function(){
      modalReviewList.querySelectorAll('.review-checkbox').forEach(function(cb){
        cb.checked = selectAllCheckbox.checked;
      });
    });

    // Xác nhận chọn
    btnConfirmSelection.addEventListener('click', function(){
      var selectedInModal = new Set();
      modalReviewList.querySelectorAll('.review-checkbox:checked').forEach(function(cb){
        selectedInModal.add(cb.value);
      });

      var unselectedInModal = new Set();
      modalReviewList.querySelectorAll('.review-checkbox:not(:checked)').forEach(function(cb){
        unselectedInModal.add(cb.value);
      });

      // Xóa những ID bỏ chọn
      unselectedInModal.forEach(function(id){
        var inputToRemove = selectedContainer.querySelector('input[name="reviewIds"][value="' + id + '"]');
        if (inputToRemove) inputToRemove.remove();
      });

      // Thêm ID mới
      selectedInModal.forEach(function(id){
        var exists = selectedContainer.querySelector('input[name="reviewIds"][value="' + id + '"]');
        if (!exists) {
          var hiddenInput = document.createElement('input');
          hiddenInput.type = 'hidden';
          hiddenInput.name = 'reviewIds';
          hiddenInput.value = id;
          selectedContainer.appendChild(hiddenInput);
        }
      });

      // Cập nhật đếm
      var totalSelected = selectedContainer.querySelectorAll('input[name="reviewIds"]').length;
      selectedCountEl.textContent = 'Đã chọn: ' + totalSelected + ' mẫu';
      btnStartTrain.disabled = (totalSelected === 0);

      modal.style.display = 'none';
    });

    // Đóng modal
    btnCloseModal.addEventListener('click', function(){
      modal.style.display = 'none';
    });
    window.onclick = function(event){
      if (event.target === modal) modal.style.display = 'none';
    };

    // Submit form
    trainForm.addEventListener('submit', function(e){
      var totalSelected = selectedContainer.querySelectorAll('input[name="reviewIds"]').length;
      if (totalSelected === 0) {
        e.preventDefault();
        alert('Vui lòng chọn ít nhất một review để train.');
        return;
      }
      if (!versionNameInput.value.trim()) {
        e.preventDefault();
        alert('Vui lòng nhập tên phiên bản.');
        return;
      }
      btnStartTrain.disabled = true;
      btnStartTrain.textContent = 'Đang gửi...';
    });
  });
</script>

</body>
</html>
