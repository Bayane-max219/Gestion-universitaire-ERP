package mg.universite.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import mg.universite.model.Note;
import mg.universite.model.Semestre;

import java.util.List;

public class NoteDAO {

    public void save(Note note) {
        EntityManager em = JPAUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        try {
            tx.begin();
            if (note.getId() == null) {
                em.persist(note);
            } else {
                em.merge(note);
            }
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
            return em.createQuery(
                    "select distinct n from Note n " +
                            "join fetch n.inscription i " +
                            "join fetch i.etudiant " +
                            "join fetch n.matiere " +
                            "order by i.etudiant.nom, i.etudiant.prenom, n.matiere.nom",
                    Note.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public List<Note> findByEtudiantIdAndSemestre(Long etudiantId, Semestre semestre) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "select distinct n from Note n " +
                                    "join fetch n.inscription i " +
                                    "join fetch i.etudiant " +
                                    "join fetch n.matiere " +
                                    "where i.etudiant.id = :etudiantId and n.semestre = :semestre " +
                                    "order by n.matiere.nom",
                            Note.class
                    )
                    .setParameter("etudiantId", etudiantId)
                    .setParameter("semestre", semestre)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Note> findBySemestre(Semestre semestre) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "select distinct n from Note n " +
                                    "join fetch n.inscription i " +
                                    "join fetch i.etudiant " +
                                    "join fetch n.matiere " +
                                    "where n.semestre = :semestre " +
                                    "order by i.etudiant.nom, i.etudiant.prenom, n.matiere.nom",
                            Note.class
                    )
                    .setParameter("semestre", semestre)
                    .getResultList();
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
                            "select distinct n from Note n " +
                                    "join fetch n.inscription i " +
                                    "join fetch i.etudiant " +
                                    "join fetch n.matiere " +
                                    "where i.etudiant.id = :etudiantId " +
                                    "order by n.matiere.nom",
                            Note.class
                    )
                    .setParameter("etudiantId", etudiantId)
                    .getResultList();
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