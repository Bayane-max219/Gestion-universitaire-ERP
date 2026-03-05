<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications - ERP Universitaire</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa; /* Fond blanc très clair comme demandé */
        }
        .notification-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .notification-card:hover {
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
        .notification-item {
            border-left: 4px solid #4361ee;
            padding: 15px;
            margin-bottom: 10px;
            border-radius: 0 5px 5px 0;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .notification-read {
            background-color: #f8f9fa;
        }
        .notification-unread {
            background-color: #fff;
            border-left-color: #ff6b6b;
        }
        .stats-container {
            background: linear-gradient(135deg, #f72585 0%, #b5179e 100%);
            color: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        .stats-box {
            background-color: rgba(255, 255, 255, 0.2);
        }
        .timestamp {
            font-size: 0.85em;
            color: #6c757d;
        }
        .notification-icon {
            font-size: 1.5em;
            margin-right: 10px;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <c:set var="authUser" value="${sessionScope.authUser}" />
    <c:set var="isAdmin" value="${authUser != null && authUser.role != null && authUser.role.id == 1}" />

    <div class="container-fluid mt-4">
        <div class="row">
            <div class="col-md-12">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="text-primary">
                        <i class="bi bi-bell me-2"></i>Notifications
                        <span class="badge bg-secondary ms-2">${notifications.size()}</span>
                    </h2>
                    <div class="btn-group">
                        <a href="notifications" class="btn btn-primary">
                            <i class="bi bi-arrow-repeat me-1"></i>Actualiser
                        </a>
                    </div>
                </div>

                <!-- Statistiques rapides -->
                <div class="stats-container">
                    <div class="row text-center">
                        <div class="col-md-3 col-6 mb-3 mb-md-0">
                            <div class="stats-box p-3 rounded">
                                <i class="bi bi-bell-fill fs-2 d-block"></i>
                                <h4 class="mb-0">${notifications.size()}</h4>
                                <small>Total Notifications</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6 mb-3 mb-md-0">
                            <div class="stats-box p-3 rounded">
                                <i class="bi bi-envelope-open fs-2 d-block"></i>
                                <h4 class="mb-0">${unreadCount}</h4>
                                <small>Non lues</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="stats-box p-3 rounded">
                                <i class="bi bi-envelope-check fs-2 d-block"></i>
                                <h4 class="mb-0">${readCount}</h4>
                                <small>Lues</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="stats-box p-3 rounded">
                                <i class="bi bi-journal-bookmark fs-2 d-block"></i>
                                <h4 class="mb-0">${relatedInscriptionsCount}</h4>
                                <small>Associées</small>
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

                <c:if test="${!isAdmin}">
                    <div class="card shadow">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">
                                <i class="bi bi-inbox me-2"></i>Boîte de réception
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:forEach var="n" items="${notifications}">
                                <div class="notification-item ${n.readFlag ? 'notification-read' : 'notification-unread'}">
                                    <div class="d-flex justify-content-between align-items-start">
                                        <div>
                                            <h6 class="mb-1">${n.message}</h6>
                                            <div class="timestamp">
                                                <i class="bi bi-clock-history me-1"></i>${n.createdAt}
                                            </div>
                                        </div>
                                        <div class="text-end">
                                            <a class="btn btn-sm btn-outline-primary" href="${pageContext.request.contextPath}/notifications?action=view&id=${n.id}">
                                                Ouvrir
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>

                            <c:if test="${empty notifications}">
                                <div class="text-center py-4">
                                    <i class="bi bi-bell fs-1 text-muted d-block mb-3"></i>
                                    <h5 class="text-muted">Aucune notification</h5>
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:if>

                <c:if test="${isAdmin}">
                    <div class="card shadow mb-4">
                        <div class="card-header bg-dark text-white">
                            <h5 class="mb-0">
                                <i class="bi bi-send me-2"></i>Envoyer une notification
                            </h5>
                        </div>
                        <div class="card-body">
                            <form method="post" action="${pageContext.request.contextPath}/notifications">
                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <label class="form-label">Étudiant</label>
                                        <select class="form-select" name="etudiantId" required>
                                            <option value="">Sélectionner...</option>
                                            <c:forEach var="e" items="${etudiants}">
                                                <option value="${e.id}">
                                                    ${e.nom} ${e.prenom} (${e.numeroEtudiant})
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-8">
                                        <label class="form-label">Message</label>
                                        <input class="form-control" name="message" maxlength="255" required />
                                    </div>
                                    <div class="col-12">
                                        <button class="btn btn-primary" type="submit">
                                            <i class="bi bi-send me-1"></i>Envoyer
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:if>

                <c:if test="${isAdmin}">
                    <div class="card shadow">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">
                                <i class="bi bi-list me-2"></i>Détail des Notifications
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:forEach var="n" items="${notifications}">
                                <div class="notification-item ${n.readFlag ? 'notification-read' : 'notification-unread'}">
                                    <div class="row">
                                        <div class="col-md-8">
                                            <div class="d-flex align-items-start">
                                                <i class="bi bi-info-circle-fill notification-icon ${n.readFlag ? 'text-muted' : 'text-danger'}"></i>
                                                <div>
                                                    <h6 class="mb-1">${n.message}</h6>
                                                    <small class="text-muted">
                                                        <i class="bi bi-journal-bookmark me-1"></i>
                                                        <c:choose>
                                                            <c:when test="${n.etudiant != null}">
                                                                ${n.etudiant.nom} ${n.etudiant.prenom}
                                                            </c:when>
                                                            <c:otherwise>
                                                                Inscription #${n.inscription.id} - ${n.inscription.etudiant.nom} ${n.inscription.etudiant.prenom}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </small>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4 text-end">
                                            <div class="timestamp">
                                                <i class="bi bi-clock-history me-1"></i>
                                                ${n.createdAt}
                                            </div>
                                            <div class="mt-1">
                                                <c:choose>
                                                    <c:when test="${n.readFlag}">
                                                        <span class="badge bg-success">
                                                            <i class="bi bi-check-circle me-1"></i>Lue
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-warning text-dark">
                                                            <i class="bi bi-exclamation-circle me-1"></i>Non lue
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="mt-2">
                                                <a class="btn btn-sm btn-outline-light" href="${pageContext.request.contextPath}/notifications?action=view&id=${n.id}">
                                                    Marquer lue
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>

                            <c:if test="${empty notifications}">
                                <div class="text-center py-4">
                                    <i class="bi bi-bell fs-1 text-muted d-block mb-3"></i>
                                    <h5 class="text-muted">Aucune notification</h5>
                                    <p class="text-muted">Vous êtes à jour avec toutes les notifications</p>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Vue Tableau -->
                    <div class="card shadow mt-4">
                        <div class="card-header bg-secondary text-white">
                            <h5 class="mb-0">
                                <i class="bi bi-table me-2"></i>Vue Tableau
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="table-responsive">
                                <table class="table table-hover table-striped">
                                    <thead class="table-dark">
                                        <tr>
                                            <th>Date</th>
                                            <th>Inscription</th>
                                            <th>Message</th>
                                            <th>Étudiant</th>
                                            <th>Statut</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="n" items="${notifications}">
                                            <tr>

                                                <td>
                                                    <i class="bi bi-clock-history me-1"></i>
                                                    ${n.createdAt}
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${n.inscription != null}">
                                                            <span class="badge bg-info">#${n.inscription.id}</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">N/A</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <td>
                                                    <div class="text-truncate" style="max-width: 300px;">
                                                        ${n.message}
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${n.etudiant != null}">
                                                            <strong>${n.etudiant.nom} ${n.etudiant.prenom}</strong><br>
                                                            <small class="text-muted">${n.etudiant.email}</small>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <strong>${n.inscription.etudiant.nom} ${n.inscription.etudiant.prenom}</strong><br>
                                                            <small class="text-muted">${n.inscription.etudiant.email}</small>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <td>
                                                    <c:choose>
                                                        <c:when test="${n.readFlag}">
                                                            <span class="badge bg-success">
                                                                <i class="bi bi-check-circle me-1"></i>Lue
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-warning text-dark">
                                                                <i class="bi bi-exclamation-circle me-1"></i>Non lue
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:forEach>

                                        <c:if test="${empty notifications}">
                                            <tr>
                                                <td colspan="5" class="text-center text-muted py-4">
                                                    <i class="bi bi-bell fs-1 d-block mb-2"></i>
                                                    Aucune notification.
                                                    <br>
                                                    <small>Les notifications apparaîtront ici</small>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>