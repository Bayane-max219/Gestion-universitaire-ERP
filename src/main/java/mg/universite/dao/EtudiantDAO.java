package mg.universite.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import mg.universite.model.Etudiant;
import mg.universite.model.Niveau;
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

    public Long findIdByEmail(String email) {
        if (email == null || email.isBlank()) {
            return null;
        }
        EntityManager em = JPAUtil.getEntityManager();
        try {
            var res = em.createQuery(
                            "select e.id from Etudiant e where lower(e.email) = lower(:email)",
                            Long.class
                    )
                    .setParameter("email", email.trim())
                    .getResultList();
            return res.isEmpty() ? null : res.get(0);
        } finally {
            em.close();
        }
    }
    
    public Etudiant findByEmail(String email) {
        if (email == null || email.isBlank()) {
            return null;
        }
        EntityManager em = JPAUtil.getEntityManager();
        try {
            return em.createQuery(
                            "select e from Etudiant e where lower(e.email) = lower(:email)",
                            Etudiant.class
                    )
                    .setParameter("email", email.trim())
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        } finally {
            em.close();
        }
    }
    
    public String generateNumeroEtudiant(Niveau niveau) {
        EntityManager em = JPAUtil.getEntityManager();
        try {
            String annee = String.valueOf(java.time.Year.now().getValue());
            String prefixeNumero = "SE" + annee;
            
            // Trouver le dernier numéro utilisé pour cette année
            var result = em.createQuery(
                            "select e.numeroEtudiant from Etudiant e where e.numeroEtudiant like :prefixe order by e.numeroEtudiant desc",
                            String.class
                    )
                    .setParameter("prefixe", prefixeNumero + "%")
                    .setMaxResults(1)
                    .getResultList();
            
            int nextNumber = 1;
            if (!result.isEmpty()) {
                String lastNumber = result.get(0);
                try {
                    nextNumber = Integer.parseInt(lastNumber.substring(6)) + 1; // 6 caractères pour "SE2026"
                } catch (Exception e) {
                    nextNumber = 1;
                }
            }
            
            return String.format("%s%04d", prefixeNumero, nextNumber);
        } finally {
            em.close();
        }
    }
}