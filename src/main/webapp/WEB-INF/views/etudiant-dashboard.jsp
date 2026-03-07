<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Étudiant - Mada U</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(rgba(248, 249, 250, 0.95), rgba(248, 249, 250, 0.95)), url('../../resources/images/background.jpg') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            backdrop-filter: blur(3px);
        }
        .dashboard-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s ease;
            height: 100%;
        }
        .dashboard-card:hover {
            transform: translateY(-5px);
        }
        .welcome-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 15px 15px 0 0;
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
        }
        .feature-icon {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="container mt-4">
        <div class="welcome-header mb-4">
            <h1 class="display-5 fw-bold mb-2">
                <i class="bi bi-mortarboard-fill me-3"></i>Bienvenue, ${etudiant.prenom} ${etudiant.nom}
            </h1>
            <p class="lead mb-0">
                <i class="bi bi-person-badge me-2"></i>
                ${etudiant.niveau.libelle} - ${etudiant.filiere.nom}
                <span class="badge bg-light text-dark ms-2">${etudiant.numeroEtudiant}</span>
            </p>
        </div>

        <!-- Statistiques rapides -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card stat-card text-white">
                    <div class="card-body text-center">
                        <i class="bi bi-book-half fs-1"></i>
                        <h4 class="card-title">12</h4>
                        <p class="card-text">Matières</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white">
                    <div class="card-body text-center">
                        <i class="bi bi-calendar-check fs-1"></i>
                        <h4 class="card-title">S1</h4>
                        <p class="card-text">Semestre</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-info text-white">
                    <div class="card-body text-center">
                        <i class="bi bi-bell fs-1"></i>
                        <h4 class="card-title">3</h4>
                        <p class="card-text">Notifications</p>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-warning text-white">
                    <div class="card-body text-center">
                        <i class="bi bi-currency-euro fs-1"></i>
                        <h4 class="card-title">85%</h4>
                        <p class="card-text">Paiement</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Fonctionnalités principales -->
        <div class="row">
            <div class="col-md-4 mb-4">
                <div class="card dashboard-card">
                    <div class="card-body text-center">
                        <div class="feature-icon text-primary">
                            <i class="bi bi-journal-text"></i>
                        </div>
                        <h5 class="card-title">Programmes Pédagogiques</h5>
                        <p class="card-text">Consultez les programmes de votre filière organisés par semestres</p>
                        <a href="${pageContext.request.contextPath}/matieres" 
                           class="btn btn-primary">
                            <i class="bi bi-arrow-right me-2"></i>Consulter
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="card dashboard-card">
                    <div class="card-body text-center">
                        <div class="feature-icon text-success">
                            <i class="bi bi-calendar-week"></i>
                        </div>
                        <h5 class="card-title">Emploi du Temps</h5>
                        <p class="card-text">Consultez votre emploi du temps selon votre niveau et filière</p>
                        <a href="emplois-du-temps" class="btn btn-success">
                            <i class="bi bi-arrow-right me-2"></i>Consulter
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="col-md-4 mb-4">
                <div class="card dashboard-card">
                    <div class="card-body text-center">
                        <div class="feature-icon text-info">
                            <i class="bi bi-card-text"></i>
                        </div>
                        <h5 class="card-title">Relevé de Notes</h5>
                        <p class="card-text">Accédez à votre relevé de notes et vos résultats</p>
                        <a href="${pageContext.request.contextPath}/notes" class="btn btn-info">
                            <i class="bi bi-arrow-right me-2"></i>Consulter
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <div class="col-md-12 mb-4">
                <div class="card dashboard-card">
                    <div class="card-body text-center">
                        <div class="feature-icon text-warning">
                            <i class="bi bi-bell"></i>
                        </div>
                        <h5 class="card-title">Notifications</h5>
                        <p class="card-text">Consultez vos notifications importantes et rappels de paiement</p>
                        <a href="${pageContext.request.contextPath}/notifications" class="btn btn-warning">
                            <i class="bi bi-arrow-right me-2"></i>Voir les notifications
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>