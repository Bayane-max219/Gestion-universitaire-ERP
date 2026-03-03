<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Relevé de Notes - ERP Universitaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa; /* Fond blanc très clair comme demandé */
        }
        .releve-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .releve-card:hover {
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
        .student-info-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
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
        .summary-card {
            background-color: #f8f9fa;
            border-radius: 10px;
            padding: 1rem;
            margin-bottom: 1rem;
        }
        .print-btn {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
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
                        <i class="bi bi-file-earmark-text me-2"></i>Relevé de Notes
                    </h2>
                    <div class="btn-group">
                        <button class="btn btn-success" onclick="window.print()">
                            <i class="bi bi-printer me-1"></i>Imprimer
                        </button>
                        <a href="notes" class="btn btn-primary">
                            <i class="bi bi-arrow-return-left me-1"></i>Retour
                        </a>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <!-- Informations Étudiant -->
                <div class="student-info-card">
                    <div class="row">
                        <div class="col-md-8">
                            <h3>
                                <i class="bi bi-person-circle me-2"></i>
                                ${etudiant.nom} ${etudiant.prenom}
                            </h3>
                            <p class="mb-1">
                                <i class="bi bi-envelope me-2"></i>
                                ${etudiant.email}
                            </p>
                            <p class="mb-1">
                                <i class="bi bi-card-text me-2"></i>
                                Numéro Étudiant: ${etudiant.numeroEtudiant}
                            </p>
                        </div>
                        <div class="col-md-4 text-end">
                            <h4 class="mb-1">Relevé de Notes</h4>
                            <p class="mb-0">
                                <i class="bi bi-calendar me-1"></i>
                                Date: ${dateCourante}
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Résumé -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="summary-card">
                            <h5 class="text-primary">
                                <i class="bi bi-journal-bookmark me-2"></i>Matières
                            </h5>
                            <h3 class="text-dark">${totalSubjects}</h3>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="summary-card">
                            <h5 class="text-success">
                                <i class="bi bi-pen me-2"></i>Notes
                            </h5>
                            <h3 class="text-dark">${totalGrades}</h3>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="summary-card">
                            <h5 class="text-info">
                                <i class="bi bi-calculator me-2"></i>Moyenne Générale
                            </h5>
                            <h3 class="text-dark">${overallAverage}</h3>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="summary-card">
                            <h5 class="text-warning">
                                <i class="bi bi-trophy me-2"></i>Rang
                            </h5>
                            <h3 class="text-dark">${rank}</h3>
                        </div>
                    </div>
                </div>

                <!-- Tableau des Notes -->
                <div class="card shadow">
                    <div class="card-header bg-dark text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-list-ul me-2"></i>Détail des Notes
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Matière</th>
                                        <th>Coefficient</th>
                                        <th>Note</th>
                                        <th>Type Évaluation</th>
                                        <th>Moyenne Matière</th>
                                        <th>Classement</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="entry" items="${gradesBySubject}">
                                        <tr>
                                            <td>
                                                <strong>${entry.key.nom}</strong>
                                            </td>
                                            <td>
                                                <span class="badge bg-info">${entry.key.coefficient}</span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${entry.value.grade >= 16}">
                                                        <span class="badge grade-high">${entry.value.grade}</span>
                                                    </c:when>
                                                    <c:when test="${entry.value.grade >= 10}">
                                                        <span class="badge grade-medium">${entry.value.grade}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge grade-low">${entry.value.grade}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${entry.value.type != null}">
                                                        <span class="badge bg-success">${entry.value.type}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">N/A</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${entry.value.subjectAvg != null}">
                                                        <span class="badge bg-info">${entry.value.subjectAvg}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">N/A</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${entry.value.rank != null}">
                                                        <span class="badge bg-warning text-dark">#${entry.value.rank}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">N/A</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty gradesBySubject}">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-4">
                                                <i class="bi bi-pen fs-1 d-block mb-2"></i>
                                                Aucune note disponible pour cet étudiant.
                                                <br>
                                                <small>Les notes apparaîtront ici une fois saisies</small>
                                            </td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Signature -->
                <div class="row mt-5">
                    <div class="col-md-6 offset-md-6">
                        <div class="border-top pt-3">
                            <p class="text-center mb-0">
                                <small class="text-muted">
                                    <i class="bi bi-shield-lock me-1"></i>
                                    Ce relevé est certifié conforme par le service scolarité
                                </small>
                            </p>
                            <p class="text-center mb-0 mt-2">
                                <strong>Signature:</strong> _________________________
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>