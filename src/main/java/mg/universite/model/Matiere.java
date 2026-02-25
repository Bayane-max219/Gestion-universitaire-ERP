package mg.universite.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "matieres")
public class Matiere {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String nom;

    private int coefficient;

    @OneToMany(mappedBy = "matiere")
    private List<Inscription> inscriptions;

    public Matiere() {}

    public Matiere(String nom, int coefficient) {
        this.nom = nom;
        this.coefficient = coefficient;
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public int getCoefficient() { return coefficient; }
    public void setCoefficient(int coefficient) { this.coefficient = coefficient; }
}