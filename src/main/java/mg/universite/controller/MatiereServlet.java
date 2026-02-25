package mg.universite.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import mg.universite.dao.MatiereDAO;
import mg.universite.model.Matiere;

import java.io.IOException;

@WebServlet("/matieres")
public class MatiereServlet extends HttpServlet {

    private MatiereDAO matiereDAO = new MatiereDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            Long id = Long.parseLong(request.getParameter("id"));
            matiereDAO.delete(id);
            response.sendRedirect("matieres");
            return;
        }

        if ("new".equals(action)) {
            request.getRequestDispatcher("/WEB-INF/views/form-matiere.jsp").forward(request, response);
        } else {
            request.setAttribute("matieres", matiereDAO.findAll());
            request.getRequestDispatcher("/WEB-INF/views/matieres.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String nom = request.getParameter("nom");
        int coef = Integer.parseInt(request.getParameter("coefficient"));

        Matiere m = new Matiere(nom, coef);
        matiereDAO.save(m);

        response.sendRedirect("matieres");
    }
}