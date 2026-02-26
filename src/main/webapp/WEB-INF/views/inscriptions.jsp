<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Inscriptions - ERP Universitaire</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<%@ include file="navbar.jsp" %>

<div class="container mt-4">
    <div class="alert alert-info">
        La page de liste des inscriptions n'est pas encore branchée. Utilise le menu <strong>Nouvelle Inscription</strong>.
    </div>

    <div class="mt-3">
        <a class="btn btn-primary" href="${pageContext.request.contextPath}/inscriptions?action=new">➕ Nouvelle Inscription</a>
        <a class="btn btn-outline-dark" href="${pageContext.request.contextPath}/admin/inscriptions">Admin: Workflow Validation</a>
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/logout">Logout</a>
    </div>
</div>

</body>
</html>
