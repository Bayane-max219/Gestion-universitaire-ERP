package mg.universite.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import mg.universite.model.Note;

import java.util.List;

public class NoteDAO {

    public void save(Note note) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(note);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            e.printStackTrace();
        } finally {
            em.close();
        }
    }

    public List<Note> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("SELECT n FROM Note n", Note.class).getResultList();
        } finally {
            em.close();
        }
    }

    public List<Note> findByInscriptionId(Long inscriptionId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT n FROM Note n WHERE n.inscription.id = :inscriptionId", 
                Note.class
            ).setParameter("inscriptionId", inscriptionId).getResultList();
        } finally {
            em.close();
        }
    }

    public List<Note> findByEtudiantId(Long etudiantId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT n FROM Note n WHERE n.inscription.etudiant.id = :etudiantId", 
                Note.class
            ).setParameter("etudiantId", etudiantId).getResultList();
        } finally {
            em.close();
        }
    }

    public List<Note> findByMatiereId(Long matiereId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                "SELECT n FROM Note n WHERE n.matiere.id = :matiereId", 
                Note.class
            ).setParameter("matiereId", matiereId).getResultList();
        } finally {
            em.close();
        }
    }

    public Note findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Note.class, id);
        } finally {
            em.close();
        }
    }

    public void delete(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            Note n = em.find(Note.class, id);
            if (n != null) {
                em.remove(n);
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