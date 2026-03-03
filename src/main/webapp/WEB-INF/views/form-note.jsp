<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${note != null}">Modifier Note</c:when>
            <c:otherwise>Nouvelle Note</c:otherwise>
        </c:choose>
        - ERP Universitaire
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding-top: 20px;
        }
        .form-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        .form-card:hover {
            transform: translateY(-5px);
        }
        .form-header {
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        .form-control {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.25rem rgba(102, 126, 234, 0.25);
        }
        .btn-submit {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 10px;
            padding: 12px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }
        .input-group-text {
            background: #f8f9fa;
            border-right: none;
        }
        .icon-input {
            position: relative;
        }
        .icon-input i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
        }
        .icon-input input, .icon-input select, .icon-input textarea {
            padding-left: 45px;
        }
        .section-divider {
            border-top: 2px dashed #dee2e6;
            margin: 2rem 0;
        }
        .inscription-item {
            background-color: #f8f9fa;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 5px;
        }
        .inscription-item.selected {
            background-color: #e7f3ff;
            border: 1px solid #4361ee;
        }
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10">
                <div class="card form-card">
                    <div class="form-header">
                        <i class="bi bi-pen fs-1 mb-3"></i>
                        <h3 class="mb-1">
                            <c:choose>
                                <c:when test="${note != null}">
                                    <i class="bi bi-pencil-square me-2"></i>Modifier Note
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-plus-circle me-2"></i>Nouvelle Note
                                </c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="mb-0 opacity-75">
                            <c:choose>
                                <c:when test="${note != null}">
                                    Modification de la note
                                </c:when>
                                <c:otherwise>
                                    Saisie d'une nouvelle note
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                    
                    <div class="card-body p-4">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>

                        <form action="notes" method="post">
                            <c:if test="${note != null}">
                                <input type="hidden" name="id" value="${note.id}">
                            </c:if>

                            <div class="mb-4">
                                <label class="form-label">
                                    <i class="bi bi-journal-bookmark me-1"></i>Sélectionnez l'inscription
                                </label>
                                <div class="row">
                                    <c:forEach var="inscription" items="${inscriptions}">
                                        <div class="col-md-12 mb-2">
                                            <div class="inscription-item 
                                                <c:if test='${note != null && note.inscription.id == inscription.id}'>selected</c:if>"
                                                 onclick="selectInscription(${inscription.id})">
                                                <div class="d-flex justify-content-between align-items-center">
                                                    <div>
                                                        <strong>${inscription.etudiant.nom} ${inscription.etudiant.prenom}</strong><br>
                                                        <small class="text-muted">${inscription.matiere.nom} - ${inscription.dateInscription}</small>
                                                    </div>
                                                    <div>
                                                        <input type="radio" name="inscriptionId" value="${inscription.id}" 
                                                               id="inscription_${inscription.id}"
                                                               <c:if test='${note != null && note.inscription.id == inscription.id}'>checked</c:if>
                                                               required>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-4 icon-input">
                                    <i class="bi bi-123"></i>
                                    <input type="number" step="0.01" min="0" max="20" name="valeur" class="form-control form-control-lg" 
                                           placeholder="Note (sur 20)" 
                                           value="${note != null ? note.valeur : ''}" 
                                           required>
                                </div>
                                <div class="col-md-6 mb-4 icon-input">
                                    <i class="bi bi-tag"></i>
                                    <input type="text" name="typeEvaluation" class="form-control form-control-lg" 
                                           placeholder="Type d'évaluation (ex: DS, Examen, TP)" 
                                           value="${note != null ? note.typeEvaluation : ''}">
                                </div>
                            </div>

                            <hr class="section-divider">

                            <div class="d-flex justify-content-between align-items-center">
                                <a href="notes" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-return-left me-1"></i>Annuler
                                </a>
                                <button type="submit" class="btn btn-submit text-white btn-lg px-4">
                                    <i class="bi bi-save me-2"></i>
                                    <c:choose>
                                        <c:when test="${note != null}">Mettre à jour</c:when>
                                        <c:otherwise>Ajouter Note</c:otherwise>
                                    </c:choose>
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function selectInscription(id) {
            const radios = document.querySelectorAll('input[name="inscriptionId"]');
            radios.forEach(radio => {
                radio.checked = false;
                const item = radio.closest('.inscription-item');
                if (item) {
                    item.classList.remove('selected');
                }
            });
            
            const selectedRadio = document.getElementById('inscription_' + id);
            if (selectedRadio) {
                selectedRadio.checked = true;
                const selectedItem = selectedRadio.closest('.inscription-item');
                if (selectedItem) {
                    selectedItem.classList.add('selected');
                }
            }
        }
    </script>
</body>
</html>