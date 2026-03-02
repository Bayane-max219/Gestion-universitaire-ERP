<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Relevé de Notes - ERP Universitaire</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .container-box { background: white; padding: 20px; border-radius: 10px; box-shadow: 0px 0px 10px rgba(0,0,0,0.1); }
        .header-section { border-bottom: 2px solid #dee2e6; padding-bottom: 15px; margin-bottom: 20px; }
        .note-cell { font-weight: bold; color: #495057; }
        .moyenne-cell { font-size: 1.2em; background-color: #e9ecef; }
    </style>
</head>
<body class="py-0">

<%@ include file="navbar.jsp" %>

<div class="container mt-4 container-box">
    <div class="header-section text-center">
        <h2 class="text-primary">Relevé de Notes</h2>
        <h4 class="text-muted">Étudiant: ${etudiant.nom} ${etudiant.prenom}</h4>
        <p>Période: Année académique 2023-2024</p>
    </div>

    <div class="row mb-4">
        <div class="col-md-6">
            <h5>Détail des notes</h5>
            <table class="table table-sm table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Matière</th>
                        <th>Type</th>
                        <th>Note</th>
                    </tr>
                </thead>
                <tbody>
                    <c:choose>
                        <c:when test="${!empty notes}">
                            <c:forEach var="note" items="${notes}">
                                <tr>
                                    <td>${note.matiere.nom}</td>
                                    <td>${note.typeEvaluation}</td>
                                    <td class="note-cell">${note.valeur}</td>
                                </tr>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <tr>
                                <td colspan="3" class="text-center text-muted">Aucune note enregistrée</td>
                            </tr>
                        </c:otherwise>
                    </c:choose>
                </tbody>
            </table>
        </div>
        <div class="col-md-6">
            <h5>Moyennes par matière</h5>
            <table class="table table-sm table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Matière</th>
                        <th>Coefficient</th>
                        <th>Moyenne</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- Moyennes calculées par matière -->
                    <tr>
                        <td>Mathématiques</td>
                        <td>4</td>
                        <td class="note-cell">-</td>
                    </tr>
                    <tr>
                        <td>Informatique</td>
                        <td>4</td>
                        <td class="note-cell">-</td>
                    </tr>
                </tbody>
            </table>
            <div class="card bg-light mt-3">
                <div class="card-body text-center">
                    <h5 class="card-title">Moyenne Générale</h5>
                    <h3 class="text-primary moyenne-cell">-</h3>
                    <p class="card-text"><span class="badge bg-warning">En cours de calcul</span></p>
                </div>
            </div>
        </div>
    </div>

    <div class="text-end mt-4">
        <button class="btn btn-success" onclick="window.print()">
            <i class="bi bi-printer"></i> Imprimer
        </button>
        <a href="notes" class="btn btn-secondary">Retour</a>
    </div>
</div>

</body>
</html>