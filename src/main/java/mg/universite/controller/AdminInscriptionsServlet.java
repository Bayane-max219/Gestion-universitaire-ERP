package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mg.universite.dao.EtudiantDAO;
import mg.universite.dao.TranchePaiementDAO;
import mg.universite.model.Etudiant;
import mg.universite.model.StatutTranche;
import mg.universite.model.TranchePaiement;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.List;
import java.util.Locale;
import java.util.stream.Collectors;

@WebServlet("/admin/inscriptions")
public class AdminInscriptionsServlet extends HttpServlet {

    private final EtudiantDAO etudiantDAO = new EtudiantDAO();
    private final TranchePaiementDAO tranchePaiementDAO = new TranchePaiementDAO();

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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Etudiant> etudiants = etudiantDAO.findAll();
        request.setAttribute("etudiants", etudiants);

        tranchePaiementDAO.markRetards(LocalDate.now());

        Etudiant selectedEtudiant = null;
        List<TranchePaiement> tranchesEtudiant = List.of();
        double totalDu = 0d;
        double totalPaye = 0d;
        double resteAPayer = 0d;
        int retardCount = 0;

        String etudiantIdParam = request.getParameter("etudiantId");
        if (etudiantIdParam != null && !etudiantIdParam.isBlank()) {
            try {
                Long etudiantId = Long.parseLong(etudiantIdParam.trim());
                selectedEtudiant = etudiants.stream()
                        .filter(e -> e != null && e.getId() != null && e.getId().equals(etudiantId))
                        .findFirst()
                        .orElse(null);

                List<TranchePaiement> all = tranchePaiementDAO.findAll();
                tranchesEtudiant = all.stream()
                        .filter(t -> {
                            if (t == null) return false;
                            if (t.getEtudiant() != null && t.getEtudiant().getId() != null) {
                                return t.getEtudiant().getId().equals(etudiantId);
                            }
                            if (t.getInscription() != null && t.getInscription().getEtudiant() != null
                                    && t.getInscription().getEtudiant().getId() != null) {
                                return t.getInscription().getEtudiant().getId().equals(etudiantId);
                            }
                            return false;
                        })
                        .collect(Collectors.toList());

                for (TranchePaiement t : tranchesEtudiant) {
                    double m = (t.getMontant() == null) ? 0d : t.getMontant();
                    totalDu += m;
                    if (t.getStatut() == StatutTranche.PAYEE) {
                        totalPaye += m;
                    } else if (t.getStatut() == StatutTranche.EN_RETARD) {
                        retardCount++;
                    }
                }
                resteAPayer = Math.max(0d, totalDu - totalPaye);
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage());
            }
        }

        String flashError = (String) request.getSession(true).getAttribute("flashError");
        if (flashError != null && !flashError.isBlank()) {
            request.setAttribute("error", flashError);
            request.getSession(true).removeAttribute("flashError");
        }
        String flashSuccess = (String) request.getSession(true).getAttribute("flashSuccess");
        if (flashSuccess != null && !flashSuccess.isBlank()) {
            request.setAttribute("success", flashSuccess);
            request.getSession(true).removeAttribute("flashSuccess");
        }

        request.setAttribute("selectedEtudiant", selectedEtudiant);
        request.setAttribute("tranchesEtudiant", tranchesEtudiant);
        request.setAttribute("totalDu", totalDu);
        request.setAttribute("totalPaye", totalPaye);
        request.setAttribute("resteAPayer", resteAPayer);
        request.setAttribute("retardCount", retardCount);
        request.getRequestDispatcher("/WEB-INF/views/admin-inscriptions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if (action == null || action.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/admin/inscriptions");
                return;
            }

            if ("createEcheancier".equalsIgnoreCase(action)) {
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

                tranchePaiementDAO.createEcheancierForEtudiant(
                        etudiantId,
                        fraisAnnuel.doubleValue(),
                        nombreTranches,
                        5,
                        moisDepart
                );
                request.getSession(true).setAttribute("flashSuccess", "Échéancier créé");
                response.sendRedirect(request.getContextPath() + "/admin/inscriptions?etudiantId=" + etudiantId);
                return;
            }

            if ("validerPaiement".equalsIgnoreCase(action)) {
                String trancheIdParam = request.getParameter("id");
                if (trancheIdParam == null || trancheIdParam.isBlank()) {
                    throw new IllegalArgumentException("ID tranche requis");
                }
                Long trancheId = Long.parseLong(trancheIdParam.trim());
                String reference = request.getParameter("reference");
                String datePaiementParam = request.getParameter("datePaiement");
                LocalDate datePaiement = (datePaiementParam == null || datePaiementParam.isBlank())
                        ? LocalDate.now()
                        : LocalDate.parse(datePaiementParam.trim());

                tranchePaiementDAO.markPayee(trancheId, reference, datePaiement);

                String etudiantIdReturn = request.getParameter("etudiantIdReturn");
                if (etudiantIdReturn != null && !etudiantIdReturn.isBlank()) {
                    response.sendRedirect(request.getContextPath() + "/admin/inscriptions?etudiantId=" + etudiantIdReturn.trim());
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/inscriptions");
                }
                return;
            }

            response.sendRedirect(request.getContextPath() + "/admin/inscriptions");
        } catch (Exception e) {
            request.getSession(true).setAttribute("flashError", e.getMessage());
            String etudiantIdReturn = request.getParameter("etudiantId");
            if (etudiantIdReturn == null || etudiantIdReturn.isBlank()) {
                etudiantIdReturn = request.getParameter("etudiantIdReturn");
            }
            if (etudiantIdReturn != null && !etudiantIdReturn.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/admin/inscriptions?etudiantId=" + etudiantIdReturn.trim());
            } else {
                response.sendRedirect(request.getContextPath() + "/admin/inscriptions");
            }
        }
    }
}