package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mg.universite.service.EtudiantService;
import java.io.IOException;

@WebServlet("/programmes")
public class ProgrammeServlet extends HttpServlet {
    
    private final EtudiantService etudiantService = new EtudiantService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String filiereIdParam = request.getParameter("filiereId");
        String niveauParam = request.getParameter("niveau");
        
        if (filiereIdParam != null && !filiereIdParam.isEmpty()) {
            // Récupérer la filière
            // TODO: Récupérer la filière par ID
            // Filiere filiere = filiereDAO.findById(Long.parseLong(filiereIdParam));
            
            if (niveauParam != null && !niveauParam.isEmpty()) {
                // Programme par niveau et filière
                // Niveau niveau = Niveau.fromString(niveauParam);
                // List<Programme> programmes = etudiantService.getProgrammesByNiveauAndFiliere(niveau, filiere);
                // request.setAttribute("programmes", programmes);
            } else {
                // Tous les programmes de la filière
                // List<Programme> programmes = etudiantService.getProgrammesByFiliere(filiere);
                // request.setAttribute("programmes", programmes);
            }
        } else {
            // Toutes les filières
            request.setAttribute("filieres", etudiantService.getAllFilieres());
        }
        
        request.getRequestDispatcher("/WEB-INF/views/programmes.jsp").forward(request, response);
    }
}