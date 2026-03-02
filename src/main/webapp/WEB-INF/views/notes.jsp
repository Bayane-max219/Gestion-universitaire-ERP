<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Notes - ERP Universitaire</title>
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
        <h2 class="text-primary">Liste des Notes</h2>
        <div class="d-flex gap-2">
            <a href="notes?action=new" class="btn btn-primary">Ajouter une note</a>
            <c:if test="${!empty etudiants}">
                <div class="dropdown">
                    <button class="btn btn-success dropdown-toggle" type="button" data-bs-toggle="dropdown">
                        Relevé de notes
                    </button>
                    <ul class="dropdown-menu">
                        <c:forEach var="etudiant" items="${etudiants}">
                            <li>
                                <a class="dropdown-item" href="notes?action=releve&etudiantId=${etudiant.id}">
                                    ${etudiant.nom} ${etudiant.prenom}
                                </a>
                            </li>
                        </c:forEach>
                    </ul>
                </div>
            </c:if>
        </div>
    </div>

    <table class="table table-hover table-bordered">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Étudiant</th>
            <th>Matière</th>
            <th>Note</th>
            <th>Type</th>
            <th class="text-center">Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="n" items="${notes}">
            <tr>
                <td>${n.id}</td>
                <td>${n.inscription.etudiant.nom} ${n.inscription.etudiant.prenom}</td>
                <td>${n.matiere.nom}</td>
                <td>${n.valeur}</td>
                <td>${n.typeEvaluation}</td>
                <td class="text-center">
                    <a href="notes?action=edit&id=${n.id}" class="btn btn-sm btn-warning">Modifier</a>
                    
                    <a href="notes?action=delete&id=${n.id}"
                       class="btn btn-sm btn-danger"
                       onclick="return confirm('Voulez-vous vraiment supprimer cette note ?')">
                        Supprimer
                    </a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty notes}">
            <tr>
                <td colspan="6" class="text-center text-muted">Aucune note enregistrée.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>