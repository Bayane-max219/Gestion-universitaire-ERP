package mg.universite.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import mg.universite.model.Filiere;
import java.util.List;

public class FiliereDAO {
    
    public void save(Filiere filiere) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(filiere);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
    
    public void update(Filiere filiere) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.merge(filiere);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }
    
    public List<Filiere> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT f FROM Filiere f ORDER BY f.nom", Filiere.class).getResultList();
        } finally {
            em.close();
        }
    }
    
    public Filiere findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Filiere.class, id);
        } finally {
            em.close();
        }
    }
    
    public Filiere findByCode(String code) {
        if (code == null || code.isBlank()) {
            return null;
        }
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT f FROM Filiere f WHERE f.code = :code", 
                            Filiere.class)
                    .setParameter("code", code)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }
    
    public void delete(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Filiere f = em.find(Filiere.class, id);
            if (f != null) {
                em.remove(f);
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