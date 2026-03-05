package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mg.universite.dao.AdminInscriptionDAO;
import mg.universite.dao.EtudiantDAO;
import mg.universite.dao.NotificationDAO;
import mg.universite.model.Notification;
import mg.universite.model.User;
import mg.universite.security.SessionKeys;

import java.io.IOException;
import java.util.HashSet;
import java.util.List;

@WebServlet("/notifications")
public class NotificationsServlet extends HttpServlet {

    private final NotificationDAO notificationDAO = new NotificationDAO();
    private final EtudiantDAO etudiantDAO = new EtudiantDAO();
    private final AdminInscriptionDAO adminInscriptionDAO = new AdminInscriptionDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Object obj = (session == null) ? null : session.getAttribute(SessionKeys.AUTH_USER);

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        List<Notification> notifications = java.util.List.of();

        // Admin can see all notifications, students see their notifications
        if (obj instanceof User u) {
            if (u.getRole() != null && "ADMIN".equalsIgnoreCase(u.getRole().getName())) {
                if ("view".equalsIgnoreCase(action) && idParam != null && !idParam.isBlank()) {
                    try {
                        notificationDAO.markAsRead(Long.parseLong(idParam.trim()), null);
                    } catch (Exception ignored) {
                    }
                    response.sendRedirect(request.getContextPath() + "/notifications");
                    return;
                }
                notifications = notificationDAO.findAll();
                request.setAttribute("etudiants", etudiantDAO.findAll());
                request.setAttribute("allInscriptions", adminInscriptionDAO.findAll());
            } else {
                // Assumption: username == etudiant.email
                Long etudiantId = etudiantDAO.findIdByEmail(u.getUsername());
                if (etudiantId != null) {
                    if ("view".equalsIgnoreCase(action) && idParam != null && !idParam.isBlank()) {
                        try {
                            notificationDAO.markAsRead(Long.parseLong(idParam.trim()), etudiantId);
                        } catch (Exception ignored) {
                        }
                        response.sendRedirect(request.getContextPath() + "/notifications");
                        return;
                    }
                    notifications = notificationDAO.findByEtudiantId(etudiantId);
                }
            }
        }

        int unreadCount = 0;
        int readCount = 0;
        var inscriptionIds = new HashSet<Long>();
        for (Notification n : notifications) {
            if (n.isReadFlag()) {
                readCount++;
            } else {
                unreadCount++;
            }
            if (n.getInscription() != null && n.getInscription().getId() != null) {
                inscriptionIds.add(n.getInscription().getId());
            }
        }

        request.setAttribute("notifications", notifications);
        request.setAttribute("unreadCount", unreadCount);
        request.setAttribute("readCount", readCount);
        request.setAttribute("relatedInscriptionsCount", inscriptionIds.size());

        request.getRequestDispatcher("/WEB-INF/views/notifications.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Object obj = (session == null) ? null : session.getAttribute(SessionKeys.AUTH_USER);
        if (!(obj instanceof User u) || u.getRole() == null || !"ADMIN".equalsIgnoreCase(u.getRole().getName())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        try {
            String etudiantIdParam = request.getParameter("etudiantId");
            String inscriptionIdParam = request.getParameter("inscriptionId");
            String message = request.getParameter("message");
            if (message == null || message.isBlank()) {
                throw new IllegalArgumentException("Message requis");
            }

            if (etudiantIdParam != null && !etudiantIdParam.isBlank()) {
                Long etudiantId = Long.parseLong(etudiantIdParam.trim());
                notificationDAO.createForEtudiant(etudiantId, message.trim());
            } else if (inscriptionIdParam != null && !inscriptionIdParam.isBlank()) {
                Long inscriptionId = Long.parseLong(inscriptionIdParam.trim());
                notificationDAO.createForInscription(inscriptionId, message.trim());
            } else {
                throw new IllegalArgumentException("Étudiant requis");
            }
            response.sendRedirect(request.getContextPath() + "/notifications");
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            doGet(request, response);
        }
    }
}
