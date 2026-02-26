<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Validation Inscriptions - Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<%@ include file="navbar.jsp" %>

<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2 class="text-primary">Workflow: Validation des inscriptions</h2>
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
            <th>Matière</th>
            <th>Date</th>
            <th>Statut</th>
            <th class="text-center">Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="i" items="${inscriptions}">
            <tr>
                <td>${i.id}</td>
                <td>${i.etudiant.nom} ${i.etudiant.prenom}</td>
                <td>${i.matiere.nom}</td>
                <td>${i.dateInscription}</td>
                <td><span class="badge bg-info text-dark">${i.statut}</span></td>
                <td class="text-center">
                    <c:if test="${i.statut.toString() == statutEnCours}">
                        <a class="btn btn-sm btn-success" href="${pageContext.request.contextPath}/admin/inscriptions?action=valider&id=${i.id}">Valider</a>
                        <a class="btn btn-sm btn-danger" href="${pageContext.request.contextPath}/admin/inscriptions?action=annuler&id=${i.id}">Annuler</a>
                    </c:if>
                    <c:if test="${i.statut.toString() != statutEnCours}">
                        <span class="text-muted">Aucune</span>
                    </c:if>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty inscriptions}">
            <tr>
                <td colspan="6" class="text-center text-muted">Aucune inscription trouvée.</td>
            </tr>
        </c:if>
        </tbody>
    </table>

    <div class="mt-4">
        <p class="small text-muted text-end">Module : Sécurité + Workflow | Responsable : Toi</p>
    </div>
</div>

</body>
</html>
