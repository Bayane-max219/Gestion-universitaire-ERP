<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notes - ERP Universitaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa; /* Fond blanc très clair comme demandé */
        }
        .note-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .note-card:hover {
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
        .grade-high {
            background-color: #d4edda;
            color: #155724;
            font-weight: bold;
        }
        .grade-low {
            background-color: #f8d7da;
            color: #721c24;
            font-weight: bold;
        }
        .grade-medium {
            background-color: #fff3cd;
            color: #856404;
            font-weight: bold;
        }
        .stats-container {
            background: linear-gradient(135deg, #4cc9f0 0%, #4895ef 100%);
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
                        <i class="bi bi-pen me-2"></i>Notes
                        <span class="badge bg-secondary ms-2">${notes.size()}</span>
                    </h2>
                    <a href="notes?action=new" class="btn btn-success">
                        <i class="bi bi-plus-circle me-1"></i>Nouvelle Note
                    </a>
                </div>

                <!-- Statistiques rapides -->
                <div class="stats-container">
                    <div class="row text-center">
                        <div class="col-md-3 col-6 mb-3 mb-md-0">
                            <div class="bg-white bg-opacity-20 p-3 rounded">
                                <i class="bi bi-journal-album fs-2 d-block"></i>
                                <h4 class="mb-0">${notes.size()}</h4>
                                <small>Total Notes</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6 mb-3 mb-md-0">
                            <div class="bg-white bg-opacity-20 p-3 rounded">
                                <i class="bi bi-people-fill fs-2 d-block"></i>
                                <h4 class="mb-0">${uniqueStudentsCount}</h4>
                                <small>Étudiants Notés</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="bg-white bg-opacity-20 p-3 rounded">
                                <i class="bi bi-book-fill fs-2 d-block"></i>
                                <h4 class="mb-0">${uniqueSubjectsCount}</h4>
                                <small>Matières</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="bg-white bg-opacity-20 p-3 rounded">
                                <i class="bi bi-graph-up fs-2 d-block"></i>
                                <h4 class="mb-0">${averageGrade}</h4>
                                <small>Moyenne Générale</small>
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
                                        <th>Étudiant</th>
                                        <th>Matière</th>
                                        <th>Valeur</th>
                                        <th>Type d'évaluation</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="note" items="${notes}">
                                        <tr>
                                            <td>
                                                <strong>${note.inscription.etudiant.nom} ${note.inscription.etudiant.prenom}</strong><br>
                                                <small class="text-muted">${note.inscription.etudiant.numeroEtudiant}</small>
                                            </td>
                                            <td>
                                                <strong>${note.matiere.nom}</strong><br>
                                                <small class="text-muted">Coeff: ${note.matiere.coefficient}</small>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${note.valeur >= 16}">
                                                        <span class="badge grade-high">${note.valeur}</span>
                                                    </c:when>
                                                    <c:when test="${note.valeur >= 10}">
                                                        <span class="badge grade-medium">${note.valeur}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge grade-low">${note.valeur}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${note.typeEvaluation != null}">
                                                        <span class="badge bg-info">${note.typeEvaluation}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">N/A</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <div class="btn-group" role="group">
                                                    <a href="notes?action=edit&id=${note.id}" 
                                                       class="btn btn-sm btn-outline-primary action-btn" 
                                                       title="Modifier">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <a href="notes?action=delete&id=${note.id}" 
                                                       class="btn btn-sm btn-outline-danger action-btn" 
                                                       title="Supprimer"
                                                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette note ?')">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                    <a href="releve-notes?etudiantId=${note.inscription.etudiant.id}" 
                                                       class="btn btn-sm btn-outline-info action-btn" 
                                                       title="Relevé de notes">
                                                        <i class="bi bi-file-earmark-text"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty notes}">
                                        <tr>
                                            <td colspan="5" class="text-center text-muted py-4">
                                                <i class="bi bi-pen fs-1 d-block mb-2"></i>
                                                Aucune note trouvée
                                                <br>
                                                <small>Commencez par ajouter votre première note</small>
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