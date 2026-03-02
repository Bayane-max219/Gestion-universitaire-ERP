<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Ajouter une Note</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">
<div class="card shadow">
    <div class="card-header bg-primary text-white">
        <h3 class="card-title">
            <c:choose>
                <c:when test="${note != null}">Modifier Note</c:when>
                <c:otherwise>Nouvelle Note</c:otherwise>
            </c:choose>
        </h3>
    </div>
    <div class="card-body">
        <form action="notes" method="post">
            <c:if test="${note != null}">
                <input type="hidden" name="id" value="${note.id}">
            </c:if>
            
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Inscription</label>
                    <select name="inscriptionId" class="form-select" required>
                        <option value="">-- Choisir une inscription --</option>
                        <c:forEach var="inscription" items="${inscriptions}">
                            <option value="${inscription.id}">
                                ${inscription.etudiant.nom} ${inscription.etudiant.prenom} - ${inscription.matiere.nom}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Matière</label>
                    <select name="matiereId" class="form-select" required>
                        <option value="">-- Choisir une matière --</option>
                        <c:forEach var="matiere" items="${matieres}">
                            <option value="${matiere.id}">
                                ${matiere.nom}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Valeur</label>
                    <input type="number" step="0.01" min="0" max="20" name="valeur" class="form-control" 
                           value="${note != null ? note.valeur : ''}" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Type d'évaluation</label>
                    <select name="typeEvaluation" class="form-select" required>
                        <option value="">-- Choisir un type --</option>
                        <option value="DS" <c:if test="${note != null && note.typeEvaluation == 'DS'}">selected</c:if>>Devoir Surveillé</option>
                        <option value="TP" <c:if test="${note != null && note.typeEvaluation == 'TP'}">selected</c:if>>Travail Pratique</option>
                        <option value="EXAMEN" <c:if test="${note != null && note.typeEvaluation == 'EXAMEN'}">selected</c:if>>Examen</option>
                        <option value="CONTROLE" <c:if test="${note != null && note.typeEvaluation == 'CONTROLE'}">selected</c:if>>Contrôle</option>
                    </select>
                </div>
            </div>
            
            <div class="d-flex justify-content-between">
                <a href="notes" class="btn btn-secondary">Annuler</a>
                <button type="submit" class="btn btn-success">
                    <c:choose>
                        <c:when test="${note != null}">Mettre à jour</c:when>
                        <c:otherwise>Enregistrer</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>