package mg.universite.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class JPAUtil {
    private static final EntityManagerFactory factory =
            Persistence.createEntityManagerFactory("UniversityPU");

    public static EntityManager getEntityManager() {
        return factory.createEntityManager();
    }
}