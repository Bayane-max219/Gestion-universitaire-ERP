package mg.universite.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import mg.universite.model.EmploiDuTemps;

import java.time.DayOfWeek;
import java.util.List;

public class EmploiDuTempsDAO {

    public void save(EmploiDuTemps emploiDuTemps) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(emploiDuTemps);
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
            return em.createQuery("SELECT e FROM EmploiDuTemps e", EmploiDuTemps.class).getResultList();
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