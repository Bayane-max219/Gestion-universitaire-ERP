package mg.universite.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import mg.universite.model.Etudiant;
import mg.universite.model.Inscription;
import mg.universite.model.Matiere;
import mg.universite.model.StatutInscription;
// L'import automatique devrait fonctionner maintenant

import java.util.List;

/**
 * 
 */
public class InscriptionDAO {

    public Inscription save(Long etudiantId, Long matiereId) {
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
                tx.commit();
                return ins;
            }

            tx.commit();
            return null;
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            ex.printStackTrace();
            return null;
        } finally {
            em.close();
        }
    }

    public List<Inscription> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT i FROM Inscription i", Inscription.class).getResultList();
        } finally {
            em.close();
        }
    }

    public Inscription findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Inscription.class, id);
        } finally {
            em.close();
        }
    }

    public Inscription findByEtudiantIdAndMatiereId(Long etudiantId, Long matiereId) {
        if (etudiantId == null || matiereId == null) {
            return null;
        }
        EntityManager em = JPAUtil.getEntityManager();
        try {
            var res = em.createQuery(
                            "select i from Inscription i " +
                                    "join fetch i.etudiant " +
                                    "join fetch i.matiere " +
                                    "where i.etudiant.id = :etudiantId and i.matiere.id = :matiereId",
                            Inscription.class
                    )
                    .setParameter("etudiantId", etudiantId)
                    .setParameter("matiereId", matiereId)
                    .setMaxResults(1)
                    .getResultList();
            return res.isEmpty() ? null : res.get(0);
        } finally {
            em.close();
        }
    }
}