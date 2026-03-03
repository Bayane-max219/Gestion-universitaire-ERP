package mg.universite.service;

import mg.universite.dao.AdminInscriptionDAO;
import mg.universite.model.StatutInscription;
import mg.universite.service.PaiementService;

public class WorkflowService {

    private final AdminInscriptionDAO adminInscriptionDAO;
    private final PaiementService paiementService;

    public WorkflowService() {
        this.adminInscriptionDAO = new AdminInscriptionDAO();
        this.paiementService = new PaiementService();
    }

    public void validerInscription(Long inscriptionId) {
        paiementService.exigerPaiementPourValidation(inscriptionId);
        adminInscriptionDAO.updateStatut(inscriptionId, StatutInscription.VALIDEE);
    }

    public void annulerInscription(Long inscriptionId) {
        adminInscriptionDAO.updateStatut(inscriptionId, StatutInscription.ANNULEE);
    }
}
