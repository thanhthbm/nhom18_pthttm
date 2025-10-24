<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <%-- Import JSTL --%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Train Sentiment Model</title>
    <style>
      body { font-family: sans-serif; padding: 20px; }
      .form-group { margin-bottom: 15px; }
      label { display: block; margin-bottom: 5px; font-weight: bold; }
      input[type="text"] { width: 300px; padding: 8px; }
      .data-source-list { border: 1px solid #ccc; padding: 10px; max-height: 200px; overflow-y: auto; margin-bottom: 15px; }
      .data-source-item { display: block; margin-bottom: 5px; }
      button { padding: 10px 15px; cursor: pointer; }
      .message { color: green; margin-top: 15px; }
      .error { color: red; margin-top: 15px; }
    </style>
</head>
<body>

<h1>Train New Sentiment Model Version</h1>

<c:if test="${not empty message}">
    <p class="message">${message}</p>
</c:if>
<c:if test="${not empty error}">
    <p class="error">${error}</p>
</c:if>

<form method="POST" action="/admin/training/start">
    <div class="form-group">
        <label for="versionName">New Model Version Name:</label>
        <input type="text" id="versionName" name="versionName" placeholder="e.g., v1.1-improved" required>
    </div>

    <div class="form-group">
        <label>Select Data Sources to Train On:</label>
        <div class="data-source-list">
            <c:choose>
                <c:when test="${not empty dataSources}">
                    <c:forEach var="ds" items="${dataSources}">
                        <label class="data-source-item">
                            <input type="checkbox" name="dataSourceIds" value="${ds.id}">
                                ${ds.name} (${ds.recordCount} records, created: ${ds.createdAt})
                        </label>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p>No Data Sources found. Please <a href="/admin/data/upload">upload data</a> first.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <button type="submit" <c:if test="${empty dataSources}">disabled</c:if> >
        Start Training
    </button>
</form>
<hr>
<p><a href="/admin/data/upload">Upload New Data</a></p>

</body>
</html>