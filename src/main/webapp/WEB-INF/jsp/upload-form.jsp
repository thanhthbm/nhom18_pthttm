<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Upload Training Data</title>
    <style>
      body { font-family: sans-serif; padding: 20px; }
      .form-group { margin-bottom: 15px; }
      label { display: block; margin-bottom: 5px; }
      input[type="text"], input[type="file"] { width: 300px; padding: 8px; }
      button { padding: 10px 15px; cursor: pointer; }
      .message { color: green; margin-top: 15px; }
      .error { color: red; margin-top: 15px; }
    </style>
</head>
<body>

<h1>Upload Training Data File (.xlsx)</h1>

<c:if test="${not empty message}">
    <p class="message">${message}</p>
</c:if>
<c:if test="${not empty error}">
    <p class="error">${error}</p>
</c:if>

<form method="POST" action="/admin/data/upload" enctype="multipart/form-data">
    <div class="form-group">
        <label for="dataSourceName">Data Source Name:</label>
        <input type="text" id="dataSourceName" name="dataSourceName" placeholder="e.g., Data T10/2025" required>
    </div>
    <div class="form-group">
        <label for="file">Select Excel File:</label>
        <input type="file" id="file" name="file" accept=".xlsx, .xls" required>
    </div>
    <button type="submit">Upload and Save</button>
</form>

<hr>
<p><a href="/admin/training/form">Go to Train Model Page</a></p>

</body>
</html>