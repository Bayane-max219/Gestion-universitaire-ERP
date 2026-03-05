package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mg.universite.dao.EtudiantDAO;
import mg.universite.dao.MatiereDAO;
import mg.universite.dao.TranchePaiementDAO;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.YearMonth;
import java.util.Locale;

@WebServlet("/inscriptions")
public class InscriptionServlet extends HttpServlet {
    private EtudiantDAO etudiantDAO = new EtudiantDAO();
    private MatiereDAO matiereDAO = new MatiereDAO();

    private static YearMonth parseMoisDepart(String moisDepartParam) {
        if (moisDepartParam == null || moisDepartParam.isBlank()) {
            return YearMonth.now();
        }
        String raw = moisDepartParam.trim();
        try {
            return YearMonth.parse(raw);
        } catch (DateTimeParseException ignored) {
        }
        try {
            return YearMonth.parse(raw, DateTimeFormatter.ofPattern("yyyy-MM"));
        } catch (DateTimeParseException ignored) {
        }
        return YearMonth.parse(raw, DateTimeFormatter.ofPattern("MMMM uuuu", Locale.FRENCH));
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("new".equals(action)) {
            request.setAttribute("etudiants", etudiantDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/form-inscription.jsp").forward(request, response);
        } else {
            // Afficher la liste des inscriptions
            request.getRequestDispatcher("/WEB-INF/views/inscriptions.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String etudiantIdParam = request.getParameter("etudiantId");
            String fraisAnnuelParam = request.getParameter("fraisAnnuel");
            String nombreTranchesParam = request.getParameter("nombreTranches");

            if (etudiantIdParam == null || etudiantIdParam.isBlank()) {
                throw new IllegalArgumentException("Étudiant requis");
            }
            if (fraisAnnuelParam == null || fraisAnnuelParam.isBlank()) {
                throw new IllegalArgumentException("Frais annuel requis");
            }
            if (nombreTranchesParam == null || nombreTranchesParam.isBlank()) {
                throw new IllegalArgumentException("Nombre de tranches requis");
            }

            Long etudiantId = Long.parseLong(etudiantIdParam.trim());
            BigDecimal fraisAnnuel = new BigDecimal(fraisAnnuelParam.trim());
            int nombreTranches = Integer.parseInt(nombreTranchesParam.trim());
            YearMonth moisDepart = parseMoisDepart(request.getParameter("moisDepart"));

            new TranchePaiementDAO().createEcheancierForEtudiant(
                    etudiantId,
                    fraisAnnuel.doubleValue(),
                    nombreTranches,
                    5,
                    moisDepart
            );

            response.sendRedirect(request.getContextPath() + "/admin/paiements");
        } catch (Exception e) {
            request.getSession(true).setAttribute("flashError", e.getMessage());
            response.sendRedirect(request.getContextPath() + "/inscriptions?action=new&error=1");
        }
    }
}