<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Matières - ERP Universitaire</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .container { background: white; padding: 20px; border-radius: 10px; box-shadow: 0px 0px 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body class="py-5">
<%@ include file="navbar.jsp" %>

<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-primary">Liste des Matières</h2>
        <a href="matieres?action=new" class="btn btn-primary">
            <i class="bi bi-plus-circle"></i> Ajouter une matière
        </a>
    </div>

    <hr>

    <table class="table table-hover table-bordered">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Nom</th>
            <th>Coefficient</th>
            <th class="text-center">Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="m" items="${matieres}">
            <tr>
                <td>${m.id}</td>
                <td>${m.nom}</td>
                <td>${m.coefficient}</td>
                <td class="text-center">
                    <a href="matieres?action=edit&id=${m.id}" class="btn btn-sm btn-warning">Modifier</a>

                    <a href="matieres?action=delete&id=${m.id}"
                       class="btn btn-sm btn-danger"
                       onclick="return confirm('Voulez-vous vraiment supprimer cette matière ?')">
                        Supprimer
                    </a>
                </td>
            </tr>
        </c:forEach>

        <c:if test="${empty matieres}">
            <tr>
                <td colspan="5" class="text-center text-muted">Aucune matière trouvé dans la base.</td>
            </tr>
        </c:if>
        </tbody>
    </table>

    <div class="mt-4">
        <p class="small text-muted text-end">Module : Gestion Académique | Responsable : Binôme CRUD</p>
    </div>
</div>

</body>
</html>