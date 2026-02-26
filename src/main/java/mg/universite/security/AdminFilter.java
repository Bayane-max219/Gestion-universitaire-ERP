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
import mg.universite.model.User;
import mg.universite.service.AuthService;

import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {

    private final AuthService authService = new AuthService();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        Object obj = (session == null) ? null : session.getAttribute(SessionKeys.AUTH_USER);

        if (!(obj instanceof User)) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) obj;
        if (!authService.isAdmin(user)) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.setContentType("text/plain;charset=UTF-8");
            resp.getWriter().write("Accès refusé: ADMIN requis");
            return;
        }

        chain.doFilter(request, response);
    }
}
