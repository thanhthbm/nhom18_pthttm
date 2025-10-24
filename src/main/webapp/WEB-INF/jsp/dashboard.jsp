<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%-- Cần cho format số và ngày --%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Bảng điều khiển - AI</title>

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
      * {
        box-sizing: border-box;
      }
      body {
        margin: 0;
        font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica,
        Arial, sans-serif;
        color: var(--text);
        background: var(--bg);
      }

      /* Header (Nav trên cùng) */
      header {
        background: #fff;
        border-bottom: 1px solid var(--border);
        display: flex;
        justify-content: center; /* Đưa tab ra giữa */
        align-items: center;
        padding: 0 20px;
        height: 56px;
      }
      .tabs {
        display: flex;
        gap: 8px;
      }
      .tab {
        text-decoration: none;
        color: #374151;
        padding: 8px 12px;
        border-radius: 8px;
        font-weight: 500;
      }
      .tab.active {
        background: var(--primary-weak);
        color: #1e40af;
      }

      /* Main */
      main {
        padding: 24px;
        max-width: 1200px; /* Giới hạn chiều rộng */
        margin: 0 auto; /* Căn giữa */
      }
      .page-title {
        font-size: 24px;
        font-weight: 700;
        margin-bottom: 20px;
      }
      .panels {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
      }
      .panel {
        background: var(--panel);
        border: 1px solid var(--border);
        border-radius: 12px;
        padding: 24px;
        display: flex;
        flex-direction: column;
        gap: 20px;
      }
      .panel-head {
        display: flex;
        justify-content: space-between;
        flex-wrap: wrap;
      }
      .panel-title {
        font-size: 18px;
        font-weight: 700;
        line-height: 1.3;
      }
      .panel-sub {
        font-size: 13px;
        color: var(--muted);
      }

      /* Metric cards */
      .metrics {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 14px;
      }
      .metric {
        border: 1px solid var(--border);
        border-radius: 10px;
        padding: 16px;
        display: flex;
        flex-direction: column;
        gap: 8px;
        min-height: 120px;
        background: #f9fafb;
      }
      .metric h4 {
        margin: 0;
        font-size: 14px;
        font-weight: 700;
        color: #374151;
      }
      .metric .val {
        font-size: 28px;
        font-weight: 800;
        color: var(--primary);
      }

      /* Buttons */
      .btn {
        align-self: start;
        background: var(--primary);
        color: #fff;
        border: none;
        border-radius: 8px;
        padding: 12px 18px;
        font-weight: 600;
        cursor: pointer;
        text-decoration: none; /* Thêm cho thẻ <a> */
      }
      .btn:disabled {
        background: #9ca3af;
        cursor: not-allowed;
      }

      /* Thông báo lỗi */
      .error {
        padding: 12px 16px;
        border-radius: 8px;
        background: #fef2f2;
        color: #b91c1c;
        border: 1px solid #fecaca;
        margin-bottom: 20px;
      }

      /* Responsive */
      @media (max-width: 900px) {
        .panels {
          grid-template-columns: 1fr;
        }
        .metrics {
          grid-template-columns: repeat(2, 1fr);
        }
      }
      @media (max-width: 600px) {
        main {
          padding: 16px;
        }
        .metrics {
          grid-template-columns: 1fr;
        }
      }
    </style>
</head>
<body>

<header>
    <div class="tabs">
        <a class="tab active" href="/admin/dashboard">Bảng điều khiển</a>
        <a class="tab" href="/admin/training/form">Huấn luyện Mô hình</a>
        <a class="tab" href="/admin/data/upload">Quản lý Dữ liệu</a>
    </div>
</header>

<main>
    <div class="page-title">Bảng điều khiển</div>

    <c:if test="${not empty error}">
        <p class="error">${error}</p>
    </c:if>

    <section class="panels">

        <article class="panel">
            <div class="panel-head">
                <div>
                    <div class="panel-title">Mô hình cảm xúc tổng quát (Active)</div>
                    <c:if test="${not empty activeModel}">
                        <div class="panel-sub">
                            Phiên bản: <strong>${activeModel.name}</strong>
<%--                            | Kích hoạt:--%>
<%--                            <fmt:formatDate value="${activeModel.createdAt}" pattern="dd/MM/yyyy HH:mm" />--%>
                        </div>
                    </c:if>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty activeResult}">
                    <div class="metrics">
                        <div class="metric">
                            <h4>Điểm F1 (Macro)</h4>
                            <div class="val">
                                <fmt:formatNumber value="${activeResult.f1Score}" pattern="#0.0000" />
                            </div>
                        </div>
                        <div class="metric">
                            <h4>Độ chính xác</h4>
                            <div class="val">
                                <fmt:formatNumber value="${activeResult.accuracy}" pattern="#0.0000" />
                            </div>
                        </div>
                        <div class="metric">
                            <h4>Precision (Macro)</h4>
                            <div class="val">
                                <fmt:formatNumber value="${activeResult.precision}" pattern="#0.0000" />
                            </div>
                        </div>
                        <div class="metric">
                            <h4>Recall (Macro)</h4>
                            <div class="val">
                                <fmt:formatNumber value="${activeResult.recall}" pattern="#0.0000" />%
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <p style="color: var(--muted);">Chưa có mô hình nào được kích hoạt hoặc không tìm thấy kết quả.</p>
                </c:otherwise>
            </c:choose>

            <a href="/admin/training/form" class="btn">
                Huấn luyện phiên bản mới
            </a>
        </article>

        <article class="panel">
            <div class="panel-head">
                <div>
                    <div class="panel-title">Mô hình dựa trên khía cạnh</div>
                    <div class="panel-sub">
                        Cập nhật lần cuối: (Chưa hỗ trợ)
                    </div>
                </div>
            </div>

            <div class="metrics">
                <div class="metric">
                    <h4>Điểm F1</h4>
                    <div class="val" style="color: var(--muted);">N/A</div>
                </div>
                <div class="metric">
                    <h4>Độ chính xác</h4>
                    <div class="val" style="color: var(--muted);">N/A</div>
                </div>
                <div class="metric">
                    <h4>Precision</h4>
                    <div class="val" style="color: var(--muted);">N/A</div>
                </div>
                <div class="metric">
                    <h4>Recall</h4>
                    <div class="val" style="color: var(--muted);">N/A%</div>
                </div>
            </div>

            <a class="btn" disabled href="/admin/training/form">Huấn luyện lại mô hình</a>
        </article>

    </section>
</main>
</body>
</html>