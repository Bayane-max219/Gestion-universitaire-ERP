<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>
        <c:choose>
            <c:when test="${etudiant != null}">Modifier Étudiant</c:when>
            <c:otherwise>Nouvel Étudiant</c:otherwise>
        </c:choose>
        - ERP Universitaire
    </title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(rgba(248, 249, 250, 0.95), rgba(248, 249, 250, 0.95)), url('../../resources/images/background.jpg') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            padding-top: 20px;
            backdrop-filter: blur(3px);
        }
        .form-card {
            background: white; /* Fond blanc pur pour la carte */
            backdrop-filter: blur(10px);
            border-radius: 15px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.05);
            overflow: hidden;
            transition: transform 0.3s ease;
        }
        .form-card:hover {
            transform: translateY(-5px);
        }
        .form-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
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
    </style>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8 col-md-10">
                <div class="card form-card">
                    <div class="form-header">
                        <i class="bi bi-person-plus fs-1 mb-3"></i>
                        <h3 class="mb-1">
                            <c:choose>
                                <c:when test="${etudiant != null}">
                                    <i class="bi bi-pencil-square me-2"></i>Modifier Étudiant
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-plus-circle me-2"></i>Nouvel Étudiant
                                </c:otherwise>
                            </c:choose>
                        </h3>
                        <p class="mb-0 opacity-75">
                            <c:choose>
                                <c:when test="${etudiant != null}">
                                    Modification des informations de l'étudiant
                                </c:when>
                                <c:otherwise>
                                    Ajout d'un nouvel étudiant au système
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

                        <form action="etudiants" method="post">
                            <c:if test="${etudiant != null}">
                                <input type="hidden" name="id" value="${etudiant.id}">
                            </c:if>

                            <div class="row">
                                <div class="col-md-6 mb-4 icon-input">
                                    <i class="bi bi-person"></i>
                                    <input type="text" name="nom" class="form-control form-control-lg" 
                                           placeholder="Nom" 
                                           value="${etudiant != null ? etudiant.nom : ''}" 
                                           required>
                                </div>
                                <div class="col-md-6 mb-4 icon-input">
                                    <i class="bi bi-person-vcard"></i>
                                    <input type="text" name="prenom" class="form-control form-control-lg" 
                                           placeholder="Prénom" 
                                           value="${etudiant != null ? etudiant.prenom : ''}" 
                                           required>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-4 icon-input">
                                    <i class="bi bi-envelope"></i>
                                    <input type="email" name="email" class="form-control form-control-lg" 
                                           placeholder="Email" 
                                           value="${etudiant != null ? etudiant.email : ''}" 
                                           required>
                                </div>
                                <div class="col-md-6 mb-4">
                                    <label class="form-label">Niveau</label>
                                    <select name="niveau" class="form-select form-control-lg" required>
                                        <option value="">Sélectionner le niveau</option>
                                        <option value="L1" ${etudiant != null && etudiant.niveau == 'L1' ? 'selected' : ''}>Licence 1</option>
                                        <option value="L2" ${etudiant != null && etudiant.niveau == 'L2' ? 'selected' : ''}>Licence 2</option>
                                        <option value="L3" ${etudiant != null && etudiant.niveau == 'L3' ? 'selected' : ''}>Licence 3</option>
                                        <option value="M1" ${etudiant != null && etudiant.niveau == 'M1' ? 'selected' : ''}>Master 1</option>
                                        <option value="M2" ${etudiant != null && etudiant.niveau == 'M2' ? 'selected' : ''}>Master 2</option>
                                    </select>
                                </div>
                            </div>
                            
                            <div class="row">
                                <div class="col-md-6 mb-4">
                                    <label class="form-label">Filière</label>
                                    <select name="filiereId" class="form-select form-control-lg" required>
                                        <option value="">Sélectionner la filière</option>
                                        <!-- Options à remplir dynamiquement -->
                                        <option value="1">Informatique</option>
                                        <option value="2">Économie</option>
                                        <option value="3">Droit</option>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-4 icon-input">
                                    <i class="bi bi-person-vcard"></i>
                                    <input type="text" name="numeroEtudiant" class="form-control form-control-lg" 
                                           placeholder="Numéro Étudiant (auto-généré)" 
                                           value="${etudiant != null ? etudiant.numeroEtudiant : ''}" 
                                           readonly>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6 mb-4 icon-input">
                                    <i class="bi bi-telephone"></i>
                                    <input type="tel" name="telephone" class="form-control form-control-lg" 
                                           placeholder="Téléphone" 
                                           value="${etudiant != null ? etudiant.telephone : ''}">
                                </div>
                                <div class="col-md-6 mb-4 icon-input">
                                    <i class="bi bi-telephone-plus"></i>
                                    <input type="tel" name="telephoneParent" class="form-control form-control-lg" 
                                           placeholder="Téléphone Parent" 
                                           value="${etudiant != null ? etudiant.telephoneParent : ''}">
                                </div>
                            </div>

                            <div class="mb-4 icon-input">
                                <i class="bi bi-house-door"></i>
                                <textarea name="adresse" class="form-control form-control-lg" 
                                          placeholder="Adresse" 
                                          rows="3">${etudiant != null ? etudiant.adresse : ''}</textarea>
                            </div>

                            <hr class="section-divider">

                            <div class="d-flex justify-content-between align-items-center">
                                <a href="etudiants" class="btn btn-outline-secondary">
                                    <i class="bi bi-arrow-return-left me-1"></i>Annuler
                                </a>
                                <button type="submit" class="btn btn-submit text-white btn-lg px-4">
                                    <i class="bi bi-save me-2"></i>
                                    <c:choose>
                                        <c:when test="${etudiant != null}">Mettre à jour</c:when>
                                        <c:otherwise>Ajouter Étudiant</c:otherwise>
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
</body>
</html>