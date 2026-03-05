<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Écolage - Administration</title>
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
        .stats-box {
            background-color: rgba(255, 255, 255, 0.2);
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
                        <i class="bi bi-cash-stack me-2"></i>Gestion Écolage
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
                            <div class="stats-box p-3 rounded">
                                <i class="bi bi-currency-dollar fs-2 d-block"></i>
                                <h4 class="mb-0">${totalDu}</h4>
                                <small>Total dû</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6 mb-3 mb-md-0">
                            <div class="stats-box p-3 rounded">
                                <i class="bi bi-check-circle fs-2 d-block"></i>
                                <h4 class="mb-0">${totalPaye}</h4>
                                <small>Total payé</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="stats-box p-3 rounded">
                                <i class="bi bi-wallet2 fs-2 d-block"></i>
                                <h4 class="mb-0">${resteAPayer}</h4>
                                <small>Reste à payer</small>
                            </div>
                        </div>
                        <div class="col-md-3 col-6">
                            <div class="stats-box p-3 rounded">
                                <i class="bi bi-exclamation-triangle fs-2 d-block"></i>
                                <h4 class="mb-0">${retardCount}</h4>
                                <small>En retard</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card shadow mb-4">
                    <div class="card-header bg-dark text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-person-check me-2"></i>Sélection étudiant
                        </h5>
                    </div>
                    <div class="card-body">
                        <form class="row g-3" method="get" action="${pageContext.request.contextPath}/admin/inscriptions">
                            <div class="col-md-8">
                                <select name="etudiantId" class="form-select" required>
                                    <option value="">Sélectionner un étudiant</option>
                                    <c:forEach var="e" items="${etudiants}">
                                        <option value="${e.id}" <c:if test="${selectedEtudiant != null && selectedEtudiant.id == e.id}">selected</c:if>>
                                            ${e.nom} ${e.prenom} (${e.numeroEtudiant})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <button type="submit" class="btn btn-primary w-100">
                                    <i class="bi bi-search me-1"></i>Afficher
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="bi bi-check-circle-fill me-2"></i>${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <div class="card shadow">
                    <div class="card-header bg-dark text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-calendar2-week me-2"></i>Créer échéancier
                        </h5>
                    </div>
                    <div class="card-body">
                        <form class="row g-3" method="post" action="${pageContext.request.contextPath}/admin/inscriptions">
                            <input type="hidden" name="action" value="createEcheancier" />
                            <div class="col-md-6">
                                <label class="form-label">Étudiant</label>
                                <select name="etudiantId" class="form-select" required>
                                    <option value="">Sélectionner un étudiant</option>
                                    <c:forEach var="e" items="${etudiants}">
                                        <option value="${e.id}" <c:if test="${selectedEtudiant != null && selectedEtudiant.id == e.id}">selected</c:if>>
                                            ${e.nom} ${e.prenom} (${e.numeroEtudiant})
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Frais annuel (Ar)</label>
                                <input class="form-control" type="number" step="0.01" min="0" name="fraisAnnuel" required />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Nombre de tranches</label>
                                <input class="form-control" type="number" min="1" name="nombreTranches" required />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Mois départ</label>
                                <input class="form-control" type="month" name="moisDepart" />
                            </div>
                            <div class="col-md-4">
                                <label class="form-label">Jour échéance</label>
                                <input class="form-control" value="05" readonly />
                            </div>
                            <div class="col-12">
                                <button class="btn btn-success" type="submit">
                                    <i class="bi bi-plus-circle me-1"></i>Créer échéancier
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Autres inscriptions -->
                <div class="card shadow mt-4">
                    <div class="card-header bg-secondary text-white">
                        <h5 class="mb-0">
                            <i class="bi bi-list-ul me-2"></i>Tranches de l'étudiant
                        </h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Libellé</th>
                                        <th>Montant</th>
                                        <th>Échéance</th>
                                        <th>Statut</th>
                                        <th>Référence</th>
                                        <th>Date paiement</th>
                                        <th class="text-center">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="t" items="${tranchesEtudiant}">
                                        <tr>
                                            <td>${t.libelle}</td>
                                            <td>${t.montant} Ar</td>
                                            <td>${t.dateEcheance}</td>
                                            <td>${t.statut}</td>
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
                                                    <c:when test="${t.datePaiement != null}">${t.datePaiement}</c:when>
                                                    <c:otherwise><span class="text-muted">N/A</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td class="text-center">
                                                <c:if test="${t.statut.toString() != 'PAYEE'}">
                                                    <button class="btn btn-sm btn-success action-btn" type="button"
                                                            data-bs-toggle="modal" data-bs-target="#validerPaiementModal"
                                                            data-tranche-id="${t.id}"
                                                            data-etudiant-id="${selectedEtudiant != null ? selectedEtudiant.id : ''}">
                                                        <i class="bi bi-check-circle"></i>
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty tranchesEtudiant}">
                                        <tr>
                                            <td colspan="7" class="text-center text-muted py-4">
                                                <i class="bi bi-cash-stack fs-1 d-block mb-2"></i>
                                                Aucune tranche.
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

    <div class="modal fade" id="validerPaiementModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <form method="post" action="${pageContext.request.contextPath}/admin/inscriptions">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="bi bi-check-circle me-2"></i>Valider paiement
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="action" value="validerPaiement" />
                        <input type="hidden" name="id" id="validerPaiementTrancheId" />
                        <input type="hidden" name="etudiantIdReturn" id="validerPaiementEtudiantId" />

                        <div class="mb-3">
                            <label class="form-label">Référence paiement</label>
                            <input class="form-control" name="reference" maxlength="100" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Date paiement</label>
                            <input class="form-control" type="date" name="datePaiement" />
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Annuler</button>
                        <button type="submit" class="btn btn-success">
                            <i class="bi bi-check-circle me-1"></i>Valider
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var modalEl = document.getElementById('validerPaiementModal');
            if (!modalEl) return;
            modalEl.addEventListener('show.bs.modal', function (event) {
                var button = event.relatedTarget;
                var trancheId = button ? button.getAttribute('data-tranche-id') : '';
                var etudiantId = button ? button.getAttribute('data-etudiant-id') : '';
                var idInput = document.getElementById('validerPaiementTrancheId');
                var etuInput = document.getElementById('validerPaiementEtudiantId');
                if (idInput) idInput.value = trancheId || '';
                if (etuInput) etuInput.value = etudiantId || '';
            });
        });
    </script>
</body>
</html>