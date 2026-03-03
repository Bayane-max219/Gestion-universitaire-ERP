<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Paiements - Administration</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa; /* Fond blanc très clair comme demandé */
        }
        .payment-card {
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        .payment-card:hover {
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
        .stats-container {
            background: linear-gradient(135deg, #4cc9f0 0%, #4895ef 100%);
            color: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        .payment-status {
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 500;
        }
        .status-a-payer {
            background-color: #fff3cd;
            color: #856404;
        }
        .status-payee {
            background-color: #d4edda;
            color: #155724;
        }
        .status-en-retard {
            background-color: #f8d7da;
            color: #721c24;
        }
        .status-annulee {
            background-color: #d6d8d9;
            color: #383d41;
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
                        <i class="bi bi-cash-stack me-2"></i>Paiements (Tranches)
                        <span class="badge bg-secondary ms-2">${tranches.size()}</span>
                    </h2>
                    <div class="btn-group">
                        <a href="admin/paiements" class="btn btn-primary">
                            <i class="bi bi-arrow-repeat me-1"></i>Actualiser
                        </a>
                    </div>
                </div>

                <!-- Statistiques rapides -->
                <div class="stats-container">
                    <div class="row text-center">
                        <div class="col-md-3 col-6 mb-3 mb-md-0">
                            <div class="bg-white bg-opacity-20 p-3 rounded">
                                <i class="bi bi-currency-dollar fs-2 d-block"></i>
                                <h4 class="mb-0">${totalTranches}</h4>
                                <small>Total Tranches</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6 mb-3 mb-md-0">
                            <div class="bg-white bg-opacity-20 p-3 rounded">
                                <i class="bi bi-check-circle fs-2 d-block"></i>
                                <h4 class="mb-0">${payeesCount}</h4>
                                <small>Payées</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="bg-white bg-opacity-20 p-3 rounded">
                                <i class="bi bi-x-circle fs-2 d-block"></i>
                                <h4 class="mb-0">${nonPayeesCount}</h4>
                                <small>À payer</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="bg-white bg-opacity-20 p-3 rounded">
                                <i class="bi bi-exclamation-triangle fs-2 d-block"></i>
                                <h4 class="mb-0">${retardCount}</h4>
                                <small>En retard</small>
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
                                        <th>Inscription ID</th>
                                        <th>Montant</th>
                                        <th>Échéance</th>
                                        <th>Référence</th>
                                        <th>Statut</th>
                                        <th>Date paiement</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="t" items="${tranches}">
                                        <tr>
                                            <td>
                                                <strong>${t.inscription.etudiant.nom} ${t.inscription.etudiant.prenom}</strong><br>
                                                <small class="text-muted">${t.inscription.etudiant.email}</small>
                                            </td>
                                            <td>${t.inscription.id}</td>
                                            <td>
                                                <span class="badge bg-info">
                                                    <i class="bi bi-currency-dollar me-1"></i>
                                                    ${t.montant} Ar
                                                </span>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${t.dateEcheance != null}">
                                                        ${t.dateEcheance}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">N/A</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${t.referencePaiement != null && t.referencePaiement != ''}">
                                                        <span class="badge bg-secondary">${t.referencePaiement}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">N/A</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${t.statut.toString() == 'PAYEE'}">
                                                        <span class="payment-status status-payee">
                                                            <i class="bi bi-check-circle me-1"></i>PAYÉE
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${t.statut.toString() == 'A_PAYER'}">
                                                        <span class="payment-status status-a-payer">
                                                            <i class="bi bi-clock me-1"></i>À PAYER
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${t.statut.toString() == 'EN_RETARD'}">
                                                        <span class="payment-status status-en-retard">
                                                            <i class="bi bi-exclamation-triangle me-1"></i>EN RETARD
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${t.statut.toString() == 'ANNULEE'}">
                                                        <span class="payment-status status-annulee">
                                                            <i class="bi bi-x-circle me-1"></i>ANNULÉE
                                                        </span>
                                                    </c:when>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${t.datePaiement != null}">
                                                        ${t.datePaiement}
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="text-muted">N/A</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <div class="btn-group" role="group">
                                                    <c:if test="${t.statut.toString() != 'PAYEE'}">
                                                        <a class="btn btn-sm btn-success action-btn" 
                                                           href="${pageContext.request.contextPath}/admin/paiements?action=valider&id=${t.id}" 
                                                           title="Valider paiement">
                                                            <i class="bi bi-check-circle"></i>
                                                        </a>
                                                    </c:if>
                                                    <c:if test="${t.statut.toString() == 'PAYEE'}">
                                                        <span class="text-success">
                                                            <i class="bi bi-check-all"></i>
                                                        </span>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty tranches}">
                                        <tr>
                                            <td colspan="8" class="text-center text-muted py-4">
                                                <i class="bi bi-cash-stack fs-1 d-block mb-2"></i>
                                                Aucune tranche de paiement trouvée.
                                                <br>
                                                <small>Les paiements seront affichés ici une fois créés</small>
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