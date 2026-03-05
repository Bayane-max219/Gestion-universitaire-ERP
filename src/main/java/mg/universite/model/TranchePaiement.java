package mg.universite.model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "tranches_paiement")
public class TranchePaiement {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = true)
    @JoinColumn(name = "inscription_id", nullable = true)
    private Inscription inscription;

    @ManyToOne
    @JoinColumn(name = "etudiant_id")
    private Etudiant etudiant;

    @Column(nullable = false)
    private String libelle;
    
    @Column(nullable = false)
    private Double montant;
    
    @Column(nullable = false)
    private LocalDate dateEcheance;
    
    @Column(nullable = false)
    private Boolean obligatoire;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatutTranche statut = StatutTranche.A_PAYER;

    @Column(length = 100)
    private String referencePaiement;

    private LocalDate datePaiement;

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

    public Inscription getInscription() { return inscription; }
    public void setInscription(Inscription inscription) { this.inscription = inscription; }

    public Etudiant getEtudiant() { return etudiant; }
    public void setEtudiant(Etudiant etudiant) { this.etudiant = etudiant; }

    public String getLibelle() { return libelle; }
    public void setLibelle(String libelle) { this.libelle = libelle; }
    public Double getMontant() { return montant; }
    public void setMontant(Double montant) { this.montant = montant; }
    public LocalDate getDateEcheance() { return dateEcheance; }
    public void setDateEcheance(LocalDate dateEcheance) { this.dateEcheance = dateEcheance; }
    public Boolean getObligatoire() { return obligatoire; }
    public void setObligatoire(Boolean obligatoire) { this.obligatoire = obligatoire; }

    public StatutTranche getStatut() { return statut; }
    public void setStatut(StatutTranche statut) { this.statut = statut; }

    public String getReferencePaiement() { return referencePaiement; }
    public void setReferencePaiement(String referencePaiement) { this.referencePaiement = referencePaiement; }

    public LocalDate getDatePaiement() { return datePaiement; }
    public void setDatePaiement(LocalDate datePaiement) { this.datePaiement = datePaiement; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}