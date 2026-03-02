package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mg.universite.dao.MatiereDAO;
import mg.universite.dao.ProfesseurDAO;
import mg.universite.model.Matiere;
import mg.universite.model.Professeur;

import java.io.IOException;

@WebServlet("/matieres")
public class MatiereServlet extends HttpServlet {

    private MatiereDAO matiereDAO = new MatiereDAO();
    private ProfesseurDAO professeurDAO = new ProfesseurDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        if ("delete".equals(action) && idParam != null) {
            Long id = Long.parseLong(idParam);
            matiereDAO.delete(id);
            response.sendRedirect("matieres");
            return;
        }

        if ("new".equals(action)) {
            request.setAttribute("professeurs", professeurDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/form-matiere.jsp").forward(request, response);
        } else if ("edit".equals(action) && idParam != null) {
            Long id = Long.parseLong(idParam);
            var matiere = matiereDAO.findById(id);
            request.setAttribute("matiere", matiere);
            request.setAttribute("professeurs", professeurDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/form-matiere.jsp").forward(request, response);
        } else {
            request.setAttribute("matieres", matiereDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/matieres.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String nom = request.getParameter("nom");
        int coef = Integer.parseInt(request.getParameter("coefficient"));
        String professeurIdParam = request.getParameter("professeurId");

        if (idParam != null && !idParam.isEmpty()) {
            // Modification
            Matiere matiere = matiereDAO.findById(Long.parseLong(idParam));
            matiere.setNom(nom);
            matiere.setCoefficient(coef);
            
            if (professeurIdParam != null && !professeurIdParam.isEmpty()) {
                Professeur professeur = professeurDAO.findById(Long.parseLong(professeurIdParam));
                matiere.setProfesseurResponsable(professeur);
            } else {
                matiere.setProfesseurResponsable(null);
            }
            
            matiereDAO.save(matiere);
        } else {
            // Création
            Matiere m;
            if (professeurIdParam != null && !professeurIdParam.isEmpty()) {
                Professeur professeur = professeurDAO.findById(Long.parseLong(professeurIdParam));
                m = new Matiere(nom, coef, professeur);
            } else {
                m = new Matiere(nom, coef);
            }
            matiereDAO.save(m);
        }

        response.sendRedirect("matieres");
    }
}