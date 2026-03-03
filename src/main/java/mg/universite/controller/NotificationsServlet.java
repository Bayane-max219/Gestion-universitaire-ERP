package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mg.universite.dao.EtudiantDAO;
import mg.universite.dao.NotificationDAO;
import mg.universite.model.User;
import mg.universite.security.SessionKeys;

import java.io.IOException;

@WebServlet("/notifications")
public class NotificationsServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final EtudiantDAO etudiantDAO = new EtudiantDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object obj = (session == null) ? null : session.getAttribute(SessionKeys.AUTH_USER);

        // Admin can see all notifications, students see their notifications
        if (obj instanceof User u) {
            if (u.getRole() != null && "ADMIN".equalsIgnoreCase(u.getRole().getName())) {
                request.setAttribute("notifications", notificationDAO.findAll());
            } else {
                // Assumption: username == etudiant.email
                Long etudiantId = etudiantDAO.findIdByEmail(u.getUsername());
                if (etudiantId != null) {
                    request.setAttribute("notifications", notificationDAO.findByEtudiantId(etudiantId));
                } else {
                    request.setAttribute("notifications", java.util.List.of());
                }
            }
        }

        request.getRequestDispatcher("/WEB-INF/views/notifications.jsp").forward(request, response);
    }
}
