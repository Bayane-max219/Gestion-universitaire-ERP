package mg.universite.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import mg.universite.model.Professeur;

import java.util.List;

public class ProfesseurDAO {

    public void save(Professeur professeur) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(professeur);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public List<Professeur> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Professeur p", Professeur.class).getResultList();
        } finally {
            em.close();
        }
    }

    public Professeur findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Professeur.class, id);
        } finally {
            em.close();
        }
    }

    public void delete(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Professeur p = em.find(Professeur.class, id);
            if (p != null) {
                em.remove(p);
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