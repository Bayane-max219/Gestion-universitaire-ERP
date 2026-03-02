package mg.universite.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "etudiants")
public class Etudiant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nom;

    private String prenom;

    @Column(unique = true, nullable = false)
    private String email;

    private String telephone;

    private String adresse;

    private String telephoneParent;

    private String numeroEtudiant;

    // Lien avec les inscriptions (Ton binôme s'occupera du côté Inscription,
    // mais tu dois définir la relation ici)
    @OneToMany(mappedBy = "etudiant", cascade = CascadeType.ALL)
    private List<Inscription> inscriptions;

    // Constructeurs
    public Etudiant() {}

    public Etudiant(String nom, String prenom, String email) {
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
    }

    public Etudiant(String nom, String prenom, String email, String telephone, String adresse, String telephoneParent) {
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.telephone = telephone;
        this.adresse = adresse;
        this.telephoneParent = telephoneParent;
    }

    // Getters et Setters (Indispensable pour JPA/Hibernate)
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }
    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }
    public String getTelephoneParent() { return telephoneParent; }
    public void setTelephoneParent(String telephoneParent) { this.telephoneParent = telephoneParent; }
    public String getNumeroEtudiant() { return numeroEtudiant; }
    public void setNumeroEtudiant(String numeroEtudiant) { this.numeroEtudiant = numeroEtudiant; }
    public List<Inscription> getInscriptions() { return inscriptions; }
    public void setInscriptions(List<Inscription> inscriptions) { this.inscriptions = inscriptions; }
}