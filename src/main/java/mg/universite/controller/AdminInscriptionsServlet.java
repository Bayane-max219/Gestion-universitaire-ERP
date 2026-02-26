package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mg.universite.dao.AdminInscriptionDAO;
import mg.universite.model.StatutInscription;
import mg.universite.service.WorkflowService;

import java.io.IOException;

@WebServlet("/admin/inscriptions")
public class AdminInscriptionsServlet extends HttpServlet {

    private final AdminInscriptionDAO adminInscriptionDAO = new AdminInscriptionDAO();
    private final WorkflowService workflowService = new WorkflowService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if (action != null && idParam != null && !idParam.isBlank()) {
            try {
                Long id = Long.parseLong(idParam);
                if ("valider".equalsIgnoreCase(action)) {
                    workflowService.validerInscription(id);
                } else if ("annuler".equalsIgnoreCase(action)) {
                    workflowService.annulerInscription(id);
                }
                response.sendRedirect(request.getContextPath() + "/admin/inscriptions");
                return;
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage());
            }
        }

        request.setAttribute("statutEnCours", StatutInscription.EN_COURS.name());
        request.setAttribute("inscriptions", adminInscriptionDAO.findAll());
        request.getRequestDispatcher("/WEB-INF/views/admin-inscriptions.jsp").forward(request, response);
    }
}
