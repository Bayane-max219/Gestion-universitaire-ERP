package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mg.universite.dao.EtudiantDAO;
import mg.universite.dao.InscriptionDAO;
import mg.universite.dao.MatiereDAO;
import mg.universite.dao.NoteDAO;
import mg.universite.model.Inscription;
import mg.universite.model.Note;
import mg.universite.model.Semestre;
import mg.universite.model.User;
import mg.universite.security.SessionKeys;
import mg.universite.service.EtudiantService;
import mg.universite.service.EtudiantNoteService;

import java.io.IOException;
import java.time.LocalDate;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/notes")
public class NoteServlet extends HttpServlet {

    private NoteDAO noteDAO = new NoteDAO();
    private EtudiantDAO etudiantDAO = new EtudiantDAO();
    private MatiereDAO matiereDAO = new MatiereDAO();
    private InscriptionDAO inscriptionDAO = new InscriptionDAO();
    private EtudiantNoteService etudiantNoteService = new EtudiantNoteService();
    private final EtudiantService etudiantService = new EtudiantService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute(SessionKeys.AUTH_USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if (!isAdmin(user)) {
            handleStudentGet(request, response, user);
            return;
        }
        
        if ("delete".equals(action) && idParam != null) {
            Long id = Long.parseLong(idParam);
            noteDAO.delete(id);
            response.sendRedirect(request.getContextPath() + "/notes");
            return;
        }
        
        if ("new".equals(action)) {
            request.setAttribute("etudiants", etudiantDAO.findAll());
            request.setAttribute("matieres", matiereDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/form-note.jsp").forward(request, response);
        } else if ("edit".equals(action) && idParam != null) {
            Long id = Long.parseLong(idParam);
            Note note = noteDAO.findById(id);
            request.setAttribute("note", note);
            request.setAttribute("etudiants", etudiantDAO.findAll());
            request.setAttribute("matieres", matiereDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/form-note.jsp").forward(request, response);
        } else if ("releve".equals(action)) {
            // Affichage du relevé de notes pour un étudiant
            String etudiantIdParam = request.getParameter("etudiantId");
            if (etudiantIdParam != null) {
                
                Long etudiantId = Long.parseLong(etudiantIdParam);
                
                // Charger les données de l'étudiant et ses notes
                var etudiant = etudiantNoteService.getEtudiantAvecNotes(etudiantId);
                var notes = noteDAO.findByEtudiantId(etudiantId);
                
                request.setAttribute("etudiant", etudiant);
                request.setAttribute("notes", notes);

                request.setAttribute("dateCourante", LocalDate.now());
                request.setAttribute("totalSubjects", notes.stream().map(n -> n.getMatiere().getId()).distinct().count());
                request.setAttribute("totalGrades", notes.size());
                request.setAttribute("overallAverage", computeWeightedAverage(notes));
                request.setAttribute("rank", "N/A");
                request.setAttribute("gradesBySubject", buildGradesBySubject(notes));
                request.getRequestDispatcher("/WEB-INF/views/releve-notes.jsp").forward(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/notes");
            }
        } else {
            Semestre semestre = parseSemestreOrNull(request.getParameter("semestre"));
            Long etudiantId = parseLongOrNull(request.getParameter("etudiantId"));

            List<Note> notes;
            if (etudiantId != null && semestre != null) {
                notes = noteDAO.findByEtudiantIdAndSemestre(etudiantId, semestre);
            } else if (etudiantId != null) {
                notes = noteDAO.findByEtudiantId(etudiantId);
            } else if (semestre != null) {
                notes = noteDAO.findBySemestre(semestre);
            } else {
                notes = noteDAO.findAll();
            }
            request.setAttribute("notes", notes);
            request.setAttribute("selectedSemestre", semestre);
            request.setAttribute("etudiants", etudiantDAO.findAll());
            request.setAttribute("selectedEtudiantId", etudiantId);
            request.setAttribute("uniqueStudentsCount", notes.stream().map(n -> n.getInscription().getEtudiant().getId()).distinct().count());
            request.setAttribute("uniqueSubjectsCount", notes.stream().map(n -> n.getMatiere().getId()).distinct().count());
            request.setAttribute("averageGrade", computeWeightedAverage(notes));
            request.getRequestDispatcher("/WEB-INF/views/notes.jsp").forward(request, response);
        }
    }
    

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session == null) ? null : (User) session.getAttribute(SessionKeys.AUTH_USER);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (!isAdmin(user)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String idParam = request.getParameter("id");
        String inscriptionIdParam = request.getParameter("inscriptionId");
        String etudiantIdParam = request.getParameter("etudiantId");
        String matiereIdParam = request.getParameter("matiereId");
        String valeurParam = request.getParameter("valeur");
        String typeEvaluation = request.getParameter("typeEvaluation");
        String semestreParam = request.getParameter("semestre");

        try {
            Inscription inscription = null;
            if (inscriptionIdParam != null && !inscriptionIdParam.isBlank()) {
                inscription = inscriptionDAO.findById(Long.parseLong(inscriptionIdParam));
            }
            if (inscription == null) {
                if (etudiantIdParam == null || etudiantIdParam.isBlank()) {
                    throw new IllegalArgumentException("Étudiant requis");
                }
                if (matiereIdParam == null || matiereIdParam.isBlank()) {
                    throw new IllegalArgumentException("Matière requise");
                }
                Long etudiantId = Long.parseLong(etudiantIdParam);
                Long matiereId = Long.parseLong(matiereIdParam);
                inscription = inscriptionDAO.findByEtudiantIdAndMatiereId(etudiantId, matiereId);
                if (inscription == null) {
                    inscription = inscriptionDAO.save(etudiantId, matiereId);
                }
            }
            if (inscription == null || inscription.getMatiere() == null) {
                throw new IllegalArgumentException("Inscription introuvable");
            }
            if (valeurParam == null || valeurParam.isBlank()) {
                throw new IllegalArgumentException("Valeur requise");
            }

            Semestre semestre = (semestreParam == null || semestreParam.isBlank())
                    ? Semestre.S1
                    : Semestre.valueOf(semestreParam);

            Note note;
            if (idParam != null && !idParam.isBlank()) {
                note = noteDAO.findById(Long.parseLong(idParam));
                if (note == null) {
                    throw new IllegalArgumentException("Note introuvable");
                }
                note.setInscription(inscription);
                note.setMatiere(inscription.getMatiere());
                note.setSemestre(semestre);
                note.setValeur(Double.parseDouble(valeurParam));
                note.setTypeEvaluation(typeEvaluation);
            } else {
                note = new Note(
                        inscription,
                        inscription.getMatiere(),
                        semestre,
                        Double.parseDouble(valeurParam),
                        typeEvaluation
                );
            }

            noteDAO.save(note);
            response.sendRedirect(request.getContextPath() + "/notes");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            if (idParam != null && !idParam.isBlank()) {
                request.setAttribute("note", noteDAO.findById(Long.parseLong(idParam)));
            }
            request.setAttribute("etudiants", etudiantDAO.findAll());
            request.setAttribute("matieres", matiereDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/form-note.jsp").forward(request, response);
        }
    }

    private boolean isAdmin(User user) {
        return user != null && user.getRole() != null && user.getRole().getId() == 1L;
    }

    private void handleStudentGet(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        String email = user.getUsername();
        var etudiant = etudiantService.findByEmail(email);
        if (etudiant == null) {
            request.setAttribute("notes", List.of());
            request.setAttribute("notesCount", 0);
            request.setAttribute("matieresCount", 0);
            request.setAttribute("moyenne", "N/A");
            request.getRequestDispatcher("/WEB-INF/views/notes-etudiant.jsp").forward(request, response);
            return;
        }

        Semestre semestre = parseSemestreOrDefault(request.getParameter("semestre"), Semestre.S1);
        List<Note> notes = noteDAO.findByEtudiantIdAndSemestre(etudiant.getId(), semestre);

        request.setAttribute("etudiant", etudiant);
        request.setAttribute("notes", notes);
        request.setAttribute("notesCount", notes.size());
        request.setAttribute("matieresCount", notes.stream().map(n -> n.getMatiere().getId()).distinct().count());
        request.setAttribute("selectedSemestre", semestre);
        request.setAttribute("moyenne", computeWeightedAverage(notes));
        request.setAttribute("totalCoefficients", computeSumCoefficients(notes));
        request.setAttribute("totalPoints", computeWeightedSum(notes));
        request.getRequestDispatcher("/WEB-INF/views/notes-etudiant.jsp").forward(request, response);
    }

    private static Long parseLongOrNull(String v) {
        if (v == null || v.isBlank()) {
            return null;
        }
        try {
            return Long.parseLong(v.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private static Semestre parseSemestreOrNull(String v) {
        if (v == null || v.isBlank()) {
            return null;
        }
        try {
            return Semestre.valueOf(v.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private static Semestre parseSemestreOrDefault(String v, Semestre def) {
        Semestre s = parseSemestreOrNull(v);
        return (s == null) ? def : s;
    }

    private static String computeWeightedAverage(List<Note> notes) {
        if (notes == null || notes.isEmpty()) {
            return "N/A";
        }
        double sumCoeff = 0.0;
        double sum = 0.0;
        for (Note n : notes) {
            if (n.getValeur() == null || n.getMatiere() == null) {
                continue;
            }
            int coeff = n.getMatiere().getCoefficient();
            if (coeff <= 0) {
                coeff = 1;
            }
            sumCoeff += coeff;
            sum += n.getValeur() * coeff;
        }
        if (sumCoeff <= 0) {
            return "N/A";
        }
        return String.format(java.util.Locale.US, "%.2f", (sum / sumCoeff));
    }

    private static long computeSumCoefficients(List<Note> notes) {
        if (notes == null || notes.isEmpty()) {
            return 0L;
        }
        long sumCoeff = 0L;
        for (Note n : notes) {
            if (n.getValeur() == null || n.getMatiere() == null) {
                continue;
            }
            int coeff = n.getMatiere().getCoefficient();
            if (coeff <= 0) {
                coeff = 1;
            }
            sumCoeff += coeff;
        }
        return sumCoeff;
    }

    private static String computeWeightedSum(List<Note> notes) {
        if (notes == null || notes.isEmpty()) {
            return "0";
        }
        double sum = 0.0;
        for (Note n : notes) {
            if (n.getValeur() == null || n.getMatiere() == null) {
                continue;
            }
            int coeff = n.getMatiere().getCoefficient();
            if (coeff <= 0) {
                coeff = 1;
            }
            sum += n.getValeur() * coeff;
        }
        return String.format(java.util.Locale.US, "%.2f", sum);
    }

    public static class GradeInfo {
        private final Double grade;
        private final String type;
        private final Double subjectAvg;
        private final Integer rank;

        public GradeInfo(Double grade, String type, Double subjectAvg, Integer rank) {
            this.grade = grade;
            this.type = type;
            this.subjectAvg = subjectAvg;
            this.rank = rank;
        }

        public Double getGrade() { return grade; }
        public String getType() { return type; }
        public Double getSubjectAvg() { return subjectAvg; }
        public Integer getRank() { return rank; }
    }

    private static Map<mg.universite.model.Matiere, GradeInfo> buildGradesBySubject(List<Note> notes) {
        Map<Long, mg.universite.model.Matiere> matieresById = new LinkedHashMap<>();
        Map<Long, Double> sumByMatiere = new LinkedHashMap<>();
        Map<Long, Integer> countByMatiere = new LinkedHashMap<>();
        Map<Long, String> typeByMatiere = new LinkedHashMap<>();

        for (Note n : notes) {
            if (n.getMatiere() == null || n.getMatiere().getId() == null || n.getValeur() == null) {
                continue;
            }
            Long mid = n.getMatiere().getId();
            matieresById.putIfAbsent(mid, n.getMatiere());
            sumByMatiere.put(mid, sumByMatiere.getOrDefault(mid, 0.0) + n.getValeur());
            countByMatiere.put(mid, countByMatiere.getOrDefault(mid, 0) + 1);
            if (!typeByMatiere.containsKey(mid) && n.getTypeEvaluation() != null && !n.getTypeEvaluation().isBlank()) {
                typeByMatiere.put(mid, n.getTypeEvaluation());
            }
        }

        Map<mg.universite.model.Matiere, GradeInfo> res = new LinkedHashMap<>();
        for (Map.Entry<Long, mg.universite.model.Matiere> e : matieresById.entrySet()) {
            Long mid = e.getKey();
            int count = countByMatiere.getOrDefault(mid, 0);
            Double avg = (count == 0) ? null : (sumByMatiere.getOrDefault(mid, 0.0) / count);
            String type = typeByMatiere.get(mid);
            res.put(e.getValue(), new GradeInfo(avg, type, avg, null));
        }
        return res;
    }
}