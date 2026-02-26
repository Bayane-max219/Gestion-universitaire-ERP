package mg.universite.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;
import mg.universite.model.Role;

import java.util.List;

public class RoleDAO {

    public Role findById(Long id) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.find(Role.class, id);
        } finally {
            em.close();
        }
    }

    public Role findByName(String name) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            TypedQuery<Role> q = em.createQuery("select r from Role r where r.name = :name", Role.class);
            q.setParameter("name", name);
            List<Role> res = q.getResultList();
            return res.isEmpty() ? null : res.get(0);
        } finally {
            em.close();
        }
    }

    public void save(Role role) {
        EntityManager em = JPAUtil.getEntityManager();
        var tx = em.getTransaction();
        try {
            tx.begin();
            em.persist(role);
            tx.commit();
        } catch (Exception e) {
            if (tx.isActive()) tx.rollback();
            throw e;
        } finally {
            em.close();
        }
    }
}
