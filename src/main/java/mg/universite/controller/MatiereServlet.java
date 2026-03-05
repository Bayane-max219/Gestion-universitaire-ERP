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
import java.util.ArrayList;
import java.util.HashSet;

@WebServlet("/matieres")
public class MatiereServlet extends HttpServlet {

    private MatiereDAO matiereDAO = new MatiereDAO();
    private ProfesseurDAO professeurDAO = new ProfesseurDAO();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if ("delete".equals(action) && idParam != null) {
            if (!isAdmin(request)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.setContentType("text/plain;charset=UTF-8");
                response.getWriter().write("Accès refusé: ADMIN requis");
                return;
            }
            Long id = Long.parseLong(idParam);
            matiereDAO.delete(id);
            response.sendRedirect("matieres");
            return;
        }

        if ("new".equals(action)) {
            if (!isAdmin(request)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.setContentType("text/plain;charset=UTF-8");
                response.getWriter().write("Accès refusé: ADMIN requis");
                return;
            }
            request.setAttribute("professeurs", professeurDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/form-matiere.jsp").forward(request, response);
        } else if ("edit".equals(action) && idParam != null) {
            if (!isAdmin(request)) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                response.setContentType("text/plain;charset=UTF-8");
                response.getWriter().write("Accès refusé: ADMIN requis");
                return;
            }
            Long id = Long.parseLong(idParam);
            var matiere = matiereDAO.findById(id);
            request.setAttribute("matiere", matiere);
            request.setAttribute("professeurs", professeurDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/form-matiere.jsp").forward(request, response);
        } else {
            String professeurIdParam = request.getParameter("professeurId");
            Long professeurId = null;
            if (professeurIdParam != null && !professeurIdParam.isBlank()) {
                try {
                    professeurId = Long.parseLong(professeurIdParam);
                } catch (Exception ignored) {
                    professeurId = null;
                }
            }

            var allMatieres = matiereDAO.findAll();
            var matieres = allMatieres;

            if (professeurId != null) {
                var filtered = new ArrayList<Matiere>();
                for (Matiere m : allMatieres) {
                    if (m.getProfesseurResponsable() != null
                            && m.getProfesseurResponsable().getId() != null
                            && professeurId.equals(m.getProfesseurResponsable().getId())) {
                        filtered.add(m);
                    }
                }
                matieres = filtered;
            }

            request.setAttribute("matieres", matieres);

            int totalCoefficients = 0;
            var profIds = new HashSet<Long>();
            for (Matiere m : matieres) {
                totalCoefficients += m.getCoefficient();
                if (m.getProfesseurResponsable() != null && m.getProfesseurResponsable().getId() != null) {
                    profIds.add(m.getProfesseurResponsable().getId());
                }
            }

            long totalInscriptions;
            var em = mg.universite.dao.JPAUtil.getEntityManager();
            try {
                if (professeurId == null) {
                    totalInscriptions = em.createQuery("SELECT COUNT(i) FROM Inscription i", Long.class)
                            .getSingleResult();
                } else {
                    totalInscriptions = em.createQuery(
                                    "SELECT COUNT(i) FROM Inscription i WHERE i.matiere.professeurResponsable.id = :pid",
                                    Long.class
                            )
                            .setParameter("pid", professeurId)
                            .getSingleResult();
                }
            } finally {
                em.close();
            }

            request.setAttribute("totalCoefficients", totalCoefficients);
            request.setAttribute("uniqueProfessors", profIds.size());
            request.setAttribute("totalInscriptions", totalInscriptions);
            request.getRequestDispatcher("/WEB-INF/views/matieres.jsp").forward(request, response);
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
        int coef = Integer.parseInt(request.getParameter("coefficient"));
        String professeurIdParam = request.getParameter("professeurId");

        if (idParam != null && !idParam.isEmpty()) {
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

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object obj = (session == null) ? null : session.getAttribute(SessionKeys.AUTH_USER);
        return (obj instanceof User) && authService.isAdmin((User) obj);
    }
}
