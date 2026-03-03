<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<nav class="navbar navbar-expand-lg navbar-dark shadow-sm sticky-top" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
    <div class="container-fluid">
        <a class="navbar-brand d-flex align-items-center" href="dashboard">
            <i class="bi bi-mortarboard-fill me-2"></i>
            <span class="fw-bold">Mada U</span>
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link" href="etudiants">
                        <i class="bi bi-people me-1"></i>Étudiants
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="matieres">
                        <i class="bi bi-book me-1"></i>Matières
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="professeurs">
                        <i class="bi bi-person-lines-fill me-1"></i>Professeurs
                    </a>
                </li>
                
                <!-- Menu déroulant Pédagogie -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="bi bi-journal me-1"></i>Pédagogie
                    </a>
                    <ul class="dropdown-menu">
                        <li><a class="dropdown-item" href="programmes"><i class="bi bi-list-task me-2"></i>Programmes</a></li>
                        <li><a class="dropdown-item" href="emplois-du-temps"><i class="bi bi-calendar-check me-2"></i>Emploi du temps</a></li>
                        <li><a class="dropdown-item" href="notes"><i class="bi bi-pen me-2"></i>Notes</a></li>
                    </ul>
                </li>
            </ul>
            
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link btn btn-outline-light btn-sm ms-lg-2" href="inscriptions?action=new">
                        <i class="bi bi-plus-circle me-1"></i>Nouvelle Inscription
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-outline-warning btn-sm ms-lg-2" href="admin/inscriptions">
                        <i class="bi bi-clipboard-check me-1"></i>Validation (Admin)
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-outline-info btn-sm ms-lg-2" href="admin/paiements">
                        <i class="bi bi-cash-stack me-1"></i>Paiements (Admin)
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-outline-light btn-sm ms-lg-2 position-relative" href="notifications">
                        <i class="bi bi-bell me-1"></i>Notifications
                        <span class="badge bg-danger position-absolute top-0 start-100 translate-middle rounded-circle" style="width: 18px; height: 18px; font-size: 10px; padding: 2px;">
                            <i class="bi bi-dot"></i>
                        </span>
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link btn btn-danger btn-sm ms-lg-2" href="logout">
                        <i class="bi bi-box-arrow-right me-1"></i>Déconnexion
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">