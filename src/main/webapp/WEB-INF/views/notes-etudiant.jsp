<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Notes - Mada U</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .stats-container {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        .grade-high {
            background-color: #d4edda;
            color: #155724;
            font-weight: bold;
        }
        .grade-low {
            background-color: #f8d7da;
            color: #721c24;
            font-weight: bold;
        }
        .grade-medium {
            background-color: #fff3cd;
            color: #856404;
            font-weight: bold;
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
                        <i class="bi bi-mortarboard me-2"></i>Mes Notes
                    </h2>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-secondary">
                        <i class="bi bi-arrow-left me-1"></i>Retour
                    </a>
                </div>

                <div class="card shadow mb-4">
                    <div class="card-body">
                        <form class="row g-3" method="get" action="${pageContext.request.contextPath}/notes">
                            <div class="col-md-4">
                                <label class="form-label"><i class="bi bi-calendar2-week me-1"></i>Semestre</label>
                                <select class="form-select" name="semestre">
                                    <option value="S1" <c:if test="${selectedSemestre != null && selectedSemestre == 'S1'}">selected</c:if>>Semestre 1</option>
                                    <option value="S2" <c:if test="${selectedSemestre != null && selectedSemestre == 'S2'}">selected</c:if>>Semestre 2</option>
                                </select>
                            </div>
                            <div class="col-md-2 d-flex align-items-end">
                                <button class="btn btn-primary w-100" type="submit">
                                    <i class="bi bi-funnel me-1"></i>Filtrer
                                </button>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="stats-container">
                    <div class="row text-center">
                        <div class="col-md-4 col-6 mb-3">
                            <div class="bg-white bg-opacity-75 text-dark p-3 rounded">
                                <i class="bi bi-journal-album fs-2 d-block"></i>
                                <h4 class="mb-0">${notesCount}</h4>
                                <small>Notes</small>
                            </div>
                        </div>
                        <div class="col-md-4 col-6 mb-3">
                            <div class="bg-white bg-opacity-75 text-dark p-3 rounded">
                                <i class="bi bi-book-fill fs-2 d-block"></i>
                                <h4 class="mb-0">${matieresCount}</h4>
                                <small>Matières</small>
                            </div>
                        </div>
                        <div class="col-md-4 col-12 mb-3">
                            <div class="bg-white bg-opacity-75 text-dark p-3 rounded">
                                <i class="bi bi-calculator fs-2 d-block"></i>
                                <h4 class="mb-0">${totalCoefficients != null ? totalCoefficients : 0}</h4>
                                <small>Total Coeff</small>
                            </div>
                        </div>
                    </div>
                    <div class="row text-center">
                        <div class="col-md-6 col-6">
                            <div class="bg-white bg-opacity-75 text-dark p-3 rounded">
                                <i class="bi bi-sigma fs-2 d-block"></i>
                                <h4 class="mb-0">${totalPoints != null ? totalPoints : 0}</h4>
                                <small>Total Points</small>
                            </div>
                        </div>
                        <div class="col-md-6 col-6">
                            <div class="bg-white bg-opacity-75 text-dark p-3 rounded">
                                <i class="bi bi-graph-up fs-2 d-block"></i>
                                <h4 class="mb-0">${moyenne}</h4>
                                <small>Moyenne</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card shadow">
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover table-striped">
                                <thead class="table-dark">
                                    <tr>
                                        <th>Matière</th>
                                        <th>Coefficient</th>
                                        <th>Semestre</th>
                                        <th>Note</th>
                                        <th>Type</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="note" items="${notes}">
                                        <tr>
                                            <td><strong>${note.matiere.nom}</strong></td>
                                            <td><span class="badge bg-info">${note.matiere.coefficient}</span></td>
                                            <td><span class="badge bg-secondary">${note.semestre}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${note.valeur >= 16}">
                                                        <span class="badge grade-high">${note.valeur}</span>
                                                    </c:when>
                                                    <c:when test="${note.valeur >= 10}">
                                                        <span class="badge grade-medium">${note.valeur}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge grade-low">${note.valeur}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${note.typeEvaluation != null}">
                                                        <span class="badge bg-success">${note.typeEvaluation}</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">N/A</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>

                                    <c:if test="${empty notes}">
                                        <tr>
                                            <td colspan="5" class="text-center text-muted py-4">
                                                <i class="bi bi-pen fs-1 d-block mb-2"></i>
                                                Aucune note pour ce semestre
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
