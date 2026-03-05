<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Matières - ERP Universitaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa; /* Fond blanc très clair comme demandé */
        }
        .subject-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .subject-card:hover {
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
        .coefficient-badge {
            min-width: 50px;
            display: inline-block;
        }
        .stats-card {
            background: linear-gradient(135deg, #4cc9f0 0%, #4361ee 100%);
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
                        <i class="bi bi-book me-2"></i>Matières
                        <span class="badge bg-secondary ms-2">${matieres.size()}</span>
                    </h2>
                    <c:set var="authUser" value="${sessionScope.authUser}" />
                    <c:set var="isAdmin" value="${authUser != null && authUser.role != null && authUser.role.id == 1}" />
                    <c:if test="${isAdmin}">
                        <a href="matieres?action=new" class="btn btn-success">
                            <i class="bi bi-plus-circle me-1"></i>Nouvelle Matière
                        </a>
                    </c:if>
                </div>

                <!-- Statistiques rapides -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card stats-card text-white">
                            <div class="card-body text-center">
                                <i class="bi bi-book-fill fs-1"></i>
                                <h4 class="card-title">${matieres.size()}</h4>
                                <p class="card-text">Total Matières</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-info text-white">
                            <div class="card-body text-center">
                                <i class="bi bi-people-fill fs-1"></i>
                                <h4 class="card-title">${totalCoefficients}</h4>
                                <p class="card-text">Coefficients Total</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-success text-white">
                            <div class="card-body text-center">
                                <i class="bi bi-person-fill fs-1"></i>
                                <h4 class="card-title">${uniqueProfessors}</h4>
                                <p class="card-text">Professeurs</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card bg-warning text-white">
                            <div class="card-body text-center">
                                <i class="bi bi-journal fs-1"></i>
                                <h4 class="card-title">${totalInscriptions}</h4>
                                <p class="card-text">Inscriptions</p>
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
                                        <th>Coefficient</th>
                                        <th>Professeur Responsable</th>
                                        <c:if test="${isAdmin}">
                                            <th class="text-center">Actions</th>
                                        </c:if>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="matiere" items="${matieres}">
                                        <tr>
                                            <td>${matiere.nom}</td>
                                            <td>
                                                <span class="badge bg-info coefficient-badge">${matiere.coefficient}</span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${matiere.professeurResponsable != null}">
                                                        <span class="badge bg-success">
                                                            <i class="bi bi-person-circle me-1"></i>
                                                            ${matiere.professeurResponsable.nom} ${matiere.professeurResponsable.prenom}
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning text-dark">
                                                            <i class="bi bi-person-x me-1"></i>
                                                            Non assigné
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <c:if test="${isAdmin}">
                                                <td class="text-center">
                                                    <div class="btn-group" role="group">
                                                        <a href="matieres?action=edit&id=${matiere.id}" 
                                                           class="btn btn-sm btn-outline-primary action-btn" 
                                                           title="Modifier">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                        <a href="matieres?action=delete&id=${matiere.id}" 
                                                           class="btn btn-sm btn-outline-danger action-btn" 
                                                           title="Supprimer"
                                                           onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette matière ?')">
                                                            <i class="bi bi-trash"></i>
                                                        </a>
                                                        <a href="programmes?action=new&matiereId=${matiere.id}" 
                                                           class="btn btn-sm btn-outline-info action-btn" 
                                                           title="Programme">
                                                            <i class="bi bi-list-task"></i>
                                                        </a>
                                                        <a href="emplois-du-temps?action=new&matiereId=${matiere.id}" 
                                                           class="btn btn-sm btn-outline-warning action-btn" 
                                                           title="Emploi du temps">
                                                            <i class="bi bi-calendar"></i>
                                                        </a>
                                                    </div>
                                                </td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty matieres}">
                                        <tr>
                                            <td colspan="${isAdmin ? 4 : 3}" class="text-center text-muted py-4">
                                                <i class="bi bi-book fs-1 d-block mb-2"></i>
                                                Aucune matière trouvée
                                                <br>
                                                <small>Commencez par ajouter votre première matière</small>
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