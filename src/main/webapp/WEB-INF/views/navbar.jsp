<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow">
    <div class="container-fluid">
        <a class="navbar-brand" href="etudiants">🎓 ERP Univ</a>
        <div class="navbar-nav">
            <a class="nav-link" href="etudiants">Étudiants</a>
            <a class="nav-link" href="matieres">Matières</a>
            <a class="nav-link" href="professeurs">Professeurs</a>
            <div class="dropdown">
                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                    Pédagogie
                </a>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="programmes">Programmes</a></li>
                    <li><a class="dropdown-item" href="emplois-du-temps">Emploi du temps</a></li>
                    <li><a class="dropdown-item" href="notes">Notes</a></li>
                </ul>
            </div>
            <a class="nav-link btn btn-outline-success btn-sm ms-lg-3 text-white" href="inscriptions?action=new">
                ➕ Nouvelle Inscription
            </a>
            <a class="nav-link btn btn-outline-warning btn-sm ms-lg-3" href="admin/inscriptions">
                Validation (Admin)
            </a>
            <a class="nav-link btn btn-danger btn-sm ms-lg-3 text-white" href="logout">
                Déconnexion
            </a>
        </div>
    </div>
</nav>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>