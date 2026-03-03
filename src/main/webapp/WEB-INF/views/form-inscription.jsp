<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Nouvelle Inscription</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<%@ include file="navbar.jsp" %>

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow">
                <div class="card-header bg-success text-white">
                    <h3 class="mb-0">Inscrire un étudiant à une matière</h3>
                </div>
                <div class="card-body">
                    <form action="inscriptions" method="post">

                        <div class="mb-3">
                            <label class="form-label">Sélectionner l'Étudiant</label>
                            <select name="etudiantId" class="form-select" required>
                                <option value="">-- Choisir un étudiant --</option>
                                <c:forEach var="e" items="${etudiants}">
                                    <option value="${e.id}">${e.nom} ${e.prenom}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Sélectionner la Matière</label>
                            <select name="matiereId" class="form-select" required>
                                <option value="">-- Choisir une matière --</option>
                                <c:forEach var="m" items="${matieres}">
                                    <option value="${m.id}">${m.nom} (Coef: ${m.coefficient})</option>
                                </c:forEach>
                            </select>
                        </div>

                        <hr>

                        <div class="mb-3">
                            <label class="form-label">Montant tranche (Ar)</label>
                            <input type="number" step="0.01" min="0" name="montantTranche" class="form-control" placeholder="Ex: 100000">
                            <div class="form-text">Optionnel: si vide, aucune tranche ne sera créée.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Date échéance</label>
                            <input type="date" name="dateEcheance" class="form-control">
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Référence paiement</label>
                            <input type="text" name="referencePaiement" class="form-control" placeholder="Ex: Bordereau n°12345">
                        </div>

                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-success">Valider l'inscription</button>
                            <a href="inscriptions" class="btn btn-outline-secondary">Annuler</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>