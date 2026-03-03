package mg.universite.service;

import mg.universite.dao.UserDAO;
import mg.universite.model.User;
import mg.universite.model.Role;

public class AuthService {
    
    private final UserDAO userDAO = new UserDAO();
    private final EtudiantService etudiantService = new EtudiantService();
    
    public void bootstrapIfNeeded() {
        // Vérifier si l'admin existe déjà
        User admin = userDAO.findByUsername("admin");
        if (admin == null) {
            // Créer l'utilisateur admin par défaut
            Role adminRole = new Role();
            adminRole.setId(1L); // Supposant que le rôle ADMIN a l'ID 1
            
            admin = new User();
            admin.setUsername("admin");
            admin.setPasswordHash(PasswordUtil.sha256("admin"));
            admin.setRole(adminRole);
            
            userDAO.save(admin);
        }
    }
    
    public User authenticate(String email, String password) {
        // Vérifier d'abord si c'est un utilisateur admin
        User user = userDAO.findByUsername(email);
        if (user != null && PasswordUtil.sha256(password).equals(user.getPasswordHash())) {
            return user;
        }
        
        // Vérifier si c'est un étudiant
        var etudiant = etudiantService.findByEmail(email);
        if (etudiant != null && PasswordUtil.sha256(password).equals(etudiant.getMotDePasse())) {
            // Créer un utilisateur temporaire pour la session
            User etudiantUser = new User();
            etudiantUser.setUsername(etudiant.getEmail());
            etudiantUser.setPasswordHash(etudiant.getMotDePasse());
            // Assigner un rôle étudiant (à définir dans la base)
            Role etudiantRole = new Role();
            etudiantRole.setId(2L); // Supposant que le rôle ÉTUDIANT a l'ID 2
            etudiantUser.setRole(etudiantRole);
            return etudiantUser;
        }
        
        return null;
    }
    
    public boolean isAdmin(User user) {
        return user != null && user.getRole() != null && user.getRole().getId() == 1L;
    }
}