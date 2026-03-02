<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>
        <c:choose>
            <c:when test="${matiere != null}">Modifier Matière</c:when>
            <c:otherwise>Ajouter une matière</c:otherwise>
        </c:choose>
    </title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">
<div class="card shadow">
    <div class="card-header bg-primary text-white">
        <h3 class="card-title">
            <c:choose>
                <c:when test="${matiere != null}">Modifier Matière</c:when>
                <c:otherwise>Nouvelle Matière</c:otherwise>
            </c:choose>
        </h3>
    </div>
    <div class="card-body">
        <form action="matieres" method="post">
            <c:if test="${matiere != null}">
                <input type="hidden" name="id" value="${matiere.id}">
            </c:if>
            
            <div class="mb-3">
                <label class="form-label">Nom</label>
                <input type="text" name="nom" class="form-control" 
                       value="${matiere != null ? matiere.nom : ''}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Coefficient</label>
                <input type="number" name="coefficient" class="form-control" 
                       value="${matiere != null ? matiere.coefficient : ''}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Professeur Responsable</label>
                <select name="professeurId" class="form-select">
                    <option value="">-- Aucun professeur --</option>
                    <c:forEach var="professeur" items="${professeurs}">
                        <option value="${professeur.id}" 
                            <c:if test="${matiere != null && matiere.professeurResponsable != null && matiere.professeurResponsable.id == professeur.id}">selected</c:if>>
                            ${professeur.nom} ${professeur.prenom}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="d-flex justify-content-between">
                <a href="matieres" class="btn btn-secondary">Annuler</a>
                <button type="submit" class="btn btn-success">
                    <c:choose>
                        <c:when test="${matiere != null}">Mettre à jour</c:when>
                        <c:otherwise>Enregistrer</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>