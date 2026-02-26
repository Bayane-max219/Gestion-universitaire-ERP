package mg.universite.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mg.universite.model.User;

import java.util.List;

public class UserDAO {

    public User findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(User.class, id);
        } finally {
            em.close();
        }
    }

    public User findByUsername(String username) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<User> q = em.createQuery(
                    "select u from User u join fetch u.role where u.username = :username",
                    User.class
            );
            q.setParameter("username", username);
            List<User> res = q.getResultList();
            return res.isEmpty() ? null : res.get(0);
        } finally {
            em.close();
        }
    }

    public long countAll() {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery("select count(u) from User u", Long.class).getSingleResult();
        } finally {
            em.close();
        }
    }

    public void save(User user) {
        EntityManager em = JPAUtil.getEntityManager();
        var tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(user);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}
