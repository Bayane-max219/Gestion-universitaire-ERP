<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Emploi du Temps - ERP Universitaire</title>
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
        <h2 class="text-primary">Emploi du Temps</h2>
        <a href="emplois-du-temps?action=new" class="btn btn-primary">
            Ajouter un créneau
        </a>
    </div>

    <table class="table table-hover table-bordered">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Jour</th>
            <th>Matière</th>
            <th>Professeur</th>
            <th>Horaire</th>
            <th>Salle</th>
            <th class="text-center">Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="e" items="${emploisDuTemps}">
            <tr>
                <td>${e.id}</td>
                <td>${e.jour}</td>
                <td>${e.matiere.nom}</td>
                <td>${e.professeur.nom} ${e.professeur.prenom}</td>
                <td>${e.heureDebut} - ${e.heureFin}</td>
                <td>${e.salle}</td>
                <td class="text-center">
                    <a href="emplois-du-temps?action=edit&id=${e.id}" class="btn btn-sm btn-warning">Modifier</a>
                    
                    <a href="emplois-du-temps?action=delete&id=${e.id}"
                       class="btn btn-sm btn-danger"
                       onclick="return confirm('Voulez-vous vraiment supprimer ce créneau ?')">
                        Supprimer
                    </a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty emploisDuTemps}">
            <tr>
                <td colspan="7" class="text-center text-muted">Aucun créneau horaire enregistré.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

</body>
</html>