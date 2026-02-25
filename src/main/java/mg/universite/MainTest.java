package mg.universite;

import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class MainTest {
    public static void main(String[] args) {
        try {
            System.out.println("Tentative de connexion à la base de données...");

            // Cette ligne lit le persistence.xml et initialise Hibernate
            EntityManagerFactory emf = Persistence.createEntityManagerFactory("UniversityPU");

            System.out.println("==========================================");
            System.out.println("SUCCÈS : La base de données a été synchronisée !");
            System.out.println("Vérifiez vos tables dans MySQL (Etudiant, Matiere, Inscription).");
            System.out.println("==========================================");

            emf.close();
        } catch (Exception e) {
            System.err.println("ERREUR lors de la connexion :");
            e.printStackTrace();
        }
    }
}