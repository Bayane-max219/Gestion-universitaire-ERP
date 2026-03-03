package mg.universite.service;

import mg.universite.dao.EtudiantDAO;
import mg.universite.dao.FiliereDAO;
import mg.universite.dao.ProgrammeDAO;
import mg.universite.dao.TranchePaiementDAO;
import mg.universite.model.*;
import java.time.LocalDate;
import java.util.List;

public class EtudiantService {
    
    private final EtudiantDAO etudiantDAO = new EtudiantDAO();
    private final FiliereDAO filiereDAO = new FiliereDAO();
    private final ProgrammeDAO programmeDAO = new ProgrammeDAO();
    
    public void createEtudiant(Etudiant etudiant) {
        // Générer le numéro étudiant
        String numeroEtudiant = etudiantDAO.generateNumeroEtudiant(etudiant.getNiveau());
        etudiant.setNumeroEtudiant(numeroEtudiant);
        
        // Générer un mot de passe temporaire
        String motDePasseTemp = generateTemporaryPassword();
        etudiant.setMotDePasse(PasswordUtil.sha256(motDePasseTemp));
        etudiant.setPremierConnexion(true);
        
        // Sauvegarder l'étudiant
        etudiantDAO.save(etudiant);
        
        // TODO: Envoyer email avec mot de passe temporaire
        System.out.println("Email à envoyer à " + etudiant.getEmail() + " : Votre mot de passe temporaire est : " + motDePasseTemp);
    }
    
    public Etudiant findByEmail(String email) {
        return etudiantDAO.findByEmail(email);
    }
    
    public List<Filiere> getAllFilieres() {
        return filiereDAO.findAll();
    }
    
    public List<Programme> getProgrammesByFiliere(Filiere filiere) {
        return programmeDAO.findByFiliere(filiere);
    }
    
    public List<Programme> getProgrammesByNiveauAndFiliere(Niveau niveau, Filiere filiere) {
        return programmeDAO.findByNiveauAndFiliere(niveau, filiere);
    }
    
    private String generateTemporaryPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        java.util.Random random = new java.util.Random();
        for (int i = 0; i < 8; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }
}