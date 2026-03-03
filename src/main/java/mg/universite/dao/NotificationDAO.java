package mg.universite.dao;

import jakarta.persistence.EntityManager;
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

    public List<Notification> findByEtudiantId(Long etudiantId) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "select n from Notification n join fetch n.inscription i join fetch i.etudiant e " +
                                    "where e.id = :id order by n.createdAt desc",
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
                    "select n from Notification n join fetch n.inscription i join fetch i.etudiant order by n.createdAt desc",
                    Notification.class
            ).getResultList();
        } finally {
            em.close();
        }
    }
}
