<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark mb-4 shadow">
    <div class="container-fluid">
        <a class="navbar-brand" href="etudiants">🎓 ERP Univ</a>
        <div class="navbar-nav">
            <a class="nav-link" href="etudiants">Étudiants</a>
            <a class="nav-link" href="matieres">Matières</a>
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