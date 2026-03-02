<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Programmes - ERP Universitaire</title>
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
        <h2 class="text-primary">Liste des Programmes Pédagogiques</h2>
        <a href="programmes?action=new" class="btn btn-primary">
            Ajouter un programme
        </a>
    </div>

    <table class="table table-hover table-bordered">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Matière</th>
            <th>Chapitre</th>
            <th>Description</th>
            <th>Ordre</th>
            <th class="text-center">Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="p" items="${programmes}">
            <tr>
                <td>${p.id}</td>
                <td>${p.matiere.nom}</td>
                <td>${p.chapitre}</td>
                <td>${p.description}</td>
                <td>${p.ordre}</td>
                <td class="text-center">
                    <a href="programmes?action=edit&id=${p.id}" class="btn btn-sm btn-warning">Modifier</a>
                    
                    <a href="programmes?action=delete&id=${p.id}"
                       class="btn btn-sm btn-danger"
                       onclick="return confirm('Voulez-vous vraiment supprimer ce programme ?')">
                        Supprimer
                    </a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty programmes}">
            <tr>
                <td colspan="6" class="text-center text-muted">Aucun programme pédagogique enregistré.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

</body>
</html>