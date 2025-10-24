<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Training Status</title>
    <meta http-equiv="refresh" content="10">
    <style>
      body { font-family: sans-serif; padding: 20px; }
      .status { font-weight: bold; }
      .status-started { color: orange; }
      .status-training { color: blue; }
      /* Other statuses will redirect, so no specific styles needed here */
    </style>
</head>
<body>

<h1>Training Job Status</h1>

<c:if test="${not empty job}">
    <p><strong>Job ID:</strong> ${job.id}</p>
    <p><strong>Model Version:</strong> ${job.modelVersion.name}</p>
    <p><strong>Status:</strong>
        <span class="status status-${job.status.toLowerCase()}">${job.status}</span>
    </p>

    <c:choose>
        <c:when test="${job.status == 'STARTED'}">
            <p>The training request has been sent to the ML service. Please wait...</p>
        </c:when>
        <c:when test="${job.status == 'TRAINING'}"> <%-- Assuming Python might update status later --%>
            <p>The ML service is currently training the model. This might take a while...</p>
        </c:when>
        <c:otherwise>
            <p>Checking final status...</p> <%-- Should redirect shortly --%>
        </c:otherwise>
    </c:choose>

    <p><i>This page will automatically refresh every 10 seconds.</i></p>
</c:if>
<c:if test="${empty job}">
    <p style="color:red;">Error: Job details could not be loaded.</p>
</c:if>

<hr>
<p><a href="/admin/training/form">Back to Training Form</a></p>

</body>
</html>