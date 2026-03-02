<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Professeurs - ERP Universitaire</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .container-box { background: white; padding: 20px; border-radius: 10px; box-shadow: 0px 0px 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body class="py-0">

<%@ include file="navbar.jsp" %>

<div class="container mt-4 container-box">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-primary">Liste des Professeurs</h2>
        <a href="professeurs?action=new" class="btn btn-primary">
            Ajouter un professeur
        </a>
    </div>

    <table class="table table-hover table-bordered">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Nom</th>
            <th>Prénom</th>
            <th>Email</th>
            <th>Téléphone</th>
            <th class="text-center">Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="p" items="${professeurs}">
            <tr>
                <td>${p.id}</td>
                <td>${p.nom}</td>
                <td>${p.prenom}</td>
                <td>${p.email}</td>
                <td>${p.telephone}</td>
                <td class="text-center">
                    <a href="professeurs?action=edit&id=${p.id}" class="btn btn-sm btn-warning">Modifier</a>
                    
                    <a href="professeurs?action=delete&id=${p.id}"
                       class="btn btn-sm btn-danger"
                       onclick="return confirm('Voulez-vous vraiment supprimer ce professeur ?')">
                        Supprimer
                    </a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty professeurs}">
            <tr>
                <td colspan="6" class="text-center text-muted">Aucun professeur enregistré.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

</body>
</html>