<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Programmes Pédagogiques - Mada U</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(rgba(248, 249, 250, 0.95), rgba(248, 249, 250, 0.95)), url('../../resources/images/background.jpg') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            backdrop-filter: blur(3px);
        }
        .program-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            transition: transform 0.3s ease;
        }
        .program-card:hover {
            transform: translateY(-3px);
        }
        .semester-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1.5rem;
            border-radius: 15px 15px 0 0;
        }
        .subject-item {
            border-left: 4px solid #667eea;
            padding: 1rem;
            margin: 0.5rem 0;
            background: rgba(102, 126, 234, 0.05);
            border-radius: 0 8px 8px 0;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary">
                <i class="bi bi-journal-text me-2"></i>Programmes Pédagogiques
            </h2>
            <a href="dashboard" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i>Retour au Dashboard
            </a>
        </div>

        <c:if test="${not empty filieres}">
            <div class="row">
                <c:forEach var="filiere" items="${filieres}">
                    <div class="col-md-6 mb-4">
                        <div class="card program-card">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0">
                                    <i class="bi bi-mortarboard me-2"></i>${filiere.nom}
                                </h5>
                                <small>${filiere.description}</small>
                            </div>
                            <div class="card-body">
                                <div class="d-grid gap-2">
                                    <a href="programmes?filiereId=${filiere.id}&niveau=L1" 
                                       class="btn btn-outline-primary">
                                        <i class="bi bi-book me-2"></i>Licence 1
                                    </a>
                                    <a href="programmes?filiereId=${filiere.id}&niveau=L2" 
                                       class="btn btn-outline-success">
                                        <i class="bi bi-book me-2"></i>Licence 2
                                    </a>
                                    <a href="programmes?filiereId=${filiere.id}&niveau=L3" 
                                       class="btn btn-outline-info">
                                        <i class="bi bi-book me-2"></i>Licence 3
                                    </a>
                                    <a href="programmes?filiereId=${filiere.id}&niveau=M1" 
                                       class="btn btn-outline-warning">
                                        <i class="bi bi-book me-2"></i>Master 1
                                    </a>
                                    <a href="programmes?filiereId=${filiere.id}&niveau=M2" 
                                       class="btn btn-outline-danger">
                                        <i class="bi bi-book me-2"></i>Master 2
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>

        <c:if test="${not empty programmes}">
            <div class="row">
                <c:forEach var="programme" items="${programmes}">
                    <div class="col-md-6 mb-4">
                        <div class="card program-card">
                            <div class="semester-header">
                                <h4 class="mb-0">
                                    <i class="bi bi-calendar me-2"></i>
                                    ${programme.semestre.libelle}
                                </h4>
                                <p class="mb-0 opacity-75">${programme.niveau.libelle}</p>
                            </div>
                            <div class="card-body">
                                <c:if test="${not empty programme.matieres}">
                                    <h6 class="mb-3">Matières :</h6>
                                    <c:forEach var="matiere" items="${programme.matieres}">
                                        <div class="subject-item">
                                            <h6 class="mb-1">
                                                <i class="bi bi-circle-fill me-2" style="font-size: 0.5rem;"></i>
                                                ${matiere.nom}
                                            </h6>
                                            <small class="text-muted">
                                                <i class="bi bi-clock me-1"></i>
                                                ${matiere.credit} crédits
                                            </small>
                                        </div>
                                    </c:forEach>
                                </c:if>
                                <c:if test="${empty programme.matieres}">
                                    <div class="text-center text-muted py-4">
                                        <i class="bi bi-journal fs-1 d-block mb-2"></i>
                                        Aucune matière disponible
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:if>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>