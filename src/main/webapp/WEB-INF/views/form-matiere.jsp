<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${matiere != null}">Modifier Matière</c:when>
            <c:otherwise>Nouvelle Matière</c:otherwise>
        </c:choose>
        - ERP Universitaire
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa; /* Fond blanc très clair comme demandé */
            min-height: 100vh;
            padding-top: 20px;
        }
        .form-card {
            background: white; /* Fond blanc pur pour la carte */
            backdrop-filter: blur(10px);
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05);
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
                        <i class="bi bi-book-half fs-1 mb-3"></i>
                        <h3 class="mb-1">
                            <c:choose>
                                <c:when test="${matiere != null}">
                                    <i class="bi bi-pencil-square me-2"></i>Modifier Matière
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-plus-circle me-2"></i>Nouvelle Matière
                                </c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="mb-0 opacity-75">
                            <c:choose>
                                <c:when test="${matiere != null}">
                                    Modification des informations de la matière
                                </c:when>
                                <c:otherwise>
                                    Ajout d'une nouvelle matière au système
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

                        <form action="matieres" method="post">
                            <c:if test="${matiere != null}">
                                <input type="hidden" name="id" value="${matiere.id}">
                            </c:if>

                            <div class="row">
                                <div class="col-md-6 mb-4 icon-input">
                                    <i class="bi bi-book"></i>
                                    <input type="text" name="nom" class="form-control form-control-lg" 
                                           placeholder="Nom de la matière" 
                                           value="${matiere != null ? matiere.nom : ''}" 
                                           required>
                                </div>
                                <div class="col-md-6 mb-4 icon-input">
                                    <i class="bi bi-hash"></i>
                                    <input type="number" name="coefficient" class="form-control form-control-lg" 
                                           placeholder="Coefficient" 
                                           min="1" max="10" 
                                           value="${matiere != null ? matiere.coefficient : ''}" 
                                           required>
                                </div>
                            </div>

                            <div class="mb-4 icon-input">
                                <i class="bi bi-person-lines-fill"></i>
                                <select name="professeurId" class="form-control form-control-lg">
                                    <option value="">Sélectionner un professeur responsable</option>
                                    <c:forEach var="professeur" items="${professeurs}">
                                        <option value="${professeur.id}" 
                                                <c:if test="${matiere != null && matiere.professeurResponsable != null && matiere.professeurResponsable.id == professeur.id}">selected</c:if>>
                                            ${professeur.nom} ${professeur.prenom} (${professeur.email})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <hr class="section-divider">

                            <div class="d-flex justify-content-between align-items-center">
                                <a href="matieres" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-return-left me-1"></i>Annuler
                                </a>
                                <button type="submit" class="btn btn-submit text-white btn-lg px-4">
                                    <i class="bi bi-save me-2"></i>
                                    <c:choose>
                                        <c:when test="${matiere != null}">Mettre à jour</c:when>
                                        <c:otherwise>Ajouter Matière</c:otherwise>
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