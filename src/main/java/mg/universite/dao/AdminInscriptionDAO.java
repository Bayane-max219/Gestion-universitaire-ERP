package mg.universite.dao;

import jakarta.persistence.EntityManager;
import mg.universite.model.Inscription;
import mg.universite.model.StatutInscription;

import java.util.List;

public class AdminInscriptionDAO {

    public List<Inscription> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "select i from Inscription i " +
                                    "join fetch i.etudiant " +
                                    "join fetch i.matiere " +
                                    "order by i.id desc",
                            Inscription.class)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public void updateStatut(Long inscriptionId, StatutInscription statut) {
        EntityManager em = JPAUtil.getEntityManager();
        var tx = em.getTransaction();
        try {
            tx.begin();
            Inscription i = em.find(Inscription.class, inscriptionId);
            if (i == null) {
                throw new IllegalArgumentException("Inscription introuvable");
            }
            i.setStatut(statut);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}
