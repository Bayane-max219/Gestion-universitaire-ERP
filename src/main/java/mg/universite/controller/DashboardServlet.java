package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mg.universite.model.User;
import mg.universite.security.SessionKeys;
import mg.universite.service.EtudiantService;
import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    
    private final EtudiantService etudiantService = new EtudiantService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute(SessionKeys.AUTH_USER);
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Vérifier si c'est un admin ou un étudiant
        if (isAdmin(user)) {
            // Dashboard admin
            request.getRequestDispatcher("/WEB-INF/views/admin-dashboard.jsp").forward(request, response);
        } else {
            // Dashboard étudiant
            String email = user.getUsername();
            var etudiant = etudiantService.findByEmail(email);
            if (etudiant != null) {
                request.setAttribute("etudiant", etudiant);
                request.getRequestDispatcher("/WEB-INF/views/etudiant-dashboard.jsp").forward(request, response);
            } else {
                // Redirection vers login si étudiant non trouvé
                response.sendRedirect(request.getContextPath() + "/login");
            }
        }
    }
    
    private boolean isAdmin(User user) {
        return user != null && user.getRole() != null && user.getRole().getId() == 1L;
    }
}