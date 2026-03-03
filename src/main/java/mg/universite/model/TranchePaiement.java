package mg.universite.model;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "tranches_paiement")
public class TranchePaiement {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = false)
    @JoinColumn(name = "inscription_id", nullable = false)
    private Inscription inscription;

    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal montant;

    private LocalDate dateEcheance;

    private LocalDate datePaiement;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatutTranche statut;

    @Column(length = 50)
    private String referencePaiement;

    public TranchePaiement() {
    }

    public TranchePaiement(Inscription inscription, BigDecimal montant, LocalDate dateEcheance, StatutTranche statut, String referencePaiement) {
        this.inscription = inscription;
        this.montant = montant;
        this.dateEcheance = dateEcheance;
        this.statut = statut;
        this.referencePaiement = referencePaiement;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Inscription getInscription() {
        return inscription;
    }

    public void setInscription(Inscription inscription) {
        this.inscription = inscription;
    }

    public BigDecimal getMontant() {
        return montant;
    }

    public void setMontant(BigDecimal montant) {
        this.montant = montant;
    }

    public LocalDate getDateEcheance() {
        return dateEcheance;
    }

    public void setDateEcheance(LocalDate dateEcheance) {
        this.dateEcheance = dateEcheance;
    }

    public LocalDate getDatePaiement() {
        return datePaiement;
    }

    public void setDatePaiement(LocalDate datePaiement) {
        this.datePaiement = datePaiement;
    }

    public StatutTranche getStatut() {
        return statut;
    }

    public void setStatut(StatutTranche statut) {
        this.statut = statut;
    }

    public String getReferencePaiement() {
        return referencePaiement;
    }

    public void setReferencePaiement(String referencePaiement) {
        this.referencePaiement = referencePaiement;
    }
}
