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

        <div class="row">
            <div class="col-md-2 mb-3">
                <div class="schedule-card">
                    <div class="day-header text-center">
                        <h6 class="mb-0">Lundi</h6>
                    </div>
                    <div class="card-body p-2">
                        <div class="time-slot">
                            <div class="subject-card">
                                <small>08:00 - 10:00</small>
                                <div class="fw-bold">Mathématiques</div>
                                <small>Salle A101</small>
                            </div>
                        </div>
                        <div class="time-slot">
                            <div class="subject-card">
                                <small>10:30 - 12:30</small>
                                <div class="fw-bold">Physique</div>
                                <small>Salle B205</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-2 mb-3">
                <div class="schedule-card">
                    <div class="day-header text-center">
                        <h6 class="mb-0">Mardi</h6>
                    </div>
                    <div class="card-body p-2">
                        <div class="time-slot">
                            <div class="subject-card">
                                <small>08:00 - 10:00</small>
                                <div class="fw-bold">Informatique</div>
                                <small>Labo 301</small>
                            </div>
                        </div>
                        <div class="time-slot">
                            <div class="subject-card">
                                <small>14:00 - 16:00</small>
                                <div class="fw-bold">Anglais</div>
                                <small>Salle C102</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-2 mb-3">
                <div class="schedule-card">
                    <div class="day-header text-center">
                        <h6 class="mb-0">Mercredi</h6>
                    </div>
                    <div class="card-body p-2">
                        <div class="time-slot">
                            <div class="subject-card">
                                <small>08:00 - 10:00</small>
                                <div class="fw-bold">Chimie</div>
                                <small>Labo 203</small>
                            </div>
                        </div>
                        <div class="time-slot">
                            <div class="subject-card">
                                <small>10:30 - 12:30</small>
                                <div class="fw-bold">Biologie</div>
                                <small>Labo 105</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-2 mb-3">
                <div class="schedule-card">
                    <div class="day-header text-center">
                        <h6 class="mb-0">Jeudi</h6>
                    </div>
                    <div class="card-body p-2">
                        <div class="time-slot">
                            <div class="subject-card">
                                <small>08:00 - 10:00</small>
                                <div class="fw-bold">Français</div>
                                <small>Salle A102</small>
                            </div>
                        </div>
                        <div class="time-slot">
                            <div class="subject-card">
                                <small>14:00 - 16:00</small>
                                <div class="fw-bold">Histoire</div>
                                <small>Salle B103</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-2 mb-3">
                <div class="schedule-card">
                    <div class="day-header text-center">
                        <h6 class="mb-0">Vendredi</h6>
                    </div>
                    <div class="card-body p-2">
                        <div class="time-slot">
                            <div class="subject-card">
                                <small>08:00 - 10:00</small>
                                <div class="fw-bold">Économie</div>
                                <small>Salle C201</small>
                            </div>
                        </div>
                        <div class="time-slot">
                            <div class="subject-card">
                                <small>10:30 - 12:30</small>
                                <div class="fw-bold">Géographie</div>
                                <small>Salle A205</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="col-md-2 mb-3">
                <div class="schedule-card">
                    <div class="day-header text-center">
                        <h6 class="mb-0">Samedi</h6>
                    </div>
                    <div class="card-body p-2">
                        <div class="time-slot">
                            <div class="subject-card">
                                <small>08:00 - 12:00</small>
                                <div class="fw-bold">TP Informatique</div>
                                <small>Labo 302</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
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