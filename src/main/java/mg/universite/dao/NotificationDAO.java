package mg.universite.dao;

import jakarta.persistence.EntityManager;
import mg.universite.model.Etudiant;
import mg.universite.model.Inscription;
import mg.universite.model.Notification;

import java.util.List;

public class NotificationDAO {

    public void save(Notification notification) {
        EntityManager em = JPAUtil.getEntityManager();
        var tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(notification);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void createForInscription(Long inscriptionId, String message) {
        EntityManager em = JPAUtil.getEntityManager();
        var tx = em.getTransaction();
        try {
            tx.begin();
            Inscription ins = em.find(Inscription.class, inscriptionId);
            if (ins == null) {
                throw new IllegalArgumentException("Inscription introuvable");
            }
            Notification n = new Notification(ins, message);
            em.persist(n);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }

    public void createForEtudiant(Long etudiantId, String message) {
        EntityManager em = JPAUtil.getEntityManager();
        var tx = em.getTransaction();
        try {
            tx.begin();
            Etudiant e = em.find(Etudiant.class, etudiantId);
            if (e == null) {
                throw new IllegalArgumentException("Étudiant introuvable");
            }
            Notification n = new Notification(e, message);
            em.persist(n);
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw ex;
        } finally {
            em.close();
        }
    }

    public List<Notification> findByEtudiantId(Long etudiantId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "select n from Notification n " +
                                    "left join fetch n.etudiant e " +
                                    "left join fetch n.inscription i " +
                                    "left join fetch i.etudiant ie " +
                                    "where (e.id = :id) or (ie.id = :id) order by n.createdAt desc",
                            Notification.class
                    )
                    .setParameter("id", etudiantId)
                    .getResultList();
        } finally {
            em.close();
        }
    }

    public List<Notification> findAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                    "select distinct n from Notification n " +
                            "left join fetch n.etudiant e " +
                            "left join fetch n.inscription i " +
                            "left join fetch i.etudiant ie " +
                            "order by n.createdAt desc",
                    Notification.class
            ).getResultList();
        } finally {
            em.close();
        }
    }

    public void markAsRead(Long notificationId, Long etudiantId) {
        if (notificationId == null) {
            throw new IllegalArgumentException("Notification requise");
        }
        EntityManager em = JPAUtil.getEntityManager();
        var tx = em.getTransaction();
        try {
            tx.begin();
            Notification n = em.find(Notification.class, notificationId);
            if (n == null) {
                throw new IllegalArgumentException("Notification introuvable");
            }
            if (etudiantId != null) {
                Long direct = (n.getEtudiant() == null) ? null : n.getEtudiant().getId();
                Long legacy = (n.getInscription() == null || n.getInscription().getEtudiant() == null)
                        ? null
                        : n.getInscription().getEtudiant().getId();
                if (!(etudiantId.equals(direct) || etudiantId.equals(legacy))) {
                    throw new IllegalArgumentException("Accès interdit");
                }
            }
            n.setReadFlag(true);
            tx.commit();
        } catch (Exception ex) {
            if (tx.isActive()) tx.rollback();
            throw ex;
        } finally {
            em.close();
        }
    }
}
