package mg.universite.service;

import mg.universite.dao.TranchePaiementDAO;
import mg.universite.model.TranchePaiement;
import java.time.LocalDate;
import java.util.List;

public class NotificationService {
    
    private final TranchePaiementDAO trancheDAO = new TranchePaiementDAO();
    
    public List<TranchePaiement> getTranchesAEcheance() {
        // Récupérer les tranches qui arrivent à échéance dans les 7 jours
        LocalDate dateLimite = LocalDate.now().plusDays(7);
        return trancheDAO.findByObligatoire(true); // Simplifié pour le moment
    }
    
    public void envoyerNotificationsRappel() {
        List<TranchePaiement> tranches = getTranchesAEcheance();
        for (TranchePaiement tranche : tranches) {
            if (tranche.getDateEcheance().isBefore(LocalDate.now().plusDays(3)) && 
                tranche.getDateEcheance().isAfter(LocalDate.now())) {
                // TODO: Envoyer notification email
                System.out.println("Notification de rappel pour la tranche: " + tranche.getLibelle());
            }
        }
    }
    
    public int getNombreNotificationsNonLues() {
        // Pour le moment, retourne un nombre simulé
        return 3; // À implémenter avec une vraie base de données
    }
}