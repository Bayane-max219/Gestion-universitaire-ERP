<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Notifications</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<%@ include file="navbar.jsp" %>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="text-primary">Notifications</h2>
        <a class="btn btn-danger btn-sm text-white" href="${pageContext.request.contextPath}/logout">Déconnexion</a>
    </div>

    <table class="table table-hover table-bordered bg-white">
        <thead class="table-dark">
        <tr>
            <th>Date</th>
            <th>Inscription</th>
            <th>Message</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="n" items="${notifications}">
            <tr>
                <td>${n.createdAt}</td>
                <td>${n.inscription.id} - ${n.inscription.etudiant.nom} ${n.inscription.etudiant.prenom}</td>
                <td>${n.message}</td>
            </tr>
        </c:forEach>

        <c:if test="${empty notifications}">
            <tr>
                <td colspan="3" class="text-center text-muted">Aucune notification.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

</body>
</html>
