package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mg.universite.dao.EtudiantDAO;
import mg.universite.model.Etudiant;

import java.io.IOException;

@WebServlet("/etudiants")
public class EtudiantServlet extends HttpServlet {

    private EtudiantDAO etudiantDAO = new EtudiantDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        if ("delete".equals(action) && idParam != null) {
            Long id = Long.parseLong(idParam);
            etudiantDAO.delete(id);
            response.sendRedirect("etudiants"); // On recharge la liste après suppression
            return; // Très important pour arrêter l'exécution ici
        }
        // Si l'URL est /etudiants?action=new, on montre le formulaire
        if ("new".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/form-etudiant.jsp").forward(request, response);
        } else {
            // Sinon, on affiche la liste par défaut
            request.setAttribute("etudiants", etudiantDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/etudiants.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Récupérer les données du formulaire
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");

        // 2. Créer l'objet et l'enregistrer
        Etudiant nouvelEtudiant = new Etudiant(nom, prenom, email);
        etudiantDAO.save(nouvelEtudiant);

        // 3. Rediriger vers la liste pour voir le résultat
        response.sendRedirect("etudiants");
    }
}