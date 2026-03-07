package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mg.universite.dao.EmploiDuTempsDAO;
import mg.universite.dao.FiliereDAO;
import mg.universite.dao.MatiereDAO;
import mg.universite.model.EmploiDuTemps;
import mg.universite.model.Matiere;
import mg.universite.model.User;
import mg.universite.security.SessionKeys;
import mg.universite.service.EtudiantService;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.time.YearMonth;
import java.util.EnumMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/emplois-du-temps")
public class EmploiDuTempsServlet extends HttpServlet {
    
    private final EtudiantService etudiantService = new EtudiantService();
    private final EmploiDuTempsDAO emploiDuTempsDAO = new EmploiDuTempsDAO();
    private final MatiereDAO matiereDAO = new MatiereDAO();
    private final FiliereDAO filiereDAO = new FiliereDAO();
    
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

        if (isAdmin(user)) {
            if ("delete".equals(action) && idParam != null) {
                Long id = Long.parseLong(idParam);
                emploiDuTempsDAO.delete(id);
                response.sendRedirect(request.getContextPath() + "/emplois-du-temps");
                return;
            }

            if ("new".equals(action)) {
                request.setAttribute("matieres", matiereDAO.findAll());
                request.setAttribute("filieres", filiereDAO.findAll());
                request.setAttribute("moisStr", YearMonth.now().toString());
                request.getRequestDispatcher("/WEB-INF/views/form-emploi-du-temps.jsp").forward(request, response);
                return;
            }

            if ("edit".equals(action) && idParam != null) {
                Long id = Long.parseLong(idParam);
                EmploiDuTemps emploiDuTemps = emploiDuTempsDAO.findById(id);
                request.setAttribute("emploiDuTemps", emploiDuTemps);
                request.setAttribute("matieres", matiereDAO.findAll());
                request.setAttribute("filieres", filiereDAO.findAll());
                if (emploiDuTemps != null && emploiDuTemps.getMois() != null) {
                    request.setAttribute("moisStr", YearMonth.from(emploiDuTemps.getMois()).toString());
                }
                request.getRequestDispatcher("/WEB-INF/views/form-emploi-du-temps.jsp").forward(request, response);
                return;
            }

            Long filiereId = parseLongOrNull(request.getParameter("filiereId"));
            LocalDate mois = parseMoisOrDefault(request.getParameter("mois"), YearMonth.now());
            List<EmploiDuTemps> emploisDuTemps = (filiereId == null)
                    ? emploiDuTempsDAO.findAll()
                    : emploiDuTempsDAO.findByFiliereIdAndMois(filiereId, mois);

            request.setAttribute("emploisDuTemps", emploisDuTemps);
            request.setAttribute("emploisDuTempsByDay", groupByDay(emploisDuTemps));
            request.setAttribute("uniqueSubjectsCount", emploisDuTemps.stream().map(e -> e.getMatiere().getId()).distinct().count());
            request.setAttribute("uniqueTeachersCount", emploisDuTemps.stream().map(e -> e.getProfesseur().getId()).distinct().count());
            request.setAttribute("uniqueDaysCount", emploisDuTemps.stream().map(EmploiDuTemps::getJour).distinct().count());
            request.setAttribute("filieres", filiereDAO.findAll());
            request.setAttribute("selectedFiliereId", filiereId);
            request.setAttribute("selectedMois", mois);
            request.setAttribute("selectedMoisStr", YearMonth.from(mois).toString());

            request.getRequestDispatcher("/WEB-INF/views/emplois-du-temps.jsp").forward(request, response);
            return;
        }

        String email = user.getUsername();
        var etudiant = etudiantService.findByEmail(email);
        LocalDate mois = parseMoisOrDefault(request.getParameter("mois"), YearMonth.now());
        List<EmploiDuTemps> emploisDuTemps = (etudiant == null || etudiant.getFiliere() == null)
                ? List.of()
                : emploiDuTempsDAO.findByFiliereIdAndMois(etudiant.getFiliere().getId(), mois);

        request.setAttribute("emploisDuTemps", emploisDuTemps);
        request.setAttribute("emploisDuTempsByDay", groupByDay(emploisDuTemps));
        request.setAttribute("uniqueSubjectsCount", emploisDuTemps.stream().map(e -> e.getMatiere().getId()).distinct().count());
        request.setAttribute("uniqueTeachersCount", emploisDuTemps.stream().map(e -> e.getProfesseur().getId()).distinct().count());
        request.setAttribute("uniqueDaysCount", emploisDuTemps.stream().map(EmploiDuTemps::getJour).distinct().count());
        request.setAttribute("selectedMois", mois);
        request.setAttribute("selectedMoisStr", YearMonth.from(mois).toString());
        request.getRequestDispatcher("/WEB-INF/views/emploi-du-temps.jsp").forward(request, response);
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
        Long matiereId = parseLongOrNull(request.getParameter("matiereId"));
        Long filiereId = parseLongOrNull(request.getParameter("filiereId"));
        LocalDate mois = parseMoisOrDefault(request.getParameter("mois"), YearMonth.now());
        String jourParam = request.getParameter("jour");
        String heureDebutParam = request.getParameter("heureDebut");
        String heureFinParam = request.getParameter("heureFin");
        String salle = request.getParameter("salle");

        try {
            if (matiereId == null || filiereId == null || jourParam == null || heureDebutParam == null || heureFinParam == null) {
                throw new IllegalArgumentException("Champs requis manquants");
            }

            Matiere matiere = matiereDAO.findById(matiereId);
            var filiere = filiereDAO.findById(filiereId);
            if (matiere == null || filiere == null) {
                throw new IllegalArgumentException("Matière ou filière invalide");
            }
            if (matiere.getProfesseurResponsable() == null) {
                throw new IllegalArgumentException("La matière doit avoir un professeur responsable");
            }

            DayOfWeek jour = DayOfWeek.valueOf(jourParam);
            if (jour == DayOfWeek.SUNDAY) {
                throw new IllegalArgumentException("Dimanche non autorisé");
            }

            LocalTime heureDebut = LocalTime.parse(heureDebutParam);
            LocalTime heureFin = LocalTime.parse(heureFinParam);
            if (!heureFin.isAfter(heureDebut)) {
                throw new IllegalArgumentException("Heure fin doit être après heure début");
            }

            EmploiDuTemps emploi;
            if (idParam != null && !idParam.isBlank()) {
                emploi = emploiDuTempsDAO.findById(Long.parseLong(idParam));
                if (emploi == null) {
                    throw new IllegalArgumentException("Emploi du temps introuvable");
                }
                emploi.setMatiere(matiere);
                emploi.setProfesseur(matiere.getProfesseurResponsable());
                emploi.setFiliere(filiere);
                emploi.setMois(mois);
                emploi.setJour(jour);
                emploi.setHeureDebut(heureDebut);
                emploi.setHeureFin(heureFin);
                emploi.setSalle(salle);
            } else {
                emploi = new EmploiDuTemps(
                        matiere,
                        matiere.getProfesseurResponsable(),
                        filiere,
                        mois,
                        jour,
                        heureDebut,
                        heureFin,
                        salle
                );
            }

            emploiDuTempsDAO.save(emploi);
            response.sendRedirect(request.getContextPath() + "/emplois-du-temps");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            if (idParam != null && !idParam.isBlank()) {
                EmploiDuTemps emploiDuTemps = emploiDuTempsDAO.findById(Long.parseLong(idParam));
                request.setAttribute("emploiDuTemps", emploiDuTemps);
                if (emploiDuTemps != null && emploiDuTemps.getMois() != null) {
                    request.setAttribute("moisStr", YearMonth.from(emploiDuTemps.getMois()).toString());
                }
            } else {
                request.setAttribute("moisStr", YearMonth.from(mois).toString());
            }
            request.setAttribute("matieres", matiereDAO.findAll());
            request.setAttribute("filieres", filiereDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/form-emploi-du-temps.jsp").forward(request, response);
        }
    }
    
    private boolean isAdmin(User user) {
        return user != null && user.getRole() != null && user.getRole().getId() == 1L;
    }

    private static Long parseLongOrNull(String v) {
        if (v == null || v.isBlank()) {
            return null;
        }
        try {
            return Long.parseLong(v);
        } catch (Exception e) {
            return null;
        }
    }

    private static LocalDate parseMoisOrDefault(String moisParam, YearMonth def) {
        if (moisParam == null || moisParam.isBlank()) {
            return def.atDay(1);
        }
        try {
            String trimmed = moisParam.trim();
            if (trimmed.length() == 7) {
                return YearMonth.parse(trimmed).atDay(1);
            }
            return LocalDate.parse(trimmed);
        } catch (Exception e) {
            return def.atDay(1);
        }
    }

    private static Map<String, List<EmploiDuTemps>> groupByDay(List<EmploiDuTemps> emplois) {
        Map<DayOfWeek, List<EmploiDuTemps>> tmp = new EnumMap<>(DayOfWeek.class);
        for (EmploiDuTemps e : emplois) {
            tmp.computeIfAbsent(e.getJour(), k -> new java.util.ArrayList<>()).add(e);
        }

        Map<String, List<EmploiDuTemps>> res = new LinkedHashMap<>();
        for (DayOfWeek d : List.of(DayOfWeek.MONDAY, DayOfWeek.TUESDAY, DayOfWeek.WEDNESDAY, DayOfWeek.THURSDAY, DayOfWeek.FRIDAY, DayOfWeek.SATURDAY)) {
            if (tmp.containsKey(d)) {
                res.put(toFrenchDay(d), tmp.get(d));
            }
        }
        return res;
    }

    private static String toFrenchDay(DayOfWeek d) {
        return switch (d) {
            case MONDAY -> "Lundi";
            case TUESDAY -> "Mardi";
            case WEDNESDAY -> "Mercredi";
            case THURSDAY -> "Jeudi";
            case FRIDAY -> "Vendredi";
            case SATURDAY -> "Samedi";
            default -> d.name();
        };
    }
}