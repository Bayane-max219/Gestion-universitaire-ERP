package mg.universite.model;

public enum Niveau {
    L1("Licence 1"),
    L2("Licence 2"), 
    L3("Licence 3"),
    M1("Master 1"),
    M2("Master 2");
    
    private final String libelle;
    
    Niveau(String libelle) {
        this.libelle = libelle;
    }
    
    public String getLibelle() {
        return libelle;
    }
    
    public static Niveau fromString(String niveau) {
        for (Niveau n : Niveau.values()) {
            if (n.name().equalsIgnoreCase(niveau)) {
                return n;
            }
        }
        throw new IllegalArgumentException("Niveau invalide: " + niveau);
    }
}