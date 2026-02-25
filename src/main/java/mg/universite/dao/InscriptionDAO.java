package mg.universite.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import mg.universite.model.Etudiant;
import mg.universite.model.Inscription;
import mg.universite.model.Matiere;
import mg.universite.model.StatutInscription;
// L'import automatique devrait fonctionner maintenant


public class InscriptionDAO {

    public void save(Long etudiantId, Long matiereId) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();

            Etudiant e = em.find(Etudiant.class, etudiantId);
            Matiere m = em.find(Matiere.class, matiereId);

            if (e != null && m != null) {
                Inscription ins = new Inscription();
                ins.setEtudiant(e);
                ins.setMatiere(m);
                ins.setDateInscription(java.time.LocalDate.now());

                // Ici, StatutInscription est maintenant reconnu
                ins.setStatut(StatutInscription.EN_COURS);

                em.persist(ins);
            }

            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            ex.printStackTrace();
        } finally {
            em.close();
        }
    }
}