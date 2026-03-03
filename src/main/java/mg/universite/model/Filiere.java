package mg.universite.model;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "filieres")
public class Filiere {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String code;
    
    @Column(nullable = false)
    private String nom;
    
    @Column(length = 500)
    private String description;
    
    @OneToMany(mappedBy = "filiere", cascade = CascadeType.ALL)
    private List<Programme> programmes;
    
    // Constructeurs
    public Filiere() {}
    
    public Filiere(String code, String nom, String description) {
        this.code = code;
        this.nom = nom;
        this.description = description;
    }
    
    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public List<Programme> getProgrammes() { return programmes; }
    public void setProgrammes(List<Programme> programmes) { this.programmes = programmes; }
}