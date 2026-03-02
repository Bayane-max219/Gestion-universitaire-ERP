<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Ajouter un Professeur</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">
<div class="card shadow">
    <div class="card-header bg-primary text-white">
        <h3 class="card-title">
            <c:choose>
                <c:when test="${professeur != null}">Modifier Professeur</c:when>
                <c:otherwise>Nouveau Professeur</c:otherwise>
            </c:choose>
        </h3>
    </div>
    <div class="card-body">
        <form action="professeurs" method="post">
            <c:if test="${professeur != null}">
                <input type="hidden" name="id" value="${professeur.id}">
            </c:if>
            
            <div class="mb-3">
                <label class="form-label">Nom</label>
                <input type="text" name="nom" class="form-control" 
                       value="${professeur != null ? professeur.nom : ''}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Prénom</label>
                <input type="text" name="prenom" class="form-control" 
                       value="${professeur != null ? professeur.prenom : ''}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" 
                       value="${professeur != null ? professeur.email : ''}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Téléphone</label>
                <input type="tel" name="telephone" class="form-control" 
                       value="${professeur != null ? professeur.telephone : ''}">
            </div>
            <div class="d-flex justify-content-between">
                <a href="professeurs" class="btn btn-secondary">Annuler</a>
                <button type="submit" class="btn btn-success">
                    <c:choose>
                        <c:when test="${professeur != null}">Mettre à jour</c:when>
                        <c:otherwise>Enregistrer</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>