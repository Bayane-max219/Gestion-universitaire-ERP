package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mg.universite.dao.ProfesseurDAO;
import mg.universite.model.Professeur;

import java.io.IOException;
import java.util.List;

@WebServlet("/professeurs")
public class ProfesseurServlet extends HttpServlet {

    private ProfesseurDAO professeurDAO = new ProfesseurDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        if ("delete".equals(action) && idParam != null) {
            Long id = Long.parseLong(idParam);
            professeurDAO.delete(id);
            response.sendRedirect("professeurs");
            return;
        }
        
        if ("new".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/form-professeur.jsp").forward(request, response);
        } else if ("edit".equals(action) && idParam != null) {
            Long id = Long.parseLong(idParam);
            Professeur professeur = professeurDAO.findById(id);
            request.setAttribute("professeur", professeur);
            request.getRequestDispatcher("/WEB-INF/views/form-professeur.jsp").forward(request, response);
        } else {
            List<Professeur> professeurs = professeurDAO.findAll();
            request.setAttribute("professeurs", professeurs);
            request.getRequestDispatcher("/WEB-INF/views/professeurs.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");

        Professeur professeur;
        
        if (idParam != null && !idParam.isEmpty()) {
            // Modification
            professeur = professeurDAO.findById(Long.parseLong(idParam));
            professeur.setNom(nom);
            professeur.setPrenom(prenom);
            professeur.setEmail(email);
            professeur.setTelephone(telephone);
        } else {
            // Création
            professeur = new Professeur(nom, prenom, email, telephone);
        }
        
        professeurDAO.save(professeur);
        response.sendRedirect("professeurs");
    }
}