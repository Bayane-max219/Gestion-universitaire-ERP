package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mg.universite.dao.MatiereDAO;
import mg.universite.dao.ProgrammeDAO;
import mg.universite.model.Programme;

import java.io.IOException;
import java.util.List;

@WebServlet("/programmes")
public class ProgrammeServlet extends HttpServlet {

    private ProgrammeDAO programmeDAO = new ProgrammeDAO();
    private MatiereDAO matiereDAO = new MatiereDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        if ("delete".equals(action) && idParam != null) {
            Long id = Long.parseLong(idParam);
            programmeDAO.delete(id);
            response.sendRedirect("programmes");
            return;
        }
        
        if ("new".equals(action)) {
            request.setAttribute("matieres", matiereDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/form-programme.jsp").forward(request, response);
        } else if ("edit".equals(action) && idParam != null) {
            Long id = Long.parseLong(idParam);
            Programme programme = programmeDAO.findById(id);
            request.setAttribute("programme", programme);
            request.setAttribute("matieres", matiereDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/form-programme.jsp").forward(request, response);
        } else {
            List<Programme> programmes = programmeDAO.findAll();
            request.setAttribute("programmes", programmes);
            request.getRequestDispatcher("/WEB-INF/views/programmes.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String matiereIdParam = request.getParameter("matiereId");
        String chapitre = request.getParameter("chapitre");
        String description = request.getParameter("description");
        String ordreParam = request.getParameter("ordre");

        Programme programme;
        
        if (idParam != null && !idParam.isEmpty()) {
            // Modification
            programme = programmeDAO.findById(Long.parseLong(idParam));
            programme.setMatiere(matiereDAO.findById(Long.parseLong(matiereIdParam)));
            programme.setChapitre(chapitre);
            programme.setDescription(description);
            programme.setOrdre(Integer.parseInt(ordreParam));
        } else {
            // Création
            programme = new Programme(
                matiereDAO.findById(Long.parseLong(matiereIdParam)),
                chapitre,
                description,
                Integer.parseInt(ordreParam)
            );
        }
        
        programmeDAO.save(programme);
        response.sendRedirect("programmes");
    }
}