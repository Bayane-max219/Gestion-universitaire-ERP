<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>
        <c:choose>
            <c:when test="${etudiant != null}">Modifier Étudiant</c:when>
            <c:otherwise>Ajouter un Étudiant</c:otherwise>
        </c:choose>
    </title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">
<div class="card shadow">
    <div class="card-header bg-primary text-white">
        <h3 class="card-title">
            <c:choose>
                <c:when test="${etudiant != null}">Modifier Étudiant</c:when>
                <c:otherwise>Nouvel Étudiant</c:otherwise>
            </c:choose>
        </h3>
    </div>
    <div class="card-body">
        <form action="etudiants" method="post">
            <c:if test="${etudiant != null}">
                <input type="hidden" name="id" value="${etudiant.id}">
            </c:if>
            
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Nom</label>
                    <input type="text" name="nom" class="form-control" 
                           value="${etudiant != null ? etudiant.nom : ''}" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Prénom</label>
                    <input type="text" name="prenom" class="form-control" 
                           value="${etudiant != null ? etudiant.prenom : ''}" required>
                </div>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" 
                       value="${etudiant != null ? etudiant.email : ''}" required>
            </div>
            
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Téléphone</label>
                    <input type="tel" name="telephone" class="form-control" 
                           value="${etudiant != null ? etudiant.telephone : ''}">
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Téléphone Parent</label>
                    <input type="tel" name="telephoneParent" class="form-control" 
                           value="${etudiant != null ? etudiant.telephoneParent : ''}">
                </div>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Adresse</label>
                <input type="text" name="adresse" class="form-control" 
                       value="${etudiant != null ? etudiant.adresse : ''}">
            </div>
            
            <div class="d-flex justify-content-between">
                <a href="etudiants" class="btn btn-secondary">Annuler</a>
                <button type="submit" class="btn btn-success">
                    <c:choose>
                        <c:when test="${etudiant != null}">Mettre à jour</c:when>
                        <c:otherwise>Enregistrer</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>