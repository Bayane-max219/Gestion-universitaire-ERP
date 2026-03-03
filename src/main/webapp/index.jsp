<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ERP Universitaire - Accueil</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css">
    <style>
        body {
            background: linear-gradient(rgba(255, 255, 255, 0.7), rgba(255, 255, 255, 0.7)), url('resources/images/background.jpg') no-repeat center center fixed;
            background-size: cover;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            backdrop-filter: blur(1px);
        }
        .hero-content {
            text-align: center;
            max-width: 800px;
            margin: 0 auto;
            padding: 2rem;
            animation: fadeInUp 1s ease-out;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            backdrop-filter: blur(5px);
        }
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        /* Styles supprimés car intégrés dans .hero-content */
        .hero-icon {
            font-size: 4rem;
            color: #667eea;
            margin-bottom: 1rem;
        }
        .btn-hero {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        .btn-hero:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
        }
        .stats-section {
            background: rgba(102, 126, 234, 0.05);
            border-radius: 15px;
            padding: 1.5rem;
            margin-top: 2rem;
        }
        .stat-item {
            text-align: center;
            padding: 1rem;
        }
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            color: #667eea;
        }
        .auto-redirect {
            margin-top: 1.5rem;
            color: #6c757d;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="hero-content">
            <div class="hero-icon">
                <i class="bi bi-mortarboard-fill"></i>
            </div>
            <h1 class="display-4 fw-bold text-primary mb-3">Mada U</h1>
            <p class="lead text-muted mb-4">
                Madagascar University<br>
                <small class="text-secondary">Plateforme de gestion académique dédiée à l'excellence éducative</small>
            </p>
                
            <div class="stats-section">
                <div class="row text-center">
                    <div class="col-md-3 col-6 stat-item">
                        <div class="stat-number">1000+</div>
                        <div class="text-muted small">Étudiants</div>
                    </div>
                    <div class="col-md-3 col-6 stat-item">
                        <div class="stat-number">50+</div>
                        <div class="text-muted small">Matières</div>
                    </div>
                    <div class="col-md-3 col-6 stat-item">
                        <div class="stat-number">24/7</div>
                        <div class="text-muted small">Accès</div>
                    </div>
                    <div class="col-md-3 col-6 stat-item">
                        <div class="stat-number">99%</div>
                        <div class="text-muted small">Fiabilité</div>
                    </div>
                </div>
            </div>
                
            <div class="mt-4">
                <a href="login" class="btn btn-hero text-white btn-lg">
                    <i class="bi bi-box-arrow-in-right me-2"></i>
                    Accéder au Système
                </a>
            </div>
                
            <div class="auto-redirect">
                <small>Redirection automatique dans <span id="countdown">8</span> secondes...</small>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Compteur de redirection augmenté à 8 secondes
        let countdown = 8;
        const countdownElement = document.getElementById('countdown');
        
        const timer = setInterval(() => {
            countdown--;
            countdownElement.textContent = countdown;
            
            if (countdown <= 0) {
                clearInterval(timer);
                window.location.href = 'login';
            }
        }, 1000);
        
        // Animation supplémentaire
        document.addEventListener('DOMContentLoaded', function() {
            const heroCard = document.querySelector('.hero-card');
            heroCard.style.opacity = '0';
            heroCard.style.transform = 'translateY(20px)';
            
            setTimeout(() => {
                heroCard.style.transition = 'opacity 0.8s ease, transform 0.8s ease';
                heroCard.style.opacity = '1';
                heroCard.style.transform = 'translateY(0)';
            }, 100);
        });
    </script>
</body>
</html>