package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mg.universite.model.User;
import mg.universite.security.SessionKeys;
import mg.universite.service.AuthService;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    public void init() {
        authService.bootstrapIfNeeded();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = authService.authenticate(username, password);
        if (user == null) {
            request.setAttribute("error", "Identifiants invalides");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
            return;
        }

        HttpSession session = request.getSession(true);
        session.setAttribute(SessionKeys.AUTH_USER, user);

        response.sendRedirect(request.getContextPath() + "/etudiants");
    }
}
