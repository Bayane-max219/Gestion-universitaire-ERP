# Gestion-universitaire-ERP
Mini-système ERP pour gestion universitaire en JEE/JPA/JSF

## Démarrage rapide (Docker)

### Prérequis

- Docker Desktop (avec Docker Compose)

### Lancer l'application

```bash
docker compose up --build
```

### Accès

- Application : http://localhost:8080/university-erp/
- Login : http://localhost:8080/university-erp/login

### Base de données

- MySQL exposé sur le port `3307` (sur la machine hôte)
- DB : `gestion_universitaire_db`
- User : `root`
- Password : `root`

Le script d'initialisation est dans : `Base_de_données/gestion_universitaire_db.sql`.

## Screenshots

![01 - Login](screenshoots/01-Login.png)
![02 - Dashboard Admin](screenshoots/02-Dashboard_admin.png)
![03 - CRUD Étudiant](screenshoots/03-Crud_Etudiant.png)
![04 - CRUD Matière](screenshoots/04-Crud_Matiere.png)
![05 - CRUD Prof](screenshoots/05-Crud_Prof.png)
![06 - Notes](screenshoots/06-Notes.png)
![07 - Matière (vue étudiant)](screenshoots/07-Matiere_vue_etudiant.png)
![08 - Notifications](screenshoots/08-Notification.png)
![09 - Docker](screenshoots/09-Docker.png)
![10 - Email](screenshoots/10-Email.png)
