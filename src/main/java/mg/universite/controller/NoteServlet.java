package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mg.universite.dao.EtudiantDAO;
import mg.universite.dao.InscriptionDAO;
import mg.universite.dao.MatiereDAO;
import mg.universite.dao.NoteDAO;
import mg.universite.model.Inscription;
import mg.universite.model.Note;
import mg.universite.service.EtudiantNoteService;

import java.io.IOException;
import java.util.List;

@WebServlet("/notes")
public class NoteServlet extends HttpServlet {

    private NoteDAO noteDAO = new NoteDAO();
    private EtudiantDAO etudiantDAO = new EtudiantDAO();
    private MatiereDAO matiereDAO = new MatiereDAO();
    private InscriptionDAO inscriptionDAO = new InscriptionDAO();
    private EtudiantNoteService etudiantNoteService = new EtudiantNoteService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        if ("delete".equals(action) && idParam != null) {
            Long id = Long.parseLong(idParam);
            noteDAO.delete(id);
            response.sendRedirect("notes");
            return;
        }
        
        if ("new".equals(action)) {
            request.setAttribute("inscriptions", inscriptionDAO.findAll());
            request.setAttribute("matieres", matiereDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/form-note.jsp").forward(request, response);
        } else if ("edit".equals(action) && idParam != null) {
            Long id = Long.parseLong(idParam);
            Note note = noteDAO.findById(id);
            request.setAttribute("note", note);
            request.setAttribute("inscriptions", inscriptionDAO.findAll());
            request.setAttribute("matieres", matiereDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/form-note.jsp").forward(request, response);
        } else if ("releve".equals(action)) {
            // Affichage du relevé de notes pour un étudiant
            String etudiantIdParam = request.getParameter("etudiantId");
            if (etudiantIdParam != null) {
                Long etudiantId = Long.parseLong(etudiantIdParam);
                
                // Charger les données de l'étudiant et ses notes
                var etudiant = etudiantNoteService.getEtudiantAvecNotes(etudiantId);
                var notes = etudiantNoteService.getNotesByEtudiantId(etudiantId);
                
                request.setAttribute("etudiant", etudiant);
                request.setAttribute("notes", notes);
                request.getRequestDispatcher("/WEB-INF/views/releve-notes.jsp").forward(request, response);
            } else {
                response.sendRedirect("notes");
            }
        } else {
            List<Note> notes = noteDAO.findAll();
            request.setAttribute("notes", notes);
            request.getRequestDispatcher("/WEB-INF/views/notes.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String inscriptionIdParam = request.getParameter("inscriptionId");
        String matiereIdParam = request.getParameter("matiereId");
        String valeurParam = request.getParameter("valeur");
        String typeEvaluation = request.getParameter("typeEvaluation");

        Note note;
        
        if (idParam != null && !idParam.isEmpty()) {
            // Modification
            note = noteDAO.findById(Long.parseLong(idParam));
            note.setInscription(inscriptionDAO.findById(Long.parseLong(inscriptionIdParam)));
            note.setMatiere(matiereDAO.findById(Long.parseLong(matiereIdParam)));
            note.setValeur(Double.parseDouble(valeurParam));
            note.setTypeEvaluation(typeEvaluation);
        } else {
            // Création
            note = new Note(
                inscriptionDAO.findById(Long.parseLong(inscriptionIdParam)),
                matiereDAO.findById(Long.parseLong(matiereIdParam)),
                Double.parseDouble(valeurParam),
                typeEvaluation
            );
        }
        
        noteDAO.save(note);
        response.sendRedirect("notes");
    }
}