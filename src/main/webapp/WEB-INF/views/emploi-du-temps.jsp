<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Emploi du Temps - Mada U</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(rgba(248, 249, 250, 0.95), rgba(248, 249, 250, 0.95)), url('../../resources/images/background.jpg') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            backdrop-filter: blur(3px);
        }
        .schedule-card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
        }
        .day-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem;
            border-radius: 10px 10px 0 0;
        }
        .time-slot {
            border-bottom: 1px solid #eee;
            padding: 1rem;
            transition: background-color 0.2s ease;
        }
        .time-slot:hover {
            background-color: rgba(102, 126, 234, 0.05);
        }
        .subject-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 8px;
            padding: 0.8rem;
            margin: 0.2rem 0;
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

    <div class="container mt-4">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2 class="text-primary">
                <i class="bi bi-calendar-week me-2"></i>Emploi du Temps
            </h2>
            <a href="dashboard" class="btn btn-outline-secondary">
                <i class="bi bi-arrow-left me-1"></i>Retour au Dashboard
            </a>
        </div>

        <div class="card shadow mb-4">
            <div class="card-body">
                <form class="row g-3" method="get" action="${pageContext.request.contextPath}/emplois-du-temps">
                    <div class="col-md-6">
                        <label class="form-label"><i class="bi bi-calendar-month me-1"></i>Mois</label>
                        <input type="month" class="form-control" name="mois" value="${selectedMoisStr}">
                    </div>
                    <div class="col-md-2 d-flex align-items-end">
                        <button class="btn btn-primary w-100" type="submit">
                            <i class="bi bi-funnel me-1"></i>Filtrer
                        </button>
                    </div>
                </form>
            </div>
        </div>

        <div class="stats-container">
            <div class="row text-center">
                <div class="col-md-3 col-6 mb-3 mb-md-0">
                    <div class="bg-white bg-opacity-75 text-dark p-3 rounded">
                        <i class="bi bi-calendar-event fs-2 d-block"></i>
                        <h4 class="mb-0">${emploisDuTemps.size()}</h4>
                        <small>Total Plages</small>
                    </div>
                </div>
                <div class="col-md-3 col-6 mb-3 mb-md-0">
                    <div class="bg-white bg-opacity-75 text-dark p-3 rounded">
                        <i class="bi bi-book-fill fs-2 d-block"></i>
                        <h4 class="mb-0">${uniqueSubjectsCount != null ? uniqueSubjectsCount : 0}</h4>
                        <small>Matières</small>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="bg-white bg-opacity-75 text-dark p-3 rounded">
                        <i class="bi bi-person-fill fs-2 d-block"></i>
                        <h4 class="mb-0">${uniqueTeachersCount != null ? uniqueTeachersCount : 0}</h4>
                        <small>Professeurs</small>
                    </div>
                </div>
                <div class="col-md-3 col-6">
                    <div class="bg-white bg-opacity-75 text-dark p-3 rounded">
                        <i class="bi bi-people-fill fs-2 d-block"></i>
                        <h4 class="mb-0">${uniqueDaysCount != null ? uniqueDaysCount : 0}</h4>
                        <small>Jours Actifs</small>
                    </div>
                </div>
            </div>
        </div>

        <div class="row">
            <c:forEach var="entry" items="${emploisDuTempsByDay}">
                <div class="col-md-2 mb-3">
                    <div class="schedule-card">
                        <div class="day-header text-center">
                            <h6 class="mb-0">${entry.key}</h6>
                        </div>
                        <div class="card-body p-2">
                            <c:forEach var="emploi" items="${entry.value}">
                                <div class="time-slot">
                                    <div class="subject-card">
                                        <small>${emploi.heureDebut} - ${emploi.heureFin}</small>
                                        <div class="fw-bold">${emploi.matiere.nom}</div>
                                        <small>${emploi.salle}</small>
                                        <div><small>${emploi.professeur.nom} ${emploi.professeur.prenom}</small></div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </c:forEach>

            <c:if test="${empty emploisDuTempsByDay}">
                <div class="col-12">
                    <div class="alert alert-info">
                        Aucun emploi du temps disponible pour ce mois.
                    </div>
                </div>
            </c:if>
        </div>

        <div class="card mt-4">
            <div class="card-header bg-info text-white">
                <h5 class="mb-0">
                    <i class="bi bi-info-circle me-2"></i>Informations importantes
                </h5>
            </div>
            <div class="card-body">
                <ul class="mb-0">
                    <li>Les emplois du temps peuvent être mis à jour selon les disponibilités des enseignants</li>
                    <li>Les salles indiquées sont susceptibles de changer</li>
                    <li>Consultez régulièrement cette page pour les mises à jour</li>
                </ul>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>