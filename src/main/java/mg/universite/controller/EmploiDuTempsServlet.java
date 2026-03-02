package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mg.universite.dao.EmploiDuTempsDAO;
import mg.universite.dao.MatiereDAO;
import mg.universite.dao.ProfesseurDAO;
import mg.universite.model.EmploiDuTemps;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalTime;
import java.util.List;

@WebServlet("/emplois-du-temps")
public class EmploiDuTempsServlet extends HttpServlet {

    private EmploiDuTempsDAO emploiDuTempsDAO = new EmploiDuTempsDAO();
    private MatiereDAO matiereDAO = new MatiereDAO();
    private ProfesseurDAO professeurDAO = new ProfesseurDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        if ("delete".equals(action) && idParam != null) {
            Long id = Long.parseLong(idParam);
            emploiDuTempsDAO.delete(id);
            response.sendRedirect("emplois-du-temps");
            return;
        }
        
        if ("new".equals(action)) {
            request.setAttribute("matieres", matiereDAO.findAll());
            request.setAttribute("professeurs", professeurDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/form-emploi-du-temps.jsp").forward(request, response);
        } else if ("edit".equals(action) && idParam != null) {
            Long id = Long.parseLong(idParam);
            EmploiDuTemps emploiDuTemps = emploiDuTempsDAO.findById(id);
            request.setAttribute("emploiDuTemps", emploiDuTemps);
            request.setAttribute("matieres", matiereDAO.findAll());
            request.setAttribute("professeurs", professeurDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/form-emploi-du-temps.jsp").forward(request, response);
        } else {
            List<EmploiDuTemps> emploisDuTemps = emploiDuTempsDAO.findAll();
            request.setAttribute("emploisDuTemps", emploisDuTemps);
            request.getRequestDispatcher("/WEB-INF/views/emplois-du-temps.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String matiereIdParam = request.getParameter("matiereId");
        String professeurIdParam = request.getParameter("professeurId");
        String jourParam = request.getParameter("jour");
        String heureDebutParam = request.getParameter("heureDebut");
        String heureFinParam = request.getParameter("heureFin");
        String salle = request.getParameter("salle");

        EmploiDuTemps emploiDuTemps;
        
        if (idParam != null && !idParam.isEmpty()) {
            // Modification
            emploiDuTemps = emploiDuTempsDAO.findById(Long.parseLong(idParam));
            emploiDuTemps.setMatiere(matiereDAO.findById(Long.parseLong(matiereIdParam)));
            emploiDuTemps.setProfesseur(professeurDAO.findById(Long.parseLong(professeurIdParam)));
            emploiDuTemps.setJour(DayOfWeek.valueOf(jourParam));
            emploiDuTemps.setHeureDebut(LocalTime.parse(heureDebutParam));
            emploiDuTemps.setHeureFin(LocalTime.parse(heureFinParam));
            emploiDuTemps.setSalle(salle);
        } else {
            // Création
            emploiDuTemps = new EmploiDuTemps(
                matiereDAO.findById(Long.parseLong(matiereIdParam)),
                professeurDAO.findById(Long.parseLong(professeurIdParam)),
                DayOfWeek.valueOf(jourParam),
                LocalTime.parse(heureDebutParam),
                LocalTime.parse(heureFinParam),
                salle
            );
        }
        
        emploiDuTempsDAO.save(emploiDuTemps);
        response.sendRedirect("emplois-du-temps");
    }
}