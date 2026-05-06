package com.hotel.servlet;

import com.hotel.dao.ReservationDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

/**
 * Serves the /dashboard page with aggregated statistics.
 */
@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private ReservationDAO dao;

    @Override
    public void init() {
        dao = new ReservationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        try {
            req.setAttribute("totalCount",     dao.countAll());
            req.setAttribute("pendingCount",   dao.countByStatus("Pending"));
            req.setAttribute("confirmedCount", dao.countByStatus("Confirmed"));
            req.setAttribute("cancelledCount", dao.countByStatus("Cancelled"));
            req.setAttribute("checkedOutCount",dao.countByStatus("Checked-Out"));
            req.setAttribute("totalRevenue",   dao.totalRevenue());
            req.setAttribute("recentList",     dao.getAll());
        } catch (Exception e) {
            req.setAttribute("dbError", e.getMessage());
        }
        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, res);
    }
}
