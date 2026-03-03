package mg.universite.service;

import mg.universite.dao.AdminInscriptionDAO;
import mg.universite.model.StatutInscription;

public class WorkflowService {

    private final AdminInscriptionDAO adminInscriptionDAO;

    public WorkflowService() {
        this.adminInscriptionDAO = new AdminInscriptionDAO();
    }

    public void validerInscription(Long inscriptionId) {
        adminInscriptionDAO.updateStatut(inscriptionId, StatutInscription.VALIDEE);
    }

    public void annulerInscription(Long inscriptionId) {
        adminInscriptionDAO.updateStatut(inscriptionId, StatutInscription.ANNULEE);
    }
}
