package mg.universite.model;

import jakarta.persistence.*;

@Entity
@Table(name = "programmes")
public class Programme {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "matiere_id", nullable = false)
    private Matiere matiere;

    @Column(length = 1000)
    private String chapitre;

    @Column(length = 2000)
    private String description;

    private int ordre;

    // Constructeurs
    public Programme() {}

    public Programme(Matiere matiere, String chapitre, String description, int ordre) {
        this.matiere = matiere;
        this.chapitre = chapitre;
        this.description = description;
        this.ordre = ordre;
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Matiere getMatiere() { return matiere; }
    public void setMatiere(Matiere matiere) { this.matiere = matiere; }
    public String getChapitre() { return chapitre; }
    public void setChapitre(String chapitre) { this.chapitre = chapitre; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public int getOrdre() { return ordre; }
    public void setOrdre(int ordre) { this.ordre = ordre; }
}