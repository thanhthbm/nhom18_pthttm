<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> <%-- For number formatting --%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Training Result</title>
    <style>
      body { font-family: sans-serif; padding: 20px; }
      .result-box { border: 1px solid #ccc; padding: 15px; margin-top: 15px; }
      .success { border-color: green; background-color: #e9fde9; }
      .failure { border-color: red; background-color: #fdeaea; }
      .metrics dt { font-weight: bold; float: left; width: 150px; clear: left; }
      .metrics dd { margin-left: 160px; margin-bottom: 5px;}
      .actions button { margin-right: 10px; padding: 8px 12px; }
    </style>
</head>
<body>

<h1>Training Job Result</h1>

<c:if test="${not empty job}">
    <p><strong>Job ID:</strong> ${job.id}</p>
    <p><strong>Model Version:</strong> ${job.modelVersion.name}</p>

    <c:choose>
        <%-- Case 1: Training Successful --%>
        <c:when test="${job.status == 'COMPLETED'}">
            <div class="result-box success">
                <h2>Training Completed Successfully!</h2>
                <c:if test="${not empty result}">
                    <h3>Metrics:</h3>
                    <dl class="metrics">
                        <dt>Accuracy:</dt>
                        <dd><fmt:formatNumber value="${result.accuracy}" pattern="#0.0000" /></dd>

                        <dt>F1 Score (Macro):</dt>
                        <dd><fmt:formatNumber value="${result.f1Score}" pattern="#0.0000" /></dd>

                        <dt>Precision (Macro):</dt>
                        <dd><fmt:formatNumber value="${result.precision}" pattern="#0.0000" /></dd> <%-- Display if available --%>

                        <dt>Recall (Macro):</dt>
                        <dd><fmt:formatNumber value="${result.recall}" pattern="#0.0000" /></dd> <%-- Display if available --%>
                    </dl>
                    <p><strong>Model saved at:</strong> <code>${job.modelVersion.checkpointUrl}</code></p>
                </c:if>
                <c:if test="${empty result}">
                    <p style="color:orange;">Training completed, but metric results were not found.</p>
                </c:if>

                <div class="actions">
                    <form method="POST" action="/admin/training/approve/${job.id}" style="display:inline;">
                        <button type="submit">Approve and Activate Model</button>
                    </form>
                    <a href="/admin/training/form"><button type="button">Discard</button></a> <%-- Simple link back --%>
                </div>

            </div>
        </c:when>

        <%-- Case 2: Training Failed --%>
        <c:when test="${job.status == 'FAILED'}">
            <div class="result-box failure">
                <h2>Training Failed!</h2>
                <p><strong>Error Message:</strong></p>
                <pre>${job.errorMessage}</pre>
                <a href="/admin/training/form"><button type="button">Back to Form</button></a>
            </div>
        </c:when>

        <%-- Case 3: Other Status (Should ideally not happen on this page) --%>
        <c:otherwise>
            <p>Job status is: ${job.status}. Result details are not available yet.</p>
            <a href="/admin/training/form"><button type="button">Back to Form</button></a>
        </c:otherwise>
    </c:choose>

</c:if>
<c:if test="${empty job}">
    <p style="color:red;">Error: Job details could not be loaded.</p>
    <a href="/admin/training/form"><button type="button">Back to Form</button></a>
</c:if>

</body>
</html>