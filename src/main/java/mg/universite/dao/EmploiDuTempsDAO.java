package mg.universite.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import mg.universite.model.EmploiDuTemps;
import mg.universite.model.Filiere;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;

public class EmploiDuTempsDAO {

    public void save(EmploiDuTemps emploiDuTemps) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            if (emploiDuTemps.getId() == null) {
                em.persist(emploiDuTemps);
            } else {
                em.merge(emploiDuTemps);
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public List<EmploiDuTemps> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "SELECT e FROM EmploiDuTemps e ORDER BY e.mois DESC, e.jour ASC, e.heureDebut ASC",
                    EmploiDuTemps.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public List<EmploiDuTemps> findByFiliereAndMois(Filiere filiere, LocalDate mois) {
        if (filiere == null || filiere.getId() == null || mois == null) {
            return List.of();
        }
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT e FROM EmploiDuTemps e WHERE e.filiere = :filiere AND e.mois = :mois ORDER BY e.jour ASC, e.heureDebut ASC",
                            EmploiDuTemps.class
                    )
                    .setParameter("filiere", filiere)
                    .setParameter("mois", mois)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<EmploiDuTemps> findByFiliereIdAndMois(Long filiereId, LocalDate mois) {
        if (filiereId == null || mois == null) {
            return List.of();
        }
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT e FROM EmploiDuTemps e WHERE e.filiere.id = :filiereId AND e.mois = :mois ORDER BY e.jour ASC, e.heureDebut ASC",
                            EmploiDuTemps.class
                    )
                    .setParameter("filiereId", filiereId)
                    .setParameter("mois", mois)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<EmploiDuTemps> findByJour(DayOfWeek jour) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT e FROM EmploiDuTemps e WHERE e.jour = :jour", 
                EmploiDuTemps.class
            ).setParameter("jour", jour).getResultList();
        } finally {
            em.close();
        }
    }

    public List<EmploiDuTemps> findByProfesseurId(Long professeurId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT e FROM EmploiDuTemps e WHERE e.professeur.id = :professeurId", 
                EmploiDuTemps.class
            ).setParameter("professeurId", professeurId).getResultList();
        } finally {
            em.close();
        }
    }

    public List<EmploiDuTemps> findByMatiereId(Long matiereId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT e FROM EmploiDuTemps e WHERE e.matiere.id = :matiereId", 
                EmploiDuTemps.class
            ).setParameter("matiereId", matiereId).getResultList();
        } finally {
            em.close();
        }
    }

    public EmploiDuTemps findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(EmploiDuTemps.class, id);
        } finally {
            em.close();
        }
    }

    public void delete(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            EmploiDuTemps e = em.find(EmploiDuTemps.class, id);
            if (e != null) {
                em.remove(e);
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