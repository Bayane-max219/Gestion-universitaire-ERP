package mg.universite.security;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mg.universite.dao.EtudiantDAO;
import mg.universite.model.User;
import mg.universite.service.PaiementService;

import java.io.IOException;

@WebFilter(urlPatterns = {"/notes", "/emplois-du-temps"})
public class PaiementFilter implements Filter {

    private final PaiementService paiementService = new PaiementService();
    private final EtudiantDAO etudiantDAO = new EtudiantDAO();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        Object obj = (session == null) ? null : session.getAttribute(SessionKeys.AUTH_USER);

        if (!(obj instanceof User u)) {
            chain.doFilter(request, response);
            return;
        }

        // Admin is not restricted
        if (u.getRole() != null && "ADMIN".equalsIgnoreCase(u.getRole().getName())) {
            chain.doFilter(request, response);
            return;
        }

        // Assumption: username == etudiant.email
        Long etudiantId = etudiantDAO.findIdByEmail(u.getUsername());
        if (etudiantId == null) {
            // If no matching student, don't block.
            chain.doFilter(request, response);
            return;
        }

        if (!paiementService.etudiantEstEnRegle(etudiantId)) {
            resp.sendRedirect(req.getContextPath() + "/notifications");
            return;
        }

        chain.doFilter(request, response);
    }
}
