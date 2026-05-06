package com.hotel.dao;

import com.hotel.model.Reservation;
import com.hotel.util.DatabaseUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object for the reservations table.
 */
public class ReservationDAO {
    private static final String CHECK_IN_PRIORITY_ORDER =
            " ORDER BY " +
            "CASE WHEN check_in >= CURDATE() THEN 0 ELSE 1 END, " +
            "CASE WHEN check_in >= CURDATE() THEN check_in END ASC, " +
            "CASE WHEN check_in < CURDATE() THEN check_in END DESC, " +
            "id DESC";

    // ─── Map a ResultSet row → Reservation ────────────────────────────────────
    private Reservation map(ResultSet rs) throws SQLException {
        Reservation r = new Reservation();
        r.setId(rs.getInt("id"));
        r.setGuestName(rs.getString("guest_name"));
        r.setPhone(rs.getString("phone"));
        r.setEmail(rs.getString("email"));
        r.setRoomType(rs.getString("room_type"));
        r.setRooms(rs.getInt("rooms"));
        r.setCheckIn(rs.getString("check_in"));
        r.setCheckOut(rs.getString("check_out"));
        r.setStatus(rs.getString("status"));
        r.setPrice(rs.getDouble("price"));
        r.setNotes(rs.getString("notes"));
        Timestamp ts = rs.getTimestamp("created_at");
        r.setCreatedAt(ts != null ? ts.toString() : "");
        return r;
    }

    // ─── GET ALL ──────────────────────────────────────────────────────────────
    public List<Reservation> getAll() throws SQLException {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservations" + CHECK_IN_PRIORITY_ORDER;
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    // ─── GET BY ID ────────────────────────────────────────────────────────────
    public Reservation getById(int id) throws SQLException {
        String sql = "SELECT * FROM reservations WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        }
        return null;
    }

    // ─── SEARCH ───────────────────────────────────────────────────────────────
    public List<Reservation> search(String keyword, String roomType, String status,
                                    String fromDate, String toDate) throws SQLException {
        List<Reservation> list = new ArrayList<>();
        StringBuilder sb = new StringBuilder("SELECT * FROM reservations WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sb.append(" AND (guest_name LIKE ? OR phone LIKE ? OR email LIKE ?)");
            String k = "%" + keyword.trim() + "%";
            params.add(k); params.add(k); params.add(k);
        }
        if (roomType != null && !roomType.isEmpty() && !roomType.equals("All")) {
            sb.append(" AND room_type = ?");
            params.add(roomType);
        }
        if (status != null && !status.isEmpty() && !status.equals("All")) {
            sb.append(" AND status = ?");
            params.add(status);
        }
        if (fromDate != null && !fromDate.isEmpty()) {
            sb.append(" AND check_in >= ?");
            params.add(fromDate);
        }
        if (toDate != null && !toDate.isEmpty()) {
            sb.append(" AND check_out <= ?");
            params.add(toDate);
        }
        sb.append(CHECK_IN_PRIORITY_ORDER);

        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sb.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    // ─── INSERT ───────────────────────────────────────────────────────────────
    public boolean insert(Reservation r) throws SQLException {
        String sql = "INSERT INTO reservations (guest_name, phone, email, room_type, rooms, check_in, check_out, status, price, notes) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getGuestName());
            ps.setString(2, r.getPhone());
            ps.setString(3, r.getEmail());
            ps.setString(4, r.getRoomType());
            ps.setInt(5, r.getRooms());
            ps.setString(6, r.getCheckIn());
            ps.setString(7, r.getCheckOut());
            ps.setString(8, r.getStatus() != null ? r.getStatus() : "Pending");
            ps.setDouble(9, r.getPrice());
            ps.setString(10, r.getNotes());
            return ps.executeUpdate() > 0;
        }
    }

    // ─── UPDATE ───────────────────────────────────────────────────────────────
    public boolean update(Reservation r) throws SQLException {
        String sql = "UPDATE reservations SET guest_name=?, phone=?, email=?, room_type=?, rooms=?, "
                   + "check_in=?, check_out=?, status=?, price=?, notes=? WHERE id=?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, r.getGuestName());
            ps.setString(2, r.getPhone());
            ps.setString(3, r.getEmail());
            ps.setString(4, r.getRoomType());
            ps.setInt(5, r.getRooms());
            ps.setString(6, r.getCheckIn());
            ps.setString(7, r.getCheckOut());
            ps.setString(8, r.getStatus());
            ps.setDouble(9, r.getPrice());
            ps.setString(10, r.getNotes());
            ps.setInt(11, r.getId());
            return ps.executeUpdate() > 0;
        }
    }

    // ─── DELETE ───────────────────────────────────────────────────────────────
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM reservations WHERE id = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    // ─── STATS ────────────────────────────────────────────────────────────────
    public int countByStatus(String status) throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations WHERE status = ?";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        }
    }

    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM reservations";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public double totalRevenue() throws SQLException {
        String sql = "SELECT COALESCE(SUM(price),0) FROM reservations WHERE status != 'Cancelled'";
        try (Connection conn = DatabaseUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble(1) : 0.0;
        }
    }
}
