<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Ajouter un Programme</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">
<div class="card shadow">
    <div class="card-header bg-primary text-white">
        <h3 class="card-title">
            <c:choose>
                <c:when test="${programme != null}">Modifier Programme</c:when>
                <c:otherwise>Nouveau Programme</c:otherwise>
            </c:choose>
        </h3>
    </div>
    <div class="card-body">
        <form action="programmes" method="post">
            <c:if test="${programme != null}">
                <input type="hidden" name="id" value="${programme.id}">
            </c:if>
            
            <div class="mb-3">
                <label class="form-label">Matière</label>
                <select name="matiereId" class="form-select" required>
                    <option value="">-- Choisir une matière --</option>
                    <c:forEach var="m" items="${matieres}">
                        <option value="${m.id}" 
                            <c:if test="${programme != null && programme.matiere.id == m.id}">selected</c:if>>
                            ${m.nom}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">Chapitre</label>
                <input type="text" name="chapitre" class="form-control" 
                       value="${programme != null ? programme.chapitre : ''}" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Description</label>
                <textarea name="description" class="form-control" rows="3" 
                          placeholder="Description détaillée du chapitre">${programme != null ? programme.description : ''}</textarea>
            </div>
            <div class="mb-3">
                <label class="form-label">Ordre</label>
                <input type="number" name="ordre" class="form-control" 
                       value="${programme != null ? programme.ordre : '1'}" min="1" required>
            </div>
            <div class="d-flex justify-content-between">
                <a href="programmes" class="btn btn-secondary">Annuler</a>
                <button type="submit" class="btn btn-success">
                    <c:choose>
                        <c:when test="${programme != null}">Mettre à jour</c:when>
                        <c:otherwise>Enregistrer</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>