<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administration des Inscriptions - ERP Universitaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa; /* Fond blanc très clair comme demandé */
        }
        .admin-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .admin-card:hover {
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
        .status-badge {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 500;
        }
        .status-en-cours {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-validee {
            background-color: #d4edda;
            color: #155724;
        }
        .status-annulee {
            background-color: #f8d7da;
            color: #721c24;
        }
        .stats-container {
            background: linear-gradient(135deg, #4361ee 0%, #3a0ca3 100%);
            color: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
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
                        <i class="bi bi-clipboard-check me-2"></i>Administration des Inscriptions
                        <span class="badge bg-secondary ms-2">${inscriptions.size()}</span>
                    </h2>
                    <div class="btn-group">
                        <a href="admin/inscriptions" class="btn btn-primary">
                            <i class="bi bi-arrow-repeat me-1"></i>Actualiser
                        </a>
                    </div>
                </div>

                <!-- Statistiques rapides -->
                <div class="stats-container">
                    <div class="row text-center">
                        <div class="col-md-3 col-6 mb-3 mb-md-0">
                            <div class="bg-white bg-opacity-20 p-3 rounded">
                                <i class="bi bi-journal-bookmark fs-2 d-block"></i>
                                <h4 class="mb-0">${inscriptions.size()}</h4>
                                <small>Total Inscriptions</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6 mb-3 mb-md-0">
                            <div class="bg-white bg-opacity-20 p-3 rounded">
                                <i class="bi bi-check-circle fs-2 d-block"></i>
                                <h4 class="mb-0">${validesCount}</h4>
                                <small>Validées</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="bg-white bg-opacity-20 p-3 rounded">
                                <i class="bi bi-clock fs-2 d-block"></i>
                                <h4 class="mb-0">${encoursCount}</h4>
                                <small>En cours</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="bg-white bg-opacity-20 p-3 rounded">
                                <i class="bi bi-x-circle fs-2 d-block"></i>
                                <h4 class="mb-0">${annuleesCount}</h4>
                                <small>Annulées</small>
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
                    <div class="card-header bg-dark text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-list-ul me-2"></i>Inspections en Attente
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Étudiant</th>
                                        <th>Matière</th>
                                        <th>Date d'inscription</th>
                                        <th>Statut</th>
                                        <th>Paiement</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="inscription" items="${inscriptions}">
                                        <c:if test="${inscription.statut.toString() == statutEnCours}">
                                            <tr>
                                                <td>
                                                    <strong>${inscription.etudiant.nom} ${inscription.etudiant.prenom}</strong><br>
                                                    <small class="text-muted">${inscription.etudiant.email}</small>
                                                </td>
                                                <td>
                                                    <strong>${inscription.matiere.nom}</strong><br>
                                                    <small class="text-muted">Coeff: ${inscription.matiere.coefficient}</small>
                                                </td>
                                                <td>${inscription.dateInscription}</td>
                                                <td>
                                                    <span class="status-badge status-en-cours">
                                                        <i class="bi bi-clock me-1"></i>EN COURS
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${inscription.etudiantEnRegle}">
                                                            <span class="badge bg-success">
                                                                <i class="bi bi-check-circle me-1"></i>Payé
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger">
                                                                <i class="bi bi-x-circle me-1"></i>Impayé
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-center">
                                                    <div class="btn-group" role="group">
                                                        <a href="admin/inscriptions?action=valider&id=${inscription.id}" 
                                                           class="btn btn-sm btn-success action-btn" 
                                                           title="Valider" 
                                                           onclick="return confirm('Êtes-vous sûr de vouloir valider cette inscription ?')">
                                                            <i class="bi bi-check-circle"></i> Valider
                                                        </a>
                                                        <a href="admin/inscriptions?action=annuler&id=${inscription.id}" 
                                                           class="btn btn-sm btn-danger action-btn" 
                                                           title="Annuler" 
                                                           onclick="return confirm('Êtes-vous sûr de vouloir annuler cette inscription ?')">
                                                            <i class="bi bi-x-circle"></i> Annuler
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>

                                    <c:if test="${empty inscriptions or not inscriptions.stream().anyMatch(i -> i.statut.toString() == statutEnCours)}">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-4">
                                                <i class="bi bi-clipboard-check fs-1 d-block mb-2"></i>
                                                Aucune inscription en attente de validation.
                                                <br>
                                                <small>Toutes les inscriptions sont traitées</small>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Autres inscriptions -->
                <div class="card shadow mt-4">
                    <div class="card-header bg-secondary text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-journal me-2"></i>Toutes les Inscriptions
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Étudiant</th>
                                        <th>Matière</th>
                                        <th>Date</th>
                                        <th>Statut</th>
                                        <th>Paiement</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="inscription" items="${inscriptions}">
                                        <c:if test="${inscription.statut.toString() != statutEnCours}">
                                            <tr>
                                                <td>
                                                    <strong>${inscription.etudiant.nom} ${inscription.etudiant.prenom}</strong><br>
                                                    <small class="text-muted">${inscription.etudiant.email}</small>
                                                </td>
                                                <td>
                                                    <strong>${inscription.matiere.nom}</strong><br>
                                                    <small class="text-muted">Coeff: ${inscription.matiere.coefficient}</small>
                                                </td>
                                                <td>${inscription.dateInscription}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${inscription.statut.toString() == 'VALIDEE'}">
                                                            <span class="status-badge status-validee">
                                                                <i class="bi bi-check-circle me-1"></i>VALIDÉE
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${inscription.statut.toString() == 'ANNULEE'}">
                                                            <span class="status-badge status-annulee">
                                                                <i class="bi bi-x-circle me-1"></i>ANNULÉE
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-en-cours">
                                                                <i class="bi bi-question-circle me-1"></i>${inscription.statut}
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${inscription.etudiantEnRegle}">
                                                            <span class="badge bg-success">
                                                                <i class="bi bi-check-circle me-1"></i>Payé
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger">
                                                                <i class="bi bi-x-circle me-1"></i>Impayé
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
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