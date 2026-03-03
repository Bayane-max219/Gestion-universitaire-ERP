<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Emplois du Temps - ERP Universitaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa; /* Fond blanc très clair comme demandé */
        }
        .emploi-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .emploi-card:hover {
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
        .calendar-day {
            background-color: #e9ecef;
            border-radius: 8px;
            padding: 10px;
            margin-bottom: 10px;
        }
        .schedule-item {
            background-color: #fff;
            border-left: 4px solid #4361ee;
            padding: 10px;
            margin-bottom: 5px;
            border-radius: 0 5px 5px 0;
        }
        .stats-container {
            background: linear-gradient(135deg, #7209b7 0%, #3a0ca3 100%);
            color: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        .day-header {
            background-color: #4361ee;
            color: white;
            padding: 8px 12px;
            border-radius: 5px;
            margin-bottom: 10px;
            font-weight: bold;
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
                        <i class="bi bi-calendar me-2"></i>Emplois du Temps
                        <span class="badge bg-secondary ms-2">${emploisDuTemps.size()}</span>
                    </h2>
                    <a href="emplois-du-temps?action=new" class="btn btn-success">
                        <i class="bi bi-plus-circle me-1"></i>Nouvel Emploi du Temps
                    </a>
                </div>

                <!-- Statistiques rapides -->
                <div class="stats-container">
                    <div class="row text-center">
                        <div class="col-md-3 col-6 mb-3 mb-md-0">
                            <div class="bg-white bg-opacity-20 p-3 rounded">
                                <i class="bi bi-calendar-event fs-2 d-block"></i>
                                <h4 class="mb-0">${emploisDuTemps.size()}</h4>
                                <small>Total Plages</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6 mb-3 mb-md-0">
                            <div class="bg-white bg-opacity-20 p-3 rounded">
                                <i class="bi bi-book-fill fs-2 d-block"></i>
                                <h4 class="mb-0">${uniqueSubjectsCount}</h4>
                                <small>Matières</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="bg-white bg-opacity-20 p-3 rounded">
                                <i class="bi bi-person-fill fs-2 d-block"></i>
                                <h4 class="mb-0">${uniqueTeachersCount}</h4>
                                <small>Professeurs</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="bg-white bg-opacity-20 p-3 rounded">
                                <i class="bi bi-people-fill fs-2 d-block"></i>
                                <h4 class="mb-0">${uniqueDaysCount}</h4>
                                <small>Jours Actifs</small>
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

                <!-- Vue Calendrier par Jour -->
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-calendar-check me-2"></i>Calendrier Hebdomadaire
                        </h5>
                    </div>
                    <div class="card-body">
                        <c:forEach var="entry" items="${emploisDuTempsByDay}">
                            <div class="calendar-day">
                                <div class="day-header">
                                    <i class="bi bi-calendar-day me-2"></i>
                                    ${entry.key}
                                </div>
                                <c:forEach var="emploi" items="${entry.value}">
                                    <div class="schedule-item">
                                        <div class="row">
                                            <div class="col-md-2">
                                                <strong>${emploi.heureDebut} - ${emploi.heureFin}</strong>
                                            </div>
                                            <div class="col-md-3">
                                                <span class="badge bg-info">
                                                    <i class="bi bi-book me-1"></i>
                                                    ${emploi.matiere.nom}
                                                </span>
                                            </div>
                                            <div class="col-md-3">
                                                <span class="badge bg-success">
                                                    <i class="bi bi-person me-1"></i>
                                                    ${emploi.professeur.nom} ${emploi.professeur.prenom}
                                                </span>
                                            </div>
                                            <div class="col-md-3">
                                                <span class="badge bg-warning text-dark">
                                                    <i class="bi bi-door-open me-1"></i>
                                                    ${emploi.salle}
                                                </span>
                                            </div>
                                            <div class="col-md-1 text-end">
                                                <div class="btn-group btn-group-sm">
                                                    <a href="emplois-du-temps?action=edit&id=${emploi.id}" 
                                                       class="btn btn-outline-primary action-btn" 
                                                       title="Modifier">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <a href="emplois-du-temps?action=delete&id=${emploi.id}" 
                                                       class="btn btn-outline-danger action-btn" 
                                                       title="Supprimer"
                                                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette plage horaire ?')">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:forEach>

                        <c:if test="${empty emploisDuTempsByDay}">
                            <div class="text-center py-4">
                                <i class="bi bi-calendar-x fs-1 text-muted d-block mb-3"></i>
                                <h5 class="text-muted">Aucun emploi du temps disponible</h5>
                                <p class="text-muted">Commencez par ajouter votre premier emploi du temps</p>
                                <a href="emplois-du-temps?action=new" class="btn btn-primary">
                                    <i class="bi bi-plus-circle me-1"></i>Créer un emploi du temps
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>

                <!-- Vue Tableau -->
                <div class="card shadow mt-4">
                    <div class="card-header bg-secondary text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-table me-2"></i>Toutes les Plages Horaires
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Jour</th>
                                        <th>Horaire</th>
                                        <th>Matière</th>
                                        <th>Professeur</th>
                                        <th>Salle</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="emploi" items="${emploisDuTemps}">
                                        <tr>
                                            <td>
                                                <span class="badge bg-info">
                                                    <i class="bi bi-calendar-day me-1"></i>
                                                    ${emploi.jour}
                                                </span>
                                            </td>
                                            <td>
                                                <strong>${emploi.heureDebut} - ${emploi.heureFin}</strong>
                                            </td>
                                            <td>
                                                <span class="badge bg-success">
                                                    <i class="bi bi-book me-1"></i>
                                                    ${emploi.matiere.nom}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge bg-warning text-dark">
                                                    <i class="bi bi-person me-1"></i>
                                                    ${emploi.professeur.nom} ${emploi.professeur.prenom}
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge bg-secondary">
                                                    <i class="bi bi-door-open me-1"></i>
                                                    ${emploi.salle}
                                                </span>
                                            </td>
                                            <td class="text-center">
                                                <div class="btn-group" role="group">
                                                    <a href="emplois-du-temps?action=edit&id=${emploi.id}" 
                                                       class="btn btn-sm btn-outline-primary action-btn" 
                                                       title="Modifier">
                                                        <i class="bi bi-pencil"></i>
                                                    </a>
                                                    <a href="emplois-du-temps?action=delete&id=${emploi.id}" 
                                                       class="btn btn-sm btn-outline-danger action-btn" 
                                                       title="Supprimer"
                                                       onclick="return confirm('Êtes-vous sûr de vouloir supprimer cette plage horaire ?')">
                                                        <i class="bi bi-trash"></i>
                                                    </a>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty emploisDuTemps}">
                                        <tr>
                                            <td colspan="6" class="text-center text-muted py-4">
                                                <i class="bi bi-calendar-x fs-1 d-block mb-2"></i>
                                                Aucune plage horaire trouvée
                                                <br>
                                                <small>Commencez par ajouter votre première plage horaire</small>
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