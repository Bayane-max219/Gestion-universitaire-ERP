<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Étudiants - ERP Universitaire</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .container-box { background: white; padding: 20px; border-radius: 10px; box-shadow: 0px 0px 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body class="py-0">

<%-- Inclusion de la barre de navigation --%>
<%@ include file="navbar.jsp" %>

<div class="container mt-4 container-box">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-primary">Liste des Étudiants</h2>
        <a href="etudiants?action=new" class="btn btn-primary">
            Ajouter un étudiant
        </a>
    </div>

    <table class="table table-hover table-bordered">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Nom</th>
            <th>Prénom</th>
            <th>Email</th>
            <th class="text-center">Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="e" items="${etudiants}">
            <tr>
                <td>${e.id}</td>
                <td>${e.nom}</td>
                <td>${e.prenom}</td>
                <td>${e.email}</td>
                <td class="text-center">
                    <a href="etudiants?action=edit&id=${e.id}" class="btn btn-sm btn-warning">Modifier</a>

                    <a href="etudiants?action=delete&id=${e.id}"
                       class="btn btn-sm btn-danger"
                       onclick="return confirm('Voulez-vous vraiment supprimer cet étudiant ?')">
                        Supprimer
                    </a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty etudiants}">
            <tr>
                <td colspan="5" class="text-center text-muted">Aucun étudiant enregistré.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

</body>
</html>