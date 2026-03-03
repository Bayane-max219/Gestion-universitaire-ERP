package mg.universite.dao;

import jakarta.persistence.EntityManager;
import mg.universite.model.StatutTranche;
import mg.universite.model.TranchePaiement;

import java.time.LocalDate;
import java.util.List;

public class TranchePaiementDAO {

    public void save(TranchePaiement tranche) {
        EntityManager em = JPAUtil.getEntityManager();
        var tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(tranche);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public TranchePaiement findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(TranchePaiement.class, id);
        } finally {
            em.close();
        }
    }

    public List<TranchePaiement> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "select t from TranchePaiement t join fetch t.inscription i join fetch i.etudiant order by t.id desc",
                    TranchePaiement.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public List<TranchePaiement> findByInscriptionId(Long inscriptionId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "select t from TranchePaiement t join fetch t.inscription i join fetch i.etudiant where i.id = :id order by t.id desc",
                    TranchePaiement.class
            ).setParameter("id", inscriptionId).getResultList();
        } finally {
            em.close();
        }
    }

    public List<TranchePaiement> findByEtudiantId(Long etudiantId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "select t from TranchePaiement t join fetch t.inscription i join fetch i.etudiant e where e.id = :id order by t.id desc",
                    TranchePaiement.class
            ).setParameter("id", etudiantId).getResultList();
        } finally {
            em.close();
        }
    }

    public boolean hasAnyNonPayeeForInscription(Long inscriptionId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Long count = em.createQuery(
                            "select count(t) from TranchePaiement t where t.inscription.id = :id and t.statut <> :payee",
                            Long.class
                    )
                    .setParameter("id", inscriptionId)
                    .setParameter("payee", StatutTranche.PAYEE)
                    .getSingleResult();
            return count != null && count > 0;
        } finally {
            em.close();
        }
    }

    public boolean hasAnyNonPayeeForEtudiant(Long etudiantId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Long count = em.createQuery(
                            "select count(t) from TranchePaiement t where t.inscription.etudiant.id = :id and t.statut <> :payee",
                            Long.class
                    )
                    .setParameter("id", etudiantId)
                    .setParameter("payee", StatutTranche.PAYEE)
                    .getSingleResult();
            return count != null && count > 0;
        } finally {
            em.close();
        }
    }

    public void markEnRetardBefore(LocalDate date) {
        EntityManager em = JPAUtil.getEntityManager();
        var tx = em.getTransaction();
        try {
            tx.begin();
            em.createQuery(
                            "update TranchePaiement t set t.statut = :retard " +
                                    "where t.statut = :aPayer and t.dateEcheance is not null and t.dateEcheance < :d"
                    )
                    .setParameter("retard", StatutTranche.EN_RETARD)
                    .setParameter("aPayer", StatutTranche.A_PAYER)
                    .setParameter("d", date)
                    .executeUpdate();
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void validerPaiement(Long trancheId) {
        EntityManager em = JPAUtil.getEntityManager();
        var tx = em.getTransaction();
        try {
            tx.begin();
            TranchePaiement t = em.find(TranchePaiement.class, trancheId);
            if (t == null) {
                throw new IllegalArgumentException("Tranche introuvable");
            }
            t.setStatut(StatutTranche.PAYEE);
            t.setDatePaiement(LocalDate.now());
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}
