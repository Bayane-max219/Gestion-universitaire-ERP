<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Étudiants - ERP Universitaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(rgba(248, 249, 250, 0.95), rgba(248, 249, 250, 0.95)), url('../../resources/images/background.jpg') no-repeat center center fixed;
            background-size: cover;
            backdrop-filter: blur(3px);
        }
        .student-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .student-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .table th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .action-btn {
            transition: all 0.2s ease;
        }
        .action-btn:hover {
            transform: scale(1.05);
        }
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-md-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="text-primary">
                        <i class="bi bi-people me-2"></i>Étudiants
                        <span class="badge bg-secondary ms-2">${etudiants.size()}</span>
                    </h2>
                    <a href="etudiants?action=new" class="btn btn-success">
                        <i class="bi bi-person-plus me-1"></i>Nouvel Étudiant
                    </a>
                </div>

                <!-- Statistiques rapides -->
                <div class="row mb-4">
                    <div class="col-md-6">
                        <div class="card stats-card text-white">
                            <div class="card-body text-center">
                                <i class="bi bi-people-fill fs-1"></i>
                                <h4 class="card-title">${etudiants.size()}</h4>
                                <p class="card-text">Total Étudiants</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card bg-info text-white">
                            <div class="card-body text-center">
                                <i class="bi bi-pencil-fill fs-1"></i>
                                <h4 class="card-title">${inscritsCount}</h4>
                                <p class="card-text">Inscrits</p>
                            </div>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <c:if test="${not empty warning}">
                    <div class="alert alert-warning alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${warning}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <div class="card shadow">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped">
                                <thead>
                                    <tr>
                                        <th>Numéro Étudiant</th>
                                        <th>Nom</th>
                                        <th>Prénom</th>
                                        <th>Niveau</th>
                                        <th>Filière</th>
                                        <th>Email</th>
                                        <th>Téléphone</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="etudiant" items="${etudiants}">
                                        <tr>
                                            <td>${etudiant.numeroEtudiant}</td>
                                            <td>${etudiant.nom}</td>
                                            <td>${etudiant.prenom}</td>
                                            <td>${etudiant.niveau != null ? etudiant.niveau.libelle : ''}</td>
                                            <td>${etudiant.filiere != null ? etudiant.filiere.nom : ''}</td>
                                            <td>${etudiant.email}</td>
                                            <td>${etudiant.telephone}</td>
                                            <td class="text-center">
                                                <div class="btn-group" role="group">
                                                    <a href="etudiants?action=edit&id=${etudiant.id}" 
                                                       class="btn btn-sm btn-outline-primary action-btn" 
                                                       title="Modifier">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <a href="etudiants?action=delete&id=${etudiant.id}" 
                                                       class="btn btn-sm btn-outline-danger action-btn" 
                                                       title="Supprimer"
                                                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer cet étudiant ?')">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                    <a href="inscriptions?action=new&etudiantId=${etudiant.id}" 
                                                       class="btn btn-sm btn-outline-success action-btn" 
                                                       title="Nouvelle Inscription">
                                                        <i class="bi bi-journal-plus"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty etudiants}">
                                        <tr>
                                            <td colspan="8" class="text-center text-muted py-4">
                                                <i class="bi bi-people fs-1 d-block mb-2"></i>
                                                Aucun étudiant trouvé
                                                <br>
                                                <small>Commencez par ajouter votre premier étudiant</small>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>