package mg.universite.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import mg.universite.model.Programme;
import mg.universite.model.Niveau;
import mg.universite.model.Semestre;
import mg.universite.model.Filiere;
import java.util.List;

public class ProgrammeDAO {
    
    public void save(Programme programme) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(programme);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }
    
    public List<Programme> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT p FROM Programme p ORDER BY p.niveau, p.semestre", Programme.class).getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<Programme> findByFiliere(Filiere filiere) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT p FROM Programme p WHERE p.filiere = :filiere ORDER BY p.niveau, p.semestre", 
                            Programme.class)
                    .setParameter("filiere", filiere)
                    .getResultList();
        } finally {
            em.close();
        }
    }
    
    public List<Programme> findByNiveauAndFiliere(Niveau niveau, Filiere filiere) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "SELECT p FROM Programme p WHERE p.niveau = :niveau AND p.filiere = :filiere ORDER BY p.semestre", 
                            Programme.class)
                    .setParameter("niveau", niveau)
                    .setParameter("filiere", filiere)
                    .getResultList();
        } finally {
            em.close();
        }
    }
    
    public Programme findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Programme.class, id);
        } finally {
            em.close();
        }
    }
    
    public void delete(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Programme p = em.find(Programme.class, id);
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