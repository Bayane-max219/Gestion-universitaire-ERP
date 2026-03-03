package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mg.universite.model.Etudiant;
import mg.universite.model.Filiere;
import mg.universite.model.Niveau;
import mg.universite.service.EtudiantService;
import java.io.IOException;

@WebServlet("/etudiants")
public class EtudiantServlet extends HttpServlet {
    
    private final EtudiantService etudiantService = new EtudiantService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String idParam = request.getParameter("id");
        
        if ("new".equals(action)) {
            // Formulaire de création
            request.setAttribute("filieres", etudiantService.getAllFilieres());
            request.getRequestDispatcher("/WEB-INF/views/form-etudiant.jsp").forward(request, response);
        } else if ("edit".equals(action) && idParam != null) {
            // Formulaire d'édition
            Long id = Long.parseLong(idParam);
            // TODO: Récupérer l'étudiant par ID
            request.setAttribute("filieres", etudiantService.getAllFilieres());
            request.getRequestDispatcher("/WEB-INF/views/form-etudiant.jsp").forward(request, response);
        } else {
            // Liste des étudiants
            // TODO: Récupérer tous les étudiants
            request.getRequestDispatcher("/WEB-INF/views/etudiants.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if (action == null || "create".equals(action)) {
            // Création d'un nouvel étudiant
            try {
                Etudiant etudiant = new Etudiant();
                etudiant.setNom(request.getParameter("nom"));
                etudiant.setPrenom(request.getParameter("prenom"));
                etudiant.setEmail(request.getParameter("email"));
                etudiant.setTelephone(request.getParameter("telephone"));
                etudiant.setAdresse(request.getParameter("adresse"));
                etudiant.setTelephoneParent(request.getParameter("telephoneParent"));
                
                // Niveau
                String niveauParam = request.getParameter("niveau");
                if (niveauParam != null && !niveauParam.isEmpty()) {
                    etudiant.setNiveau(Niveau.fromString(niveauParam));
                }
                
                // Filière
                String filiereIdParam = request.getParameter("filiereId");
                if (filiereIdParam != null && !filiereIdParam.isEmpty()) {
                    // TODO: Récupérer la filière par ID
                    Filiere filiere = new Filiere();
                    filiere.setId(Long.parseLong(filiereIdParam));
                    etudiant.setFiliere(filiere);
                }
                
                etudiantService.createEtudiant(etudiant);
                response.sendRedirect(request.getContextPath() + "/etudiants");
                
            } catch (Exception e) {
                request.setAttribute("error", "Erreur lors de la création de l'étudiant: " + e.getMessage());
                request.setAttribute("filieres", etudiantService.getAllFilieres());
                request.getRequestDispatcher("/WEB-INF/views/form-etudiant.jsp").forward(request, response);
            }
        }
        // TODO: Implémenter update et delete
    }
}