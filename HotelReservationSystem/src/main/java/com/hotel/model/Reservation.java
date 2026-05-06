package com.hotel.model;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class Reservation {
    private int id;
    private String guestName;
    private String phone;
    private String email;
    private String roomType;   // Single, Double, Suite, Deluxe
    private int rooms;
    private String checkIn;    // stored as "YYYY-MM-DD" string
    private String checkOut;
    private String status;     // Pending, Confirmed, Cancelled, Checked-Out
    private double price;
    private String notes;
    private String createdAt;

    // ─── Constructors ────────────────────────────────────────────────────────
    public Reservation() {}

    public Reservation(int id, String guestName, String phone, String email,
                       String roomType, int rooms, String checkIn, String checkOut,
                       String status, double price, String notes, String createdAt) {
        this.id        = id;
        this.guestName = guestName;
        this.phone     = phone;
        this.email     = email;
        this.roomType  = roomType;
        this.rooms     = rooms;
        this.checkIn   = checkIn;
        this.checkOut  = checkOut;
        this.status    = status;
        this.price     = price;
        this.notes     = notes;
        this.createdAt = createdAt;
    }

    // ─── Computed helper ─────────────────────────────────────────────────────
    public long getNights() {
        try {
            LocalDate ci = LocalDate.parse(checkIn);
            LocalDate co = LocalDate.parse(checkOut);
            return ChronoUnit.DAYS.between(ci, co);
        } catch (Exception e) {
            return 0;
        }
    }

    // ─── Getters & Setters ───────────────────────────────────────────────────
    public int getId()                { return id; }
    public void setId(int id)         { this.id = id; }

    public String getGuestName()                  { return guestName; }
    public void setGuestName(String guestName)    { this.guestName = guestName; }

    public String getPhone()               { return phone; }
    public void setPhone(String phone)     { this.phone = phone; }

    public String getEmail()               { return email; }
    public void setEmail(String email)     { this.email = email; }

    public String getRoomType()                 { return roomType; }
    public void setRoomType(String roomType)    { this.roomType = roomType; }

    public int getRooms()              { return rooms; }
    public void setRooms(int rooms)    { this.rooms = rooms; }

    public String getCheckIn()               { return checkIn; }
    public void setCheckIn(String checkIn)   { this.checkIn = checkIn; }

    public String getCheckOut()                { return checkOut; }
    public void setCheckOut(String checkOut)   { this.checkOut = checkOut; }

    public String getStatus()                { return status; }
    public void setStatus(String status)     { this.status = status; }

    public double getPrice()               { return price; }
    public void setPrice(double price)     { this.price = price; }

    public String getNotes()               { return notes; }
    public void setNotes(String notes)     { this.notes = notes; }

    public String getCreatedAt()                 { return createdAt; }
    public void setCreatedAt(String createdAt)   { this.createdAt = createdAt; }
}
