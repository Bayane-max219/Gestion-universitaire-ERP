<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nouvelle Inscription - ERP Universitaire</title>
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
        .step-indicator {
            display: flex;
            justify-content: space-between;
            margin-bottom: 2rem;
        }
        .step {
            text-align: center;
            flex: 1;
        }
        .step.active {
            color: #4361ee;
            font-weight: bold;
        }
        .step-line {
            height: 2px;
            background-color: #dee2e6;
            position: absolute;
            top: 20px;
            left: 0;
            right: 0;
            z-index: 1;
        }
        .step-content {
            position: relative;
            z-index: 2;
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
                        <i class="bi bi-journal-bookmark fs-1 mb-3"></i>
                        <h3 class="mb-1">
                            <i class="bi bi-plus-circle me-2"></i>Nouvelle Inscription
                        </h3>
                        <p class="mb-0 opacity-75">
                            Créer l'échéancier d'écolage
                        </p>
                    </div>
                    
                    <div class="card-body p-4">
                        <c:if test="${param.error == '1'}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                <c:choose>
                                    <c:when test="${not empty sessionScope.flashError}">
                                        ${sessionScope.flashError}
                                        <c:remove var="flashError" scope="session" />
                                    </c:when>
                                    <c:otherwise>
                                        Une erreur s'est produite lors de la création de l'inscription
                                    </c:otherwise>
                                </c:choose>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form action="inscriptions" method="post">
                            <div class="row">
                                <div class="col-md-6 mb-4 icon-input">
                                    <i class="bi bi-people"></i>
                                    <select name="etudiantId" class="form-control form-control-lg" required>

                                        <option value="">Sélectionner un étudiant</option>
                                        <c:forEach var="etudiant" items="${etudiants}">
                                            <option value="${etudiant.id}" 
                                                    <c:if test="${param.etudiantId == etudiant.id}">selected</c:if>>
                                                ${etudiant.nom} ${etudiant.prenom} (${etudiant.numeroEtudiant})
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-4 icon-input">
                                    <i class="bi bi-currency-dollar"></i>
                                    <input type="number" step="0.01" min="0" name="fraisAnnuel" class="form-control form-control-lg" 
                                           placeholder="Frais de scolarité annuel (Ar)" 
                                           value="${param.fraisAnnuel}" required>
                                </div>
                            </div>

                            <div class="section-divider">
                                <h5 class="text-center">Tranches d'écolage</h5>
                            </div>

                            <div class="row">
                                <div class="col-md-4 mb-4 icon-input">
                                    <i class="bi bi-list-ol"></i>
                                    <input type="number" min="1" name="nombreTranches" class="form-control form-control-lg" 
                                           placeholder="Nombre de tranches" 
                                           value="${param.nombreTranches}" required>
                                </div>
                                <div class="col-md-4 mb-4 icon-input">
                                    <i class="bi bi-calendar"></i>
                                    <input type="month" name="moisDepart" class="form-control form-control-lg" 
                                           value="${param.moisDepart}">
                                </div>
                                <div class="col-md-4 mb-4 icon-input">
                                    <i class="bi bi-calendar-check"></i>
                                    <input type="text" class="form-control form-control-lg" value="05" readonly>
                                </div>
                            </div>

                            <div class="mb-4">
                                <div class="alert alert-info">
                                    <i class="bi bi-info-circle me-2"></i>
                                    <strong>Information:</strong> Les échéances seront générées automatiquement au jour 05 de chaque mois.
                                </div>
                            </div>

                            <hr class="section-divider">

                            <div class="d-flex justify-content-between align-items-center">
                                <a href="inscriptions" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-return-left me-1"></i>Annuler
                                </a>
                                <button type="submit" class="btn btn-submit text-white btn-lg px-4">
                                    <i class="bi bi-check-circle me-2"></i>Valider l'inscription
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