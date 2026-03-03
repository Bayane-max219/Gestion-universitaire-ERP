package mg.universite.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "tranches_paiement")
public class TranchePaiement {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String libelle;
    
    @Column(nullable = false)
    private Double montant;
    
    @Column(nullable = false)
    private LocalDate dateEcheance;
    
    @Column(nullable = false)
    private Boolean obligatoire;
    
    @Column(length = 500)
    private String description;
    
    // Constructeurs
    public TranchePaiement() {}
    
    public TranchePaiement(String libelle, Double montant, LocalDate dateEcheance, Boolean obligatoire, String description) {
        this.libelle = libelle;
        this.montant = montant;
        this.dateEcheance = dateEcheance;
        this.obligatoire = obligatoire;
        this.description = description;
    }
    
    // Getters et Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }
    public Double getMontant() { return montant; }
    public void setMontant(Double montant) { this.montant = montant; }
    public LocalDate getDateEcheance() { return dateEcheance; }
    public void setDateEcheance(LocalDate dateEcheance) { this.dateEcheance = dateEcheance; }
    public Boolean getObligatoire() { return obligatoire; }
    public void setObligatoire(Boolean obligatoire) { this.obligatoire = obligatoire; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}