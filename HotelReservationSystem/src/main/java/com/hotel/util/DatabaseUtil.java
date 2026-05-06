package com.hotel.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Utility class for obtaining a MySQL JDBC connection.
 * Update DB_URL, DB_USER, and DB_PASS to match your environment.
 */
public class DatabaseUtil {

    // ── Configuration ─────────────────────────────────────────────────────────
    private static final String DB_URL  = "jdbc:mysql://localhost:3306/hotel_reservation"
                                        + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "Lakvin(331)@#$";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new ExceptionInInitializerError("MySQL JDBC Driver not found: " + e.getMessage());
        }
    }

    /** Returns a new JDBC connection from DriverManager. */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    /** Quietly closes a connection (null-safe). */
    public static void close(Connection conn) {
        if (conn != null) {
            try { conn.close(); } catch (SQLException ignored) {}
        }
    }
}
