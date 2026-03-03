package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mg.universite.dao.EtudiantDAO;
import mg.universite.dao.InscriptionDAO;
import mg.universite.dao.MatiereDAO;
import mg.universite.service.PaiementService;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;

@WebServlet("/inscriptions")
public class InscriptionServlet extends HttpServlet {
    private EtudiantDAO etudiantDAO = new EtudiantDAO();
    private MatiereDAO matiereDAO = new MatiereDAO();
    // Tu auras besoin d'un InscriptionDAO (à créer sur le même modèle que les autres)
    private final PaiementService paiementService = new PaiementService();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("new".equals(action)) {
            request.setAttribute("etudiants", etudiantDAO.findAll());
            request.setAttribute("matieres", matiereDAO.findAll());
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
            Long etudiantId = Long.parseLong(request.getParameter("etudiantId"));
            Long matiereId = Long.parseLong(request.getParameter("matiereId"));

            InscriptionDAO inscriptionDAO = new InscriptionDAO();
            var ins = inscriptionDAO.save(etudiantId, matiereId);

            if (ins != null) {
                String montantParam = request.getParameter("montantTranche");
                String dateEcheanceParam = request.getParameter("dateEcheance");
                String referenceParam = request.getParameter("referencePaiement");

                if (montantParam != null && !montantParam.isBlank()) {
                    BigDecimal montant = new BigDecimal(montantParam.trim());
                    LocalDate dateEcheance = (dateEcheanceParam == null || dateEcheanceParam.isBlank())
                            ? null
                            : LocalDate.parse(dateEcheanceParam.trim());
                    String reference = (referenceParam == null) ? null : referenceParam.trim();
                    paiementService.creerTranchePourInscription(ins.getId(), montant, dateEcheance, reference);
                }
            }

            // On redirige vers la liste des étudiants (ou des inscriptions si tu as la vue)
            response.sendRedirect("etudiants");
        } catch (Exception e) {
            e.printStackTrace();

            response.sendRedirect("inscriptions?action=new&error=1");
        }
    }
}