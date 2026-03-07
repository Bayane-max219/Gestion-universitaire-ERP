package mg.universite.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import mg.universite.model.Etudiant;
import mg.universite.model.Inscription;
import mg.universite.model.StatutTranche;
import mg.universite.model.TranchePaiement;

import java.time.LocalDate;
import java.time.YearMonth;
import java.util.List;

public class TranchePaiementDAO {

    public void save(TranchePaiement tranche) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(tranche);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public List<TranchePaiement> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "select distinct t from TranchePaiement t " +
                            "left join fetch t.etudiant e " +
                            "left join fetch t.inscription i " +
                            "left join fetch i.etudiant ie " +
                            "left join fetch i.matiere " +
                            "order by t.dateEcheance",
                    TranchePaiement.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public void createForInscription(Long inscriptionId, Double montant, LocalDate dateEcheance, String referencePaiement) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Inscription ins = em.find(Inscription.class, inscriptionId);
            if (ins == null) {
                throw new IllegalArgumentException("Inscription introuvable");
            }
            TranchePaiement t = new TranchePaiement();
            t.setInscription(ins);
            t.setLibelle("Tranche");
            t.setMontant(montant);
            t.setDateEcheance(dateEcheance);
            t.setObligatoire(false);
            t.setStatut(StatutTranche.A_PAYER);
            t.setReferencePaiement(referencePaiement);
            em.persist(t);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void createEcheancierForEtudiant(Long etudiantId, Double fraisAnnuel, Integer nombreTranches, Integer jourEcheance, YearMonth moisDepart) {
        if (etudiantId == null) {
            throw new IllegalArgumentException("Étudiant requis");
        }
        if (fraisAnnuel == null || fraisAnnuel <= 0) {
            throw new IllegalArgumentException("Frais annuel requis");
        }
        if (nombreTranches == null || nombreTranches <= 0) {
            throw new IllegalArgumentException("Nombre de tranches invalide");
        }

        int day = (jourEcheance == null) ? 5 : jourEcheance;
        if (day < 1 || day > 28) {
            throw new IllegalArgumentException("Jour d'échéance doit être entre 1 et 28");
        }

        YearMonth startYm = (moisDepart == null) ? YearMonth.now() : moisDepart;
        double montantParTranche = fraisAnnuel / nombreTranches;

        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Etudiant e = em.find(Etudiant.class, etudiantId);
            if (e == null) {
                throw new IllegalArgumentException("Étudiant introuvable");
            }
            for (int k = 0; k < nombreTranches; k++) {
                YearMonth ym = startYm.plusMonths(k);
                LocalDate echeance = ym.atDay(1).withDayOfMonth(day);
                TranchePaiement t = new TranchePaiement();
                t.setEtudiant(e);
                t.setLibelle("Écolage");
                t.setMontant(montantParTranche);
                t.setDateEcheance(echeance);
                t.setObligatoire(true);
                t.setStatut(StatutTranche.A_PAYER);
                em.persist(t);
            }
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw ex;
        } finally {
            em.close();
        }
    }

    public void markRetards(LocalDate today) {
        LocalDate d = (today == null) ? LocalDate.now() : today;
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.createQuery(
                            "update TranchePaiement t set t.statut = :retard " +
                                    "where (t.statut = :aPayer) and t.dateEcheance < :today")
                    .setParameter("retard", StatutTranche.EN_RETARD)
                    .setParameter("aPayer", StatutTranche.A_PAYER)
                    .setParameter("today", d)
                    .executeUpdate();
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw ex;
        } finally {
            em.close();
        }
    }

    public void markPayee(Long trancheId, String referencePaiement, LocalDate datePaiement) {
        if (trancheId == null) {
            throw new IllegalArgumentException("ID tranche requis");
        }
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            TranchePaiement t = em.find(TranchePaiement.class, trancheId);
            if (t == null) {
                throw new IllegalArgumentException("Tranche introuvable");
            }
            t.setStatut(StatutTranche.PAYEE);
            t.setDatePaiement((datePaiement == null) ? LocalDate.now() : datePaiement);
            if (referencePaiement != null && !referencePaiement.isBlank()) {
                t.setReferencePaiement(referencePaiement.trim());
            }
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw ex;
        } finally {
            em.close();
        }
    }

    public List<TranchePaiement> findByObligatoire(Boolean obligatoire) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT t FROM TranchePaiement t WHERE t.obligatoire = :obligatoire ORDER BY t.dateEcheance",
                            TranchePaiement.class)
                    .setParameter("obligatoire", obligatoire)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public boolean hasAnyNonPayeeForEtudiant(Long etudiantId) {
        if (etudiantId == null) {
            return false;
        }
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Long count = em.createQuery(
                            "select count(t) from TranchePaiement t " +
                                    "where t.etudiant.id = :etudiantId " +
                                    "and t.obligatoire = true " +
                                    "and t.statut <> :payee",
                            Long.class)
                    .setParameter("etudiantId", etudiantId)
                    .setParameter("payee", StatutTranche.PAYEE)
                    .getSingleResult();
            return count != null && count > 0;
        } finally {
            em.close();
        }
    }

    public long countDistinctEtudiantsWithObligatoireTranche() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            Long count = em.createQuery(
                            "select count(distinct t.etudiant.id) from TranchePaiement t " +
                                    "where t.obligatoire = true and t.etudiant.id is not null",
                            Long.class)
                    .getSingleResult();
            return (count == null) ? 0L : count;
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

    public void delete(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            TranchePaiement t = em.find(TranchePaiement.class, id);
            if (t != null) {
                em.remove(t);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
}