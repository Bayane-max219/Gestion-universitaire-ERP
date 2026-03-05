package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mg.universite.dao.FiliereDAO;
import mg.universite.model.Filiere;
import mg.universite.model.User;
import mg.universite.security.SessionKeys;
import mg.universite.service.AuthService;

import java.io.IOException;

@WebServlet("/filieres")
public class FiliereServlet extends HttpServlet {

    private final FiliereDAO filiereDAO = new FiliereDAO();
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

        if ("delete".equals(action) && idParam != null && !idParam.isBlank()) {
            filiereDAO.delete(Long.parseLong(idParam));
            response.sendRedirect("filieres");
            return;
        }

        if ("new".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/form-filiere.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(action) && idParam != null && !idParam.isBlank()) {
            Filiere filiere = filiereDAO.findById(Long.parseLong(idParam));
            request.setAttribute("filiere", filiere);
            request.getRequestDispatcher("/WEB-INF/views/form-filiere.jsp").forward(request, response);
            return;
        }

        request.setAttribute("filieres", filiereDAO.findAll());
        request.getRequestDispatcher("/WEB-INF/views/filieres.jsp").forward(request, response);
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

        try {
            String idParam = request.getParameter("id");
            String code = request.getParameter("code");
            String nom = request.getParameter("nom");
            String description = request.getParameter("description");

            if (code == null || code.isBlank()) {
                throw new IllegalArgumentException("Code requis");
            }
            if (nom == null || nom.isBlank()) {
                throw new IllegalArgumentException("Nom requis");
            }

            if (idParam != null && !idParam.isBlank()) {
                Filiere existing = filiereDAO.findById(Long.parseLong(idParam));
                if (existing == null) {
                    throw new IllegalArgumentException("Filière introuvable");
                }
                existing.setCode(code.trim());
                existing.setNom(nom.trim());
                existing.setDescription(description);
                filiereDAO.update(existing);
            } else {
                Filiere f = new Filiere();
                f.setCode(code.trim());
                f.setNom(nom.trim());
                f.setDescription(description);
                filiereDAO.save(f);
            }

            response.sendRedirect("filieres");
        } catch (Exception e) {
            request.setAttribute("error", "Erreur: " + e.getMessage());
            request.getRequestDispatcher("/WEB-INF/views/form-filiere.jsp").forward(request, response);
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object obj = (session == null) ? null : session.getAttribute(SessionKeys.AUTH_USER);
        return (obj instanceof User) && authService.isAdmin((User) obj);
    }
}
