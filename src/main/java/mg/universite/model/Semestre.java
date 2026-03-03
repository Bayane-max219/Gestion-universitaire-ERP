package mg.universite.model;

public enum Semestre {
    S1("Semestre 1"),
    S2("Semestre 2");
    
    private final String libelle;
    
    Semestre(String libelle) {
        this.libelle = libelle;
    }
    
    public String getLibelle() {
        return libelle;
    }
}