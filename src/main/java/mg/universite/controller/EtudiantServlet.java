package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import mg.universite.model.Etudiant;
import mg.universite.model.Filiere;
import mg.universite.model.Niveau;
import mg.universite.model.User;
import mg.universite.security.SessionKeys;
import mg.universite.service.AuthService;
import mg.universite.service.EtudiantService;

import java.io.IOException;

@WebServlet("/etudiants")
public class EtudiantServlet extends HttpServlet {

    private final EtudiantService etudiantService = new EtudiantService();
    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("Accès refusé: ADMIN requis");
            return;
        }

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if ("new".equals(action)) {
            request.setAttribute("filieres", etudiantService.getAllFilieres());
            request.getRequestDispatcher("/WEB-INF/views/form-etudiant.jsp").forward(request, response);
        } else if ("edit".equals(action) && idParam != null) {
            try {
                Long id = Long.parseLong(idParam);
                Etudiant etudiant = etudiantService.findById(id);
                if (etudiant == null) {
                    request.getSession(true).setAttribute("flashError", "Étudiant introuvable");
                    response.sendRedirect(request.getContextPath() + "/etudiants");
                    return;
                }
                request.setAttribute("etudiant", etudiant);
            } catch (Exception e) {
                request.getSession(true).setAttribute("flashError", "ID étudiant invalide");
                response.sendRedirect(request.getContextPath() + "/etudiants");
                return;
            }
            request.setAttribute("filieres", etudiantService.getAllFilieres());
            request.getRequestDispatcher("/WEB-INF/views/form-etudiant.jsp").forward(request, response);
        } else if ("delete".equals(action) && idParam != null) {
            try {
                Long id = Long.parseLong(idParam);
                etudiantService.delete(id);
                response.sendRedirect(request.getContextPath() + "/etudiants");
                return;
            } catch (Exception e) {
                request.getSession(true).setAttribute("flashError", "Suppression impossible: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/etudiants");
                return;
            }
        } else {
            HttpSession session = request.getSession(false);
            if (session != null) {
                Object w = session.getAttribute("flashWarning");
                if (w != null) {
                    request.setAttribute("warning", String.valueOf(w));
                    session.removeAttribute("flashWarning");
                }
                Object err = session.getAttribute("flashError");
                if (err != null) {
                    request.setAttribute("error", String.valueOf(err));
                    session.removeAttribute("flashError");
                }
            }
            request.setAttribute("etudiants", etudiantService.findAll());
            request.setAttribute("inscritsCount", 0);
            request.setAttribute("validesCount", 0);
            request.setAttribute("encoursCount", 0);
            request.getRequestDispatcher("/WEB-INF/views/etudiants.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("text/plain;charset=UTF-8");
            response.getWriter().write("Accès refusé: ADMIN requis");
            return;
        }

        String action = request.getParameter("action");

        if (action == null || "create".equals(action) || "update".equals(action)) {
            try {
                Etudiant etudiant = new Etudiant();
                etudiant.setNom(request.getParameter("nom"));
                etudiant.setPrenom(request.getParameter("prenom"));
                etudiant.setEmail(request.getParameter("email"));
                etudiant.setTelephone(request.getParameter("telephone"));
                etudiant.setAdresse(request.getParameter("adresse"));
                etudiant.setTelephoneParent(request.getParameter("telephoneParent"));

                String niveauParam = request.getParameter("niveau");
                if (niveauParam != null && !niveauParam.isEmpty()) {
                    etudiant.setNiveau(Niveau.fromString(niveauParam));
                }

                String filiereIdParam = request.getParameter("filiereId");
                if (filiereIdParam != null && !filiereIdParam.isEmpty()) {
                    Filiere filiere = new Filiere();
                    filiere.setId(Long.parseLong(filiereIdParam));
                    etudiant.setFiliere(filiere);
                }

                String idParam = request.getParameter("id");
                if (idParam != null && !idParam.isBlank()) {
                    Long id = Long.parseLong(idParam);
                    etudiantService.updateEtudiant(id, etudiant);
                } else {
                    String loginUrl = request.getRequestURL().toString().replace("/etudiants", "/login");
                    String warning = etudiantService.createEtudiant(etudiant, loginUrl);
                    if (warning != null && !warning.isBlank()) {
                        request.getSession(true).setAttribute("flashWarning", warning);
                    }
                }

                response.sendRedirect(request.getContextPath() + "/etudiants");
            } catch (Exception e) {
                request.setAttribute("error", "Erreur lors de l'enregistrement de l'étudiant: " + e.getMessage());
                request.setAttribute("filieres", etudiantService.getAllFilieres());
                request.getRequestDispatcher("/WEB-INF/views/form-etudiant.jsp").forward(request, response);
            }
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        Object obj = (session == null) ? null : session.getAttribute(SessionKeys.AUTH_USER);
        return (obj instanceof User) && authService.isAdmin((User) obj);
    }
}
