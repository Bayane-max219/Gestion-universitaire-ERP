<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${filiere != null}">Modifier Filière</c:when>
            <c:otherwise>Nouvelle Filière</c:otherwise>
        </c:choose>
        - ERP Universitaire
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="container mt-4" style="max-width: 900px;">
    <div class="card shadow">
        <div class="card-header text-white" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
            <h4 class="mb-0">
                <i class="bi bi-diagram-3 me-2"></i>
                <c:choose>
                    <c:when test="${filiere != null}">Modifier Filière</c:when>
                    <c:otherwise>Nouvelle Filière</c:otherwise>
                </c:choose>
            </h4>
        </div>
        <div class="card-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <form action="filieres" method="post">
                <c:if test="${filiere != null}">
                    <input type="hidden" name="id" value="${filiere.id}">
                </c:if>

                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label">Code</label>
                        <input type="text" name="code" class="form-control" placeholder="INFO" value="${filiere != null ? filiere.code : ''}" required>
                    </div>
                    <div class="col-md-8 mb-3">
                        <label class="form-label">Nom</label>
                        <input type="text" name="nom" class="form-control" placeholder="Informatique" value="${filiere != null ? filiere.nom : ''}" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label">Description</label>
                    <textarea name="description" class="form-control" rows="4" placeholder="Description">${filiere != null ? filiere.description : ''}</textarea>
                </div>

                <div class="d-flex justify-content-between">
                    <a href="filieres" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-return-left me-1"></i>Retour
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-save me-1"></i>Enregistrer
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
