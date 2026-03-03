<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Paiements - Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<%@ include file="navbar.jsp" %>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="text-primary">Paiements (Tranches) - Admin</h2>
        <a class="btn btn-danger btn-sm text-white" href="${pageContext.request.contextPath}/logout">Déconnexion</a>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <table class="table table-hover table-bordered bg-white">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
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
                <td>${t.id}</td>
                <td>${t.inscription.etudiant.nom} ${t.inscription.etudiant.prenom}</td>
                <td>${t.inscription.id}</td>
                <td>${t.montant}</td>
                <td>${t.dateEcheance}</td>
                <td>${t.referencePaiement}</td>
                <td><span class="badge bg-info text-dark">${t.statut}</span></td>
                <td>${t.datePaiement}</td>
                <td class="text-center">
                    <c:if test="${t.statut.toString() != 'PAYEE'}">
                        <a class="btn btn-sm btn-success" href="${pageContext.request.contextPath}/admin/paiements?action=valider&id=${t.id}">Valider paiement</a>
                    </c:if>
                    <c:if test="${t.statut.toString() == 'PAYEE'}">
                        <span class="text-muted">OK</span>
                    </c:if>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty tranches}">
            <tr>
                <td colspan="9" class="text-center text-muted">Aucune tranche trouvée.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</div>

</body>
</html>
