package mg.universite.model;

import jakarta.persistence.*;

import java.time.LocalDateTime;

@Entity
@Table(name = "notifications")
public class Notification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(optional = true)
    @JoinColumn(name = "inscription_id", nullable = true)
    private Inscription inscription;

    @ManyToOne(optional = true)
    @JoinColumn(name = "etudiant_id", nullable = true)
    private Etudiant etudiant;

    @Column(nullable = false, length = 255)
    private String message;

    @Column(nullable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private boolean readFlag;

    public Notification() {
    }

    public Notification(Inscription inscription, String message) {
        this.inscription = inscription;
        this.message = message;
        this.createdAt = LocalDateTime.now();
        this.readFlag = false;
    }

    public Notification(Etudiant etudiant, String message) {
        this.etudiant = etudiant;
        this.message = message;
        this.createdAt = LocalDateTime.now();
        this.readFlag = false;
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

    public Etudiant getEtudiant() {
        return etudiant;
    }

    public void setEtudiant(Etudiant etudiant) {
        this.etudiant = etudiant;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isReadFlag() {
        return readFlag;
    }

    public void setReadFlag(boolean readFlag) {
        this.readFlag = readFlag;
    }
}
