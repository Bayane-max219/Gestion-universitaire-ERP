<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${emploiDuTemps != null}">Modifier Emploi du Temps</c:when>
            <c:otherwise>Nouvel Emploi du Temps</c:otherwise>
        </c:choose>
        - ERP Universitaire
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #4cc9f0 0%, #4895ef 100%);
            min-height: 100vh;
            padding-top: 20px;
        }
        .form-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        .form-card:hover {
            transform: translateY(-5px);
        }
        .form-header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        .form-control {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #4361ee;
            box-shadow: 0 0 0 0.25rem rgba(67, 97, 238, 0.25);
        }
        .btn-submit {
            background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(67, 97, 238, 0.4);
        }
        .input-group-text {
            background: #f8f9fa;
            border-right: none;
        }
        .icon-input {
            position: relative;
        }
        .icon-input i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        .icon-input input, .icon-input select, .icon-input textarea {
            padding-left: 45px;
        }
        .section-divider {
            border-top: 2px dashed #dee2e6;
            margin: 2rem 0;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10">
                <div class="card form-card">
                    <div class="form-header">
                        <i class="bi bi-calendar-event fs-1 mb-3"></i>
                        <h3 class="mb-1">
                            <c:choose>
                                <c:when test="${emploiDuTemps != null}">
                                    <i class="bi bi-pencil-square me-2"></i>Modifier Emploi du Temps
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-plus-circle me-2"></i>Nouvel Emploi du Temps
                                </c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="mb-0 opacity-75">
                            <c:choose>
                                <c:when test="${emploiDuTemps != null}">
                                    Modification de la plage horaire
                                </c:when>
                                <c:otherwise>
                                    Ajout d'une nouvelle plage horaire
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    
                    <div class="card-body p-4">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form action="emplois-du-temps" method="post">
                            <c:if test="${emploiDuTemps != null}">
                                <input type="hidden" name="id" value="${emploiDuTemps.id}">
                            </c:if>

                            <div class="row">
                                <div class="col-md-6 mb-4 icon-input">
                                    <i class="bi bi-diagram-3"></i>
                                    <select name="filiereId" class="form-control form-control-lg" required>
                                        <option value="">Sélectionner une filière</option>
                                        <c:forEach var="filiere" items="${filieres}">
                                            <option value="${filiere.id}"
                                                    <c:if test="${emploiDuTemps != null && emploiDuTemps.filiere.id == filiere.id}">selected</c:if>>
                                                ${filiere.nom}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="col-md-6 mb-4 icon-input">
                                    <i class="bi bi-calendar-month"></i>
                                    <input type="month" name="mois" class="form-control form-control-lg"
                                           value="${not empty moisStr ? moisStr : (emploiDuTemps != null ? emploiDuTemps.mois : '')}"
                                           required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-4 icon-input">
                                    <i class="bi bi-book"></i>
                                    <select name="matiereId" class="form-control form-control-lg" required>
                                        <option value="">Sélectionner une matière</option>
                                        <c:forEach var="matiere" items="${matieres}">
                                            <option value="${matiere.id}" 
                                                    <c:if test="${emploiDuTemps != null && emploiDuTemps.matiere.id == matiere.id}">selected</c:if>>
                                                ${matiere.nom} (Coeff: ${matiere.coefficient})
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-4 icon-input">
                                    <i class="bi bi-person-lines-fill"></i>
                                    <input type="text" class="form-control form-control-lg" value="Professeur automatique (lié à la matière)" disabled>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-4 mb-4 icon-input">
                                    <i class="bi bi-calendar-day"></i>
                                    <select name="jour" class="form-control form-control-lg" required>
                                        <option value="">Sélectionner un jour</option>
                                        <option value="MONDAY" <c:if test="${emploiDuTemps != null && emploiDuTemps.jour == 'MONDAY'}">selected</c:if>>Lundi</option>
                                        <option value="TUESDAY" <c:if test="${emploiDuTemps != null && emploiDuTemps.jour == 'TUESDAY'}">selected</c:if>>Mardi</option>
                                        <option value="WEDNESDAY" <c:if test="${emploiDuTemps != null && emploiDuTemps.jour == 'WEDNESDAY'}">selected</c:if>>Mercredi</option>
                                        <option value="THURSDAY" <c:if test="${emploiDuTemps != null && emploiDuTemps.jour == 'THURSDAY'}">selected</c:if>>Jeudi</option>
                                        <option value="FRIDAY" <c:if test="${emploiDuTemps != null && emploiDuTemps.jour == 'FRIDAY'}">selected</c:if>>Vendredi</option>
                                        <option value="SATURDAY" <c:if test="${emploiDuTemps != null && emploiDuTemps.jour == 'SATURDAY'}">selected</c:if>>Samedi</option>
                                    </select>
                                </div>
                                <div class="col-md-4 mb-4 icon-input">
                                    <i class="bi bi-clock"></i>
                                    <input type="time" name="heureDebut" class="form-control form-control-lg" 
                                           value="${emploiDuTemps != null ? emploiDuTemps.heureDebut : ''}" 
                                           required>
                                </div>
                                <div class="col-md-4 mb-4 icon-input">
                                    <i class="bi bi-clock-history"></i>
                                    <input type="time" name="heureFin" class="form-control form-control-lg" 
                                           value="${emploiDuTemps != null ? emploiDuTemps.heureFin : ''}" 
                                           required>
                                </div>
                            </div>

                            <div class="mb-4 icon-input">
                                <i class="bi bi-door-open"></i>
                                <input type="text" name="salle" class="form-control form-control-lg" 
                                       placeholder="Salle de cours" 
                                       value="${emploiDuTemps != null ? emploiDuTemps.salle : ''}" 
                                       required>
                            </div>

                            <hr class="section-divider">

                            <div class="d-flex justify-content-between align-items-center">
                                <a href="emplois-du-temps" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-return-left me-1"></i>Annuler
                                </a>
                                <button type="submit" class="btn btn-submit text-white btn-lg px-4">
                                    <i class="bi bi-save me-2"></i>
                                    <c:choose>
                                        <c:when test="${emploiDuTemps != null}">Mettre à jour</c:when>
                                        <c:otherwise>Ajouter Emploi du Temps</c:otherwise>
                                    </c:choose>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>