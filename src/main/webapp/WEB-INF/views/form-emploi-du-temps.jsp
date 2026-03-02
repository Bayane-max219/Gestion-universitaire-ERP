<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Ajouter un Créneau Horaires</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">
<div class="card shadow">
    <div class="card-header bg-primary text-white">
        <h3 class="card-title">
            <c:choose>
                <c:when test="${emploiDuTemps != null}">Modifier Créneau</c:when>
                <c:otherwise>Nouveau Créneau</c:otherwise>
            </c:choose>
        </h3>
    </div>
    <div class="card-body">
        <form action="emplois-du-temps" method="post">
            <c:if test="${emploiDuTemps != null}">
                <input type="hidden" name="id" value="${emploiDuTemps.id}">
            </c:if>
            
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Matière</label>
                    <select name="matiereId" class="form-select" required>
                        <option value="">-- Choisir une matière --</option>
                        <c:forEach var="m" items="${matieres}">
                            <option value="${m.id}" 
                                <c:if test="${emploiDuTemps != null && emploiDuTemps.matiere.id == m.id}">selected</c:if>>
                                ${m.nom}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">Professeur</label>
                    <select name="professeurId" class="form-select" required>
                        <option value="">-- Choisir un professeur --</option>
                        <c:forEach var="p" items="${professeurs}">
                            <option value="${p.id}" 
                                <c:if test="${emploiDuTemps != null && emploiDuTemps.professeur.id == p.id}">selected</c:if>>
                                ${p.nom} ${p.prenom}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>
            
            <div class="row">
                <div class="col-md-4 mb-3">
                    <label class="form-label">Jour</label>
                    <select name="jour" class="form-select" required>
                        <option value="">-- Choisir un jour --</option>
                        <option value="MONDAY" 
                            <c:if test="${emploiDuTemps != null && emploiDuTemps.jour.name() == 'MONDAY'}">selected</c:if>>
                            Lundi
                        </option>
                        <option value="TUESDAY" 
                            <c:if test="${emploiDuTemps != null && emploiDuTemps.jour.name() == 'TUESDAY'}">selected</c:if>>
                            Mardi
                        </option>
                        <option value="WEDNESDAY" 
                            <c:if test="${emploiDuTemps != null && emploiDuTemps.jour.name() == 'WEDNESDAY'}">selected</c:if>>
                            Mercredi
                        </option>
                        <option value="THURSDAY" 
                            <c:if test="${emploiDuTemps != null && emploiDuTemps.jour.name() == 'THURSDAY'}">selected</c:if>>
                            Jeudi
                        </option>
                        <option value="FRIDAY" 
                            <c:if test="${emploiDuTemps != null && emploiDuTemps.jour.name() == 'FRIDAY'}">selected</c:if>>
                            Vendredi
                        </option>
                        <option value="SATURDAY" 
                            <c:if test="${emploiDuTemps != null && emploiDuTemps.jour.name() == 'SATURDAY'}">selected</c:if>>
                            Samedi
                        </option>
                    </select>
                </div>
                <div class="col-md-4 mb-3">
                    <label class="form-label">Heure de début</label>
                    <input type="time" name="heureDebut" class="form-control" 
                           value="${emploiDuTemps != null ? emploiDuTemps.heureDebut : ''}" required>
                </div>
                <div class="col-md-4 mb-3">
                    <label class="form-label">Heure de fin</label>
                    <input type="time" name="heureFin" class="form-control" 
                           value="${emploiDuTemps != null ? emploiDuTemps.heureFin : ''}" required>
                </div>
            </div>
            
            <div class="mb-3">
                <label class="form-label">Salle</label>
                <input type="text" name="salle" class="form-control" 
                       value="${emploiDuTemps != null ? emploiDuTemps.salle : ''}">
            </div>
            
            <div class="d-flex justify-content-between">
                <a href="emplois-du-temps" class="btn btn-secondary">Annuler</a>
                <button type="submit" class="btn btn-success">
                    <c:choose>
                        <c:when test="${emploiDuTemps != null}">Mettre à jour</c:when>
                        <c:otherwise>Enregistrer</c:otherwise>
                    </c:choose>
                </button>
            </div>
        </form>
    </div>
</div>
</body>
</html>