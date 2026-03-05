<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - Mada U</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        .welcome-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 15px;
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
        <h1 class="display-6 fw-bold mb-2">
            <i class="bi bi-shield-lock-fill me-3"></i>Dashboard Administration
        </h1>
        <p class="lead mb-0">Accès rapide aux modules administrateur</p>
    </div>

    <div class="row">
        <div class="col-md-6 mb-4">
            <div class="card dashboard-card">
                <div class="card-body text-center">
                    <div class="feature-icon text-warning">
                        <i class="bi bi-clipboard-check"></i>
                    </div>
                    <h5 class="card-title">Validation des inscriptions</h5>
                    <p class="card-text">Valider ou annuler les inscriptions en attente</p>
                    <a href="admin/inscriptions" class="btn btn-warning">
                        <i class="bi bi-arrow-right me-2"></i>Ouvrir
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-6 mb-4">
            <div class="card dashboard-card">
                <div class="card-body text-center">
                    <div class="feature-icon text-info">
                        <i class="bi bi-cash-stack"></i>
                    </div>
                    <h5 class="card-title">Paiements (tranches)</h5>
                    <p class="card-text">Suivre et valider les paiements des étudiants</p>
                    <a href="admin/paiements" class="btn btn-info text-white">
                        <i class="bi bi-arrow-right me-2"></i>Ouvrir
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-4 mb-4">
            <div class="card dashboard-card">
                <div class="card-body text-center">
                    <div class="feature-icon text-primary">
                        <i class="bi bi-people"></i>
                    </div>
                    <h5 class="card-title">Étudiants</h5>
                    <p class="card-text">Gérer la liste des étudiants</p>
                    <a href="etudiants" class="btn btn-primary">
                        <i class="bi bi-arrow-right me-2"></i>Ouvrir
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-4 mb-4">
            <div class="card dashboard-card">
                <div class="card-body text-center">
                    <div class="feature-icon text-success">
                        <i class="bi bi-book"></i>
                    </div>
                    <h5 class="card-title">Matières</h5>
                    <p class="card-text">Gérer les matières et coefficients</p>
                    <a href="matieres" class="btn btn-success">
                        <i class="bi bi-arrow-right me-2"></i>Ouvrir
                    </a>
                </div>
            </div>
        </div>

        <div class="col-md-4 mb-4">
            <div class="card dashboard-card">
                <div class="card-body text-center">
                    <div class="feature-icon text-secondary">
                        <i class="bi bi-bell"></i>
                    </div>
                    <h5 class="card-title">Notifications</h5>
                    <p class="card-text">Voir les notifications</p>
                    <a href="notifications" class="btn btn-secondary">
                        <i class="bi bi-arrow-right me-2"></i>Ouvrir
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
