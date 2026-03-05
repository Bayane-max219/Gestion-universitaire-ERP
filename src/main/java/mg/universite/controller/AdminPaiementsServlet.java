package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mg.universite.dao.TranchePaiementDAO;
import mg.universite.model.Etudiant;
import mg.universite.model.StatutTranche;
import mg.universite.model.TranchePaiement;

import java.io.IOException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/admin/paiements")
public class AdminPaiementsServlet extends HttpServlet {

    private final TranchePaiementDAO tranchePaiementDAO = new TranchePaiementDAO();

    public static class PaiementSynthese {
        private Long etudiantId;
        private String numeroEtudiant;
        private String nom;
        private String prenom;
        private String email;
        private double totalDu;
        private double totalPaye;
        private double resteAPayer;
        private int totalTranches;
        private int tranchesEnRetard;

        public Long getEtudiantId() { return etudiantId; }
        public void setEtudiantId(Long etudiantId) { this.etudiantId = etudiantId; }
        public String getNumeroEtudiant() { return numeroEtudiant; }
        public void setNumeroEtudiant(String numeroEtudiant) { this.numeroEtudiant = numeroEtudiant; }
        public String getNom() { return nom; }
        public void setNom(String nom) { this.nom = nom; }
        public String getPrenom() { return prenom; }
        public void setPrenom(String prenom) { this.prenom = prenom; }
        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }
        public double getTotalDu() { return totalDu; }
        public void setTotalDu(double totalDu) { this.totalDu = totalDu; }
        public double getTotalPaye() { return totalPaye; }
        public void setTotalPaye(double totalPaye) { this.totalPaye = totalPaye; }
        public double getResteAPayer() { return resteAPayer; }
        public void setResteAPayer(double resteAPayer) { this.resteAPayer = resteAPayer; }
        public int getTotalTranches() { return totalTranches; }
        public void setTotalTranches(int totalTranches) { this.totalTranches = totalTranches; }
        public int getTranchesEnRetard() { return tranchesEnRetard; }
        public void setTranchesEnRetard(int tranchesEnRetard) { this.tranchesEnRetard = tranchesEnRetard; }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if (action != null && idParam != null && !idParam.isBlank()) {
            try {
                Long id = Long.parseLong(idParam);
                if ("valider".equalsIgnoreCase(action)) {
                    response.sendRedirect(request.getContextPath() + "/admin/paiements");
                    return;
                }
                response.sendRedirect(request.getContextPath() + "/admin/paiements");
                return;
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage());
            }
        }

        tranchePaiementDAO.markRetards(LocalDate.now());

        List<TranchePaiement> tranches = tranchePaiementDAO.findAll();
        int totalTranches = tranches.size();
        int payeesCount = 0;
        int nonPayeesCount = 0;
        int retardCount = 0;
        for (TranchePaiement t : tranches) {
            StatutTranche st = (t == null) ? null : t.getStatut();
            if (st == StatutTranche.PAYEE) {
                payeesCount++;
            } else if (st == StatutTranche.EN_RETARD) {
                retardCount++;
                nonPayeesCount++;
            } else if (st == StatutTranche.A_PAYER) {
                nonPayeesCount++;
            }
        }

        Map<Long, PaiementSynthese> syntheseMap = new LinkedHashMap<>();
        for (TranchePaiement t : tranches) {
            Etudiant e = (t == null) ? null : t.getEtudiant();
            if (e == null && t != null && t.getInscription() != null) {
                e = t.getInscription().getEtudiant();
            }
            if (e == null || e.getId() == null) {
                continue;
            }

            PaiementSynthese s = syntheseMap.get(e.getId());
            if (s == null) {
                s = new PaiementSynthese();
                s.setEtudiantId(e.getId());
                s.setNumeroEtudiant(e.getNumeroEtudiant());
                s.setNom(e.getNom());
                s.setPrenom(e.getPrenom());
                s.setEmail(e.getEmail());
                syntheseMap.put(e.getId(), s);
            }

            double m = (t.getMontant() == null) ? 0d : t.getMontant();
            s.setTotalDu(s.getTotalDu() + m);
            s.setTotalTranches(s.getTotalTranches() + 1);

            StatutTranche st = t.getStatut();
            if (st == StatutTranche.PAYEE) {
                s.setTotalPaye(s.getTotalPaye() + m);
            } else if (st == StatutTranche.EN_RETARD) {
                s.setTranchesEnRetard(s.getTranchesEnRetard() + 1);
            }
        }

        List<PaiementSynthese> syntheses = new ArrayList<>(syntheseMap.values());
        for (PaiementSynthese s : syntheses) {
            s.setResteAPayer(Math.max(0d, s.getTotalDu() - s.getTotalPaye()));
        }

        request.setAttribute("tranches", tranches);
        request.setAttribute("syntheses", syntheses);
        request.setAttribute("totalTranches", totalTranches);
        request.setAttribute("payeesCount", payeesCount);
        request.setAttribute("nonPayeesCount", nonPayeesCount);
        request.setAttribute("retardCount", retardCount);
        request.getRequestDispatcher("/WEB-INF/views/admin-paiements.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/admin/paiements");
            return;
        }

        if ("valider".equalsIgnoreCase(action)) {
            try {
                String idParam = request.getParameter("id");
                if (idParam == null || idParam.isBlank()) {
                    throw new IllegalArgumentException("ID tranche requis");
                }
                Long id = Long.parseLong(idParam);

                String reference = request.getParameter("reference");
                String datePaiementParam = request.getParameter("datePaiement");
                LocalDate datePaiement = (datePaiementParam == null || datePaiementParam.isBlank())
                        ? LocalDate.now()
                        : LocalDate.parse(datePaiementParam.trim());

                tranchePaiementDAO.markPayee(id, reference, datePaiement);
                response.sendRedirect(request.getContextPath() + "/admin/paiements");
                return;
            } catch (Exception e) {
                request.setAttribute("error", e.getMessage());
                doGet(request, response);
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/paiements");
    }
}
