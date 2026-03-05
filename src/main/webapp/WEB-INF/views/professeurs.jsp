<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Professeurs - ERP Universitaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa; /* Fond blanc très clair comme demandé */
        }
        .teacher-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .teacher-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        }
        .table th {
            background-color: #4361ee;
            color: white;
        }
        .action-btn {
            transition: all 0.2s ease;
        }
        .action-btn:hover {
            transform: scale(1.05);
        }
        .stats-card {
            background: linear-gradient(135deg, #f72585 0%, #b5179e 100%);
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
                        <i class="bi bi-person-lines-fill me-2"></i>Professeurs
                        <span class="badge bg-secondary ms-2">${professeurs.size()}</span>
                    </h2>
                    <a href="professeurs?action=new" class="btn btn-success">
                        <i class="bi bi-plus-circle me-1"></i>Nouveau Professeur
                    </a>
                </div>

                <!-- Statistiques rapides -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card stats-card text-white">
                            <div class="card-body text-center">
                                <i class="bi bi-person-fill fs-1"></i>
                                <h4 class="card-title">${professeurs.size()}</h4>
                                <p class="card-text">Total Professeurs</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-info text-white">
                            <div class="card-body text-center">
                                <i class="bi bi-book-fill fs-1"></i>
                                <h4 class="card-title">${totalMatieresAssignees}</h4>
                                <p class="card-text">Matières Assignées</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-success text-white">
                            <div class="card-body text-center">
                                <i class="bi bi-calendar-check fs-1"></i>
                                <h4 class="card-title">${totalEmploisDuTemps}</h4>
                                <p class="card-text">Emplois du Temps</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-warning text-white">
                            <div class="card-body text-center">
                                <i class="bi bi-hourglass-split fs-1"></i>
                                <h4 class="card-title">${totalHeuresEns}</h4>
                                <small>Heures Enseignement</small>
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

                <div class="card shadow">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Nom</th>
                                        <th>Prénom</th>
                                        <th>Email</th>
                                        <th>Téléphone</th>
                                        <th>Matières Assignées</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="professeur" items="${professeurs}">
                                        <tr>
                                            <td>${professeur.nom}</td>
                                            <td>${professeur.prenom}</td>
                                            <td>${professeur.email}</td>
                                            <td>${professeur.telephone}</td>
                                            <td>
                                                <c:set var="matiereCount" value="${matieresParProf[professeur.id]}" />
                                                <c:choose>
                                                    <c:when test="${matiereCount != null && matiereCount > 0}">
                                                        <span class="badge bg-success">${matiereCount}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning text-dark">0</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <div class="btn-group" role="group">
                                                    <a href="professeurs?action=edit&id=${professeur.id}" 
                                                       class="btn btn-sm btn-outline-primary action-btn" 
                                                       title="Modifier">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <a href="professeurs?action=delete&id=${professeur.id}" 
                                                       class="btn btn-sm btn-outline-danger action-btn" 
                                                       title="Supprimer"
                                                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce professeur ?')">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                    <a href="matieres?professeurId=${professeur.id}" 
                                                       class="btn btn-sm btn-outline-info action-btn" 
                                                       title="Matières Associées">
                                                        <i class="bi bi-book"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty professeurs}">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-4">
                                                <i class="bi bi-person fs-1 d-block mb-2"></i>
                                                Aucun professeur trouvé
                                                <br>
                                                <small>Commencez par ajouter votre premier professeur</small>
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