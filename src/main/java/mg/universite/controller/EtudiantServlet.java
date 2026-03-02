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
        
        if ("new".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/form-etudiant.jsp").forward(request, response);
        } else if ("edit".equals(action) && idParam != null) {
            Long id = Long.parseLong(idParam);
            Etudiant etudiant = etudiantDAO.findById(id);
            request.setAttribute("etudiant", etudiant);
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
        String idParam = request.getParameter("id");
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");
        String adresse = request.getParameter("adresse");
        String telephoneParent = request.getParameter("telephoneParent");

        if (idParam != null && !idParam.isEmpty()) {
            // Modification
            Etudiant etudiant = etudiantDAO.findById(Long.parseLong(idParam));
            etudiant.setNom(nom);
            etudiant.setPrenom(prenom);
            etudiant.setEmail(email);
            etudiant.setTelephone(telephone);
            etudiant.setAdresse(adresse);
            etudiant.setTelephoneParent(telephoneParent);
            etudiantDAO.save(etudiant);
        } else {
            // Création
            Etudiant nouvelEtudiant = new Etudiant(nom, prenom, email, telephone, adresse, telephoneParent);
            etudiantDAO.save(nouvelEtudiant);
        }

        // 3. Rediriger vers la liste pour voir le résultat
        response.sendRedirect("etudiants");
    }
}