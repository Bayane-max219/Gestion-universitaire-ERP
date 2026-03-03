package mg.universite.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "programmes")
public class Programme {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Niveau niveau;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Semestre semestre;
    
    @ManyToOne
    @JoinColumn(name = "filiere_id", nullable = false)
    private Filiere filiere;
    
    @Column(length = 1000)
    private String description;
    
    @OneToMany(mappedBy = "programme", cascade = CascadeType.ALL)
    private List<Matiere> matieres;
    
    // Constructeurs
    public Programme() {}
    
    public Programme(Niveau niveau, Semestre semestre, Filiere filiere, String description) {
        this.niveau = niveau;
        this.semestre = semestre;
        this.filiere = filiere;
        this.description = description;
    }
    
    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Niveau getNiveau() { return niveau; }
    public void setNiveau(Niveau niveau) { this.niveau = niveau; }
    public Semestre getSemestre() { return semestre; }
    public void setSemestre(Semestre semestre) { this.semestre = semestre; }
    public Filiere getFiliere() { return filiere; }
    public void setFiliere(Filiere filiere) { this.filiere = filiere; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public List<Matiere> getMatieres() { return matieres; }
    public void setMatieres(List<Matiere> matieres) { this.matieres = matieres; }
}