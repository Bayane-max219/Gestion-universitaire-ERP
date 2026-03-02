package mg.universite.model;

import jakarta.persistence.*;

@Entity
@Table(name = "notes")
public class Note {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "inscription_id", nullable = false)
    private Inscription inscription;

    @ManyToOne
    @JoinColumn(name = "matiere_id", nullable = false)
    private Matiere matiere;

    private Double valeur;

    @Column(length = 100)
    private String typeEvaluation; // "DS", "TP", "Examen", etc.

    // Constructeurs
    public Note() {}

    public Note(Inscription inscription, Matiere matiere, Double valeur, String typeEvaluation) {
        this.inscription = inscription;
        this.matiere = matiere;
        this.valeur = valeur;
        this.typeEvaluation = typeEvaluation;
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Inscription getInscription() { return inscription; }
    public void setInscription(Inscription inscription) { this.inscription = inscription; }
    public Matiere getMatiere() { return matiere; }
    public void setMatiere(Matiere matiere) { this.matiere = matiere; }
    public Double getValeur() { return valeur; }
    public void setValeur(Double valeur) { this.valeur = valeur; }
    public String getTypeEvaluation() { return typeEvaluation; }
    public void setTypeEvaluation(String typeEvaluation) { this.typeEvaluation = typeEvaluation; }
}