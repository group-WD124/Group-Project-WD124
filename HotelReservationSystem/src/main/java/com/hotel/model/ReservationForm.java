package com.hotel.model;

/**
 * Form-binding POJO used for Add/Edit reservation forms.
 * Mirrors Reservation fields but uses String for all values
 * to simplify JSP form binding.
 */
public class ReservationForm {

    private String id;
    private String guestName;
    private String phone;
    private String email;
    private String roomType;
    private String rooms;
    private String checkIn;
    private String checkOut;
    private String status;
    private String price;
    private String notes;

    // Validation errors map
    private java.util.Map<String, String> errors = new java.util.HashMap<>();

    public ReservationForm() {}

    /** Convert form data to a Reservation object. */
    public Reservation toReservation() {
        Reservation r = new Reservation();
        if (id != null && !id.isEmpty()) r.setId(Integer.parseInt(id));
        r.setGuestName(guestName);
        r.setPhone(phone);
        r.setEmail(email);
        r.setRoomType(roomType);
        r.setRooms(rooms != null && !rooms.isEmpty() ? Integer.parseInt(rooms) : 1);
        r.setCheckIn(checkIn);
        r.setCheckOut(checkOut);
        r.setStatus(status != null ? status : "Pending");
        r.setPrice(price != null && !price.isEmpty() ? Double.parseDouble(price) : 0.0);
        r.setNotes(notes);
        return r;
    }

    /** Populate form from a Reservation (for edit mode). */
    public static ReservationForm from(Reservation r) {
        ReservationForm f = new ReservationForm();
        f.id        = String.valueOf(r.getId());
        f.guestName = r.getGuestName();
        f.phone     = r.getPhone();
        f.email     = r.getEmail();
        f.roomType  = r.getRoomType();
        f.rooms     = String.valueOf(r.getRooms());
        f.checkIn   = r.getCheckIn();
        f.checkOut  = r.getCheckOut();
        f.status    = r.getStatus();
        f.price     = String.valueOf(r.getPrice());
        f.notes     = r.getNotes();
        return f;
    }

    public boolean hasErrors() { return !errors.isEmpty(); }
    public java.util.Map<String, String> getErrors() { return errors; }
    public void addError(String field, String msg)   { errors.put(field, msg); }
    public String getError(String field)             { return errors.get(field); }

    // ─── Getters & Setters ───────────────────────────────────────────────────
    public String getId()                    { return id; }
    public void setId(String id)             { this.id = id; }

    public String getGuestName()                   { return guestName; }
    public void setGuestName(String guestName)     { this.guestName = guestName; }

    public String getPhone()               { return phone; }
    public void setPhone(String phone)     { this.phone = phone; }

    public String getEmail()               { return email; }
    public void setEmail(String email)     { this.email = email; }

    public String getRoomType()                  { return roomType; }
    public void setRoomType(String roomType)     { this.roomType = roomType; }

    public String getRooms()               { return rooms; }
    public void setRooms(String rooms)     { this.rooms = rooms; }

    public String getCheckIn()               { return checkIn; }
    public void setCheckIn(String checkIn)   { this.checkIn = checkIn; }

    public String getCheckOut()                { return checkOut; }
    public void setCheckOut(String checkOut)   { this.checkOut = checkOut; }

    public String getStatus()                { return status; }
    public void setStatus(String status)     { this.status = status; }

    public String getPrice()               { return price; }
    public void setPrice(String price)     { this.price = price; }

    public String getNotes()               { return notes; }
    public void setNotes(String notes)     { this.notes = notes; }
}
