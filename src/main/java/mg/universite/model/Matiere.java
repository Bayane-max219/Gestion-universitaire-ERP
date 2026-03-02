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

    @ManyToOne
    @JoinColumn(name = "professeur_id")
    private Professeur professeurResponsable;

    @OneToMany(mappedBy = "matiere")
    private List<Inscription> inscriptions;

    @OneToMany(mappedBy = "matiere", cascade = CascadeType.ALL)
    private List<Programme> programmes;

    @OneToMany(mappedBy = "matiere", cascade = CascadeType.ALL)
    private List<Note> notes;

    public Matiere() {}

    public Matiere(String nom, int coefficient) {
        this.nom = nom;
        this.coefficient = coefficient;
    }

    public Matiere(String nom, int coefficient, Professeur professeurResponsable) {
        this.nom = nom;
        this.coefficient = coefficient;
        this.professeurResponsable = professeurResponsable;
    }

    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public int getCoefficient() { return coefficient; }
    public void setCoefficient(int coefficient) { this.coefficient = coefficient; }
    public Professeur getProfesseurResponsable() { return professeurResponsable; }
    public void setProfesseurResponsable(Professeur professeurResponsable) { this.professeurResponsable = professeurResponsable; }
    public List<Inscription> getInscriptions() { return inscriptions; }
    public void setInscriptions(List<Inscription> inscriptions) { this.inscriptions = inscriptions; }
    public List<Programme> getProgrammes() { return programmes; }
    public void setProgrammes(List<Programme> programmes) { this.programmes = programmes; }
    public List<Note> getNotes() { return notes; }
    public void setNotes(List<Note> notes) { this.notes = notes; }
}