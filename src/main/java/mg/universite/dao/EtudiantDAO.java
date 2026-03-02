package mg.universite.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import mg.universite.model.Etudiant;
import java.util.List;

public class EtudiantDAO {

    public void save(Etudiant etudiant) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(etudiant); // Sauvegarde l'étudiant
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public List<Etudiant> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT e FROM Etudiant e", Etudiant.class).getResultList();
        } finally {
            em.close();
        }
    }

    public void delete(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Etudiant e = em.find(Etudiant.class, id); // On cherche l'étudiant
            if (e != null) {
                em.remove(e); // On le supprime
            }
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public Etudiant findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Etudiant.class, id);
        } finally {
            em.close();
        }
    }
}