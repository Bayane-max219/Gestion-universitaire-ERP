<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login - ERP Universitaire</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">

<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card shadow">
                <div class="card-header bg-dark text-white">
                    <h4 class="mb-0">Connexion</h4>
                </div>
                <div class="card-body">

                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <input type="text" name="username" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input type="password" name="password" class="form-control" required>
                        </div>
                        <div class="d-grid gap-2">
                            <button type="submit" class="btn btn-primary">Se connecter</button>
                        </div>
                    </form>

                    <hr>
                    <p class="small text-muted mb-0">
                        Compte admin par défaut: <strong>admin / admin</strong>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
