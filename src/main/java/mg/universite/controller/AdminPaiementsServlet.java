package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mg.universite.dao.TranchePaiementDAO;

import java.io.IOException;

@WebServlet("/admin/paiements")
public class AdminPaiementsServlet extends HttpServlet {

    private final TranchePaiementDAO tranchePaiementDAO = new TranchePaiementDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if (action != null && idParam != null && !idParam.isBlank()) {
            try {
                Long id = Long.parseLong(idParam);
                if ("valider".equalsIgnoreCase(action)) {
                    // Validation de paiement simplifiée
                    // TODO: Implémenter la validation dans TranchePaiementDAO
                }
                response.sendRedirect(request.getContextPath() + "/admin/paiements");
                return;
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage());
            }
        }

        request.setAttribute("tranches", tranchePaiementDAO.findAll());
        request.getRequestDispatcher("/WEB-INF/views/admin-paiements.jsp").forward(request, response);
    }
}
