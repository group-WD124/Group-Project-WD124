package com.hotel.servlet;

import com.hotel.dao.ReservationDAO;
import com.hotel.model.Reservation;
import com.hotel.model.ReservationForm;
import com.hotel.model.RoomPricing;
import com.hotel.model.Validation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Locale;

/**
 * Central servlet handling all reservation operations:
 * GET  /reservations?action=list|edit&id=X
 * GET  /reservations?action=delete&id=X
 * GET  /reservations?action=search&keyword=...&roomType=...&status=...
 * GET  /reservations?action=add
 * POST /reservations?action=save   (insert/update)
 */
@WebServlet("/reservations")
public class ReservationServlet extends HttpServlet {

    private ReservationDAO dao;

    @Override
    public void init() {
        dao = new ReservationDAO();
    }

    // ─── GET ─────────────────────────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "add":
                    req.setAttribute("form", new ReservationForm());
                    req.setAttribute("mode", "add");
                    forward(req, res, "/WEB-INF/views/form.jsp");
                    break;

                case "edit":
                    int editId = Integer.parseInt(req.getParameter("id"));
                    Reservation toEdit = dao.getById(editId);
                    if (toEdit == null) {
                        res.sendRedirect(req.getContextPath() + "/reservations?action=list&error=notfound");
                        return;
                    }
                    req.setAttribute("form", ReservationForm.from(toEdit));
                    req.setAttribute("mode", "edit");
                    forward(req, res, "/WEB-INF/views/form.jsp");
                    break;

                case "delete":
                    int delId = Integer.parseInt(req.getParameter("id"));
                    dao.delete(delId);
                    res.sendRedirect(req.getContextPath() + "/reservations?action=list&msg=deleted");
                    break;

                case "search":
                    String keyword  = req.getParameter("keyword");
                    String roomType = req.getParameter("roomType");
                    String status   = req.getParameter("status");
                    String fromDate = req.getParameter("fromDate");
                    String toDate   = req.getParameter("toDate");
                    List<Reservation> results = dao.search(keyword, roomType, status, fromDate, toDate);
                    req.setAttribute("reservations", results);
                    req.setAttribute("keyword", keyword);
                    req.setAttribute("roomType", roomType);
                    req.setAttribute("status", status);
                    req.setAttribute("fromDate", fromDate);
                    req.setAttribute("toDate", toDate);
                    forward(req, res, "/WEB-INF/views/search.jsp");
                    break;

                default: // list
                    req.setAttribute("reservations", dao.getAll());
                    req.setAttribute("msg", req.getParameter("msg"));
                    forward(req, res, "/WEB-INF/views/list.jsp");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // ─── POST ────────────────────────────────────────────────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        ReservationForm form = bindForm(req);
        applyCalculatedPrice(form);
        boolean isNew = (form.getId() == null || form.getId().isEmpty());

        if (!Validation.validateForm(form, isNew)) {
            req.setAttribute("form", form);
            req.setAttribute("mode", isNew ? "add" : "edit");
            forward(req, res, "/WEB-INF/views/form.jsp");
            return;
        }

        try {
            Reservation r = form.toReservation();
            if (isNew) {
                dao.insert(r);
                res.sendRedirect(req.getContextPath() + "/reservations?action=list&msg=added");
            } else {
                dao.update(r);
                res.sendRedirect(req.getContextPath() + "/reservations?action=list&msg=updated");
            }
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    // ─── Helpers ─────────────────────────────────────────────────────────────
    private ReservationForm bindForm(HttpServletRequest req) {
        ReservationForm f = new ReservationForm();
        f.setId(req.getParameter("id"));
        f.setGuestName(req.getParameter("guestName"));
        f.setPhone(req.getParameter("phone"));
        f.setEmail(req.getParameter("email"));
        f.setRoomType(req.getParameter("roomType"));
        f.setRooms(req.getParameter("rooms"));
        f.setCheckIn(req.getParameter("checkIn"));
        f.setCheckOut(req.getParameter("checkOut"));
        f.setStatus(req.getParameter("status"));
        f.setPrice(req.getParameter("price"));
        f.setNotes(req.getParameter("notes"));
        return f;
    }

    private void applyCalculatedPrice(ReservationForm form) {
        try {
            double total = RoomPricing.calculateTotal(
                    form.getRoomType(),
                    form.getRooms(),
                    form.getCheckIn(),
                    form.getCheckOut()
            );
            form.setPrice(String.format(Locale.US, "%.2f", total));
        } catch (Exception ignored) {
            // Validation will show the field-specific error for incomplete or invalid input.
        }
    }

    private void forward(HttpServletRequest req, HttpServletResponse res, String path)
            throws ServletException, IOException {
        req.getRequestDispatcher(path).forward(req, res);
    }
}
