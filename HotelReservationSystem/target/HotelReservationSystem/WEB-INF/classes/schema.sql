-- Hotel Reservation System Database Schema
-- Run this script in MySQL before starting the application

CREATE DATABASE IF NOT EXISTS hotel_reservation
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE hotel_reservation;

CREATE TABLE IF NOT EXISTS reservations (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    guest_name  VARCHAR(100) NOT NULL,
    phone       VARCHAR(20)  NOT NULL,
    email       VARCHAR(100),
    room_type   ENUM('Single', 'Double', 'Suite', 'Deluxe') NOT NULL DEFAULT 'Single',
    rooms       INT NOT NULL DEFAULT 1,
    check_in    DATE NOT NULL,
    check_out   DATE NOT NULL,
    status      ENUM('Pending', 'Confirmed', 'Cancelled', 'Checked-Out') NOT NULL DEFAULT 'Pending',
    price       DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    notes       TEXT,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Sample data
INSERT INTO reservations (guest_name, phone, email, room_type, rooms, check_in, check_out, status, price, notes) VALUES
('Arun Kumar',    '9876543210', 'arun@example.com',   'Suite',   1, '2026-04-20', '2026-04-25', 'Confirmed',  12500.00, 'Anniversary trip'),
('Priya Sharma',  '9123456780', 'priya@example.com',  'Double',  1, '2026-04-22', '2026-04-24', 'Pending',     4800.00, NULL),
('Ravi Nair',     '9988776655', 'ravi@example.com',   'Single',  1, '2026-04-18', '2026-04-20', 'Confirmed',   2400.00, NULL),
('Meena Patel',   '9001122334', 'meena@example.com',  'Deluxe',  2, '2026-04-19', '2026-04-23', 'Confirmed',   9600.00, 'Extra bed needed'),
('Suresh Reddy',  '9786453120', NULL,                 'Single',  1, '2026-04-17', '2026-04-19', 'Checked-Out', 2400.00, NULL),
('Anita Joshi',   '9654321087', 'anita@example.com',  'Double',  1, '2026-04-25', '2026-04-28', 'Pending',     7200.00, 'Early check-in'),
('Deepak Singh',  '9543210876', NULL,                 'Suite',   1, '2026-04-15', '2026-04-17', 'Cancelled',   5000.00, 'Flight delayed'),
('Kavitha Menon', '9432109765', 'kavitha@example.com','Single',  1, '2026-04-27', '2026-04-30', 'Pending',     3600.00, NULL);
