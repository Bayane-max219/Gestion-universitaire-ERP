package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mg.universite.dao.MatiereDAO;
import mg.universite.dao.ProfesseurDAO;
import mg.universite.model.Matiere;
import mg.universite.model.Professeur;
import mg.universite.model.User;
import mg.universite.security.SessionKeys;
import mg.universite.service.AuthService;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/professeurs")
public class ProfesseurServlet extends HttpServlet {

    private ProfesseurDAO professeurDAO = new ProfesseurDAO();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("Accès refusé: ADMIN requis");
            return;
        }

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

            Map<Long, Integer> matieresParProf = new HashMap<>();
            int totalMatieresAssignees = 0;
            MatiereDAO matiereDAO = new MatiereDAO();
            for (Matiere m : matiereDAO.findAll()) {
                if (m.getProfesseurResponsable() != null && m.getProfesseurResponsable().getId() != null) {
                    Long pid = m.getProfesseurResponsable().getId();
                    int next = matieresParProf.getOrDefault(pid, 0) + 1;
                    matieresParProf.put(pid, next);
                    totalMatieresAssignees++;
                }
            }

            request.setAttribute("matieresParProf", matieresParProf);
            request.setAttribute("totalMatieresAssignees", totalMatieresAssignees);
            request.setAttribute("totalEmploisDuTemps", 0);
            request.setAttribute("totalHeuresEns", 0);
            request.getRequestDispatcher("/WEB-INF/views/professeurs.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("Accès refusé: ADMIN requis");
            return;
        }

        String idParam = request.getParameter("id");
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String telephone = request.getParameter("telephone");

        Professeur professeur;

        if (idParam != null && !idParam.isEmpty()) {
            professeur = professeurDAO.findById(Long.parseLong(idParam));
            professeur.setNom(nom);
            professeur.setPrenom(prenom);
            professeur.setEmail(email);
            professeur.setTelephone(telephone);
        } else {
            professeur = new Professeur(nom, prenom, email, telephone);
        }

        professeurDAO.save(professeur);
        response.sendRedirect("professeurs");
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object obj = (session == null) ? null : session.getAttribute(SessionKeys.AUTH_USER);
        return (obj instanceof User) && authService.isAdmin((User) obj);
    }
}