package mg.universite.service;

import mg.universite.dao.EtudiantDAO;
import mg.universite.dao.FiliereDAO;
import mg.universite.dao.ProgrammeDAO;
import mg.universite.model.*;

import java.time.LocalDateTime;
import java.util.List;

public class EtudiantService {

    private final EtudiantDAO etudiantDAO = new EtudiantDAO();
    private final FiliereDAO filiereDAO = new FiliereDAO();
    private final ProgrammeDAO programmeDAO = new ProgrammeDAO();
    private final EmailService emailService = new EmailService();

    public String createEtudiant(Etudiant etudiant, String loginUrl) {
        if (etudiant == null) {
            throw new IllegalArgumentException("Etudiant requis");
        }
        if (etudiant.getEmail() == null || etudiant.getEmail().isBlank()) {
            throw new IllegalArgumentException("Email requis");
        }
        if (etudiant.getNiveau() == null) {
            throw new IllegalArgumentException("Niveau requis");
        }
        if (etudiant.getFiliere() == null || etudiant.getFiliere().getId() == null) {
            throw new IllegalArgumentException("Filière requise");
        }

        Filiere filiere = filiereDAO.findById(etudiant.getFiliere().getId());
        if (filiere == null) {
            throw new IllegalArgumentException("Filière introuvable");
        }
        etudiant.setFiliere(filiere);

        if (etudiant.getDateCreation() == null) {
            etudiant.setDateCreation(LocalDateTime.now());
        }

        String numeroEtudiant = etudiantDAO.generateNumeroEtudiant(etudiant.getNiveau());
        etudiant.setNumeroEtudiant(numeroEtudiant);

        String motDePasseTemp = generateTemporaryPassword();
        etudiant.setMotDePasse(PasswordUtil.sha256(motDePasseTemp));
        etudiant.setPremierConnexion(true);

        etudiantDAO.save(etudiant);

        try {
            emailService.sendStudentCredentials(etudiant.getEmail(), numeroEtudiant, motDePasseTemp, loginUrl);
            return null;
        } catch (Exception e) {
            return "Étudiant créé, mais email non envoyé: " + e.getMessage();
        }
    }

    public void updateEtudiant(Long id, Etudiant data) {
        if (id == null) {
            throw new IllegalArgumentException("ID requis");
        }
        Etudiant existing = etudiantDAO.findById(id);
        if (existing == null) {
            throw new IllegalArgumentException("Étudiant introuvable");
        }

        existing.setNom(data.getNom());
        existing.setPrenom(data.getPrenom());
        existing.setEmail(data.getEmail());
        existing.setTelephone(data.getTelephone());
        existing.setAdresse(data.getAdresse());
        existing.setTelephoneParent(data.getTelephoneParent());
        existing.setNiveau(data.getNiveau());

        if (data.getFiliere() == null || data.getFiliere().getId() == null) {
            throw new IllegalArgumentException("Filière requise");
        }
        Filiere filiere = filiereDAO.findById(data.getFiliere().getId());
        if (filiere == null) {
            throw new IllegalArgumentException("Filière introuvable");
        }
        existing.setFiliere(filiere);

        etudiantDAO.update(existing);
    }

    public void delete(Long id) {
        if (id == null) {
            throw new IllegalArgumentException("ID requis");
        }
        etudiantDAO.delete(id);
    }

    public Etudiant findById(Long id) {
        if (id == null) {
            return null;
        }
        return etudiantDAO.findById(id);
    }

    public Etudiant findByEmail(String email) {
        return etudiantDAO.findByEmail(email);
    }

    public List<Etudiant> findAll() {
        return etudiantDAO.findAll();
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
