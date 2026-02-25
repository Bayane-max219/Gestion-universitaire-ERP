<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Ajouter une matière</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="container mt-5">
<div class="card shadow">
    <div class="card-header bg-primary text-white">
        <h3 class="card-title">Nouvelle Matière</h3>
    </div>
    <div class="card-body">
        <form action="matieres" method="post">
            <div class="mb-3">
                <label class="form-label">Nom</label>
                <input type="text" name="nom" class="form-control" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Coefficient</label>
                <input type="text" name="coefficient" class="form-control" required>
            </div>
            <div class="d-flex justify-content-between">
                <a href="matieres" class="btn btn-secondary">Annuler</a>
                <button type="submit" class="btn btn-success">Enregistrer</button>
            </div>
        </form>
    </div>
</div>
</body>
</html>