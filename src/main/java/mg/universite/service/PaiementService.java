package mg.universite.service;

import mg.universite.dao.InscriptionDAO;
import mg.universite.dao.NotificationDAO;
import mg.universite.dao.TranchePaiementDAO;
import mg.universite.model.Inscription;
import mg.universite.model.Notification;
import mg.universite.model.StatutTranche;
import mg.universite.model.TranchePaiement;

import java.math.BigDecimal;
import java.time.LocalDate;

public class PaiementService {

    private final TranchePaiementDAO tranchePaiementDAO;
    private final InscriptionDAO inscriptionDAO;
    private final NotificationDAO notificationDAO;

    public PaiementService() {
        this.tranchePaiementDAO = new TranchePaiementDAO();
        this.inscriptionDAO = new InscriptionDAO();
        this.notificationDAO = new NotificationDAO();
    }

    public TranchePaiement creerTranchePourInscription(Long inscriptionId, BigDecimal montant, LocalDate dateEcheance, String reference) {
        Inscription ins = inscriptionDAO.findById(inscriptionId);
        if (ins == null) {
            throw new IllegalArgumentException("Inscription introuvable");
        }
        TranchePaiement t = new TranchePaiement(ins, montant, dateEcheance, StatutTranche.A_PAYER, reference);
        tranchePaiementDAO.save(t);
        return t;
    }

    public void validerPaiement(Long trancheId) {
        tranchePaiementDAO.validerPaiement(trancheId);
    }

    public boolean inscriptionEstPayee(Long inscriptionId) {
        return !tranchePaiementDAO.hasAnyNonPayeeForInscription(inscriptionId);
    }

    public boolean etudiantEstEnRegle(Long etudiantId) {
        return !tranchePaiementDAO.hasAnyNonPayeeForEtudiant(etudiantId);
    }

    public void exigerPaiementPourValidation(Long inscriptionId) {
        if (!inscriptionEstPayee(inscriptionId)) {
            Inscription ins = inscriptionDAO.findById(inscriptionId);
            if (ins != null) {
                notificationDAO.save(new Notification(ins, "Paiement en attente: inscription non validable tant que la tranche n'est pas PAYEE."));
            }
            throw new IllegalStateException("Paiement non validé: impossible de valider l'inscription");
        }
    }
}
