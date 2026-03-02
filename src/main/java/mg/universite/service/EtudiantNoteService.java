package mg.universite.service;

import mg.universite.dao.EtudiantDAO;
import mg.universite.dao.InscriptionDAO;
import mg.universite.dao.NoteDAO;
import mg.universite.model.Etudiant;
import mg.universite.model.Inscription;
import mg.universite.model.Note;

import java.util.List;

public class EtudiantNoteService {

    private final EtudiantDAO etudiantDAO;
    private final InscriptionDAO inscriptionDAO;
    private final NoteDAO noteDAO;

    public EtudiantNoteService() {
        this.etudiantDAO = new EtudiantDAO();
        this.inscriptionDAO = new InscriptionDAO();
        this.noteDAO = new NoteDAO();
    }

    public Etudiant getEtudiantAvecNotes(Long etudiantId) {
        // Récupérer l'étudiant
        Etudiant etudiant = etudiantDAO.findById(etudiantId);
        return etudiant;
    }

    public List<Note> getNotesByEtudiantId(Long etudiantId) {
        // Récupérer les notes associées à un étudiant via les inscriptions
        return noteDAO.findByEtudiantId(etudiantId);
    }
}