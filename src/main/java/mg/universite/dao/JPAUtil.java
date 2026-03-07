package mg.universite.dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

import java.util.HashMap;
import java.util.Map;

public class JPAUtil {
    private static final EntityManagerFactory factory = buildFactory();

    private static EntityManagerFactory buildFactory() {
        String host = getenvOrDefault("DB_HOST", "localhost");
        String port = getenvOrDefault("DB_PORT", "3306");
        String dbName = getenvOrDefault("DB_NAME", "gestion_universitaire_db");
        String user = getenvOrDefault("DB_USER", "root");
        String password = getenvOrDefault("DB_PASSWORD", "");

        String url = getenvOrDefault(
                "DB_URL",
                "jdbc:mysql://" + host + ":" + port + "/" + dbName + "?createDatabaseIfNotExist=true"
        );

        Map<String, Object> props = new HashMap<>();
        props.put("jakarta.persistence.jdbc.url", url);
        props.put("jakarta.persistence.jdbc.user", user);
        props.put("jakarta.persistence.jdbc.password", password);
        return Persistence.createEntityManagerFactory("UniversityPU", props);
    }

    private static String getenvOrDefault(String key, String def) {
        String v = System.getenv(key);
        return (v == null || v.isBlank()) ? def : v;
    }

    public static EntityManager getEntityManager() {
        return factory.createEntityManager();
    }
}