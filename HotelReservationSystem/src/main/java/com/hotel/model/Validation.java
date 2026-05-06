package com.hotel.model;

import java.time.LocalDate;

/**
 * Static validation helpers for reservation form fields.
 */
public class Validation {

    private Validation() {}  // utility class

    /**
     * Validate guest name: required, 2-100 chars, letters/spaces only.
     */
    public static String validateName(String name) {
        if (name == null || name.trim().isEmpty())
            return "Guest name is required.";
        name = name.trim();
        if (name.length() < 2)
            return "Name must be at least 2 characters.";
        if (name.length() > 100)
            return "Name must not exceed 100 characters.";
        if (!name.matches("[a-zA-Z\\s.'-]+"))
            return "Name may only contain letters, spaces, dots, apostrophes, or hyphens.";
        return null; // valid
    }

    /**
     * Validate phone: required, 7-15 digits (with optional +, spaces, dashes).
     */
    public static String validatePhone(String phone) {
        if (phone == null || phone.trim().isEmpty())
            return "Phone number is required.";
        phone = phone.trim();
        if (!phone.matches("[+]?[0-9\\s\\-]{7,15}"))
            return "Enter a valid phone number (7-15 digits).";
        return null;
    }

    /**
     * Validate email: optional, but if provided must be valid format.
     */
    public static String validateEmail(String email) {
        if (email == null || email.trim().isEmpty())
            return null; // optional
        if (!email.trim().matches("^[\\w._%+\\-]+@[\\w.\\-]+\\.[a-zA-Z]{2,}$"))
            return "Enter a valid email address.";
        return null;
    }

    /**
     * Validate room type against the available price list.
     */
    public static String validateRoomType(String roomType) {
        if (roomType == null || roomType.trim().isEmpty())
            return "Room type is required.";
        try {
            RoomPricing.nightlyRate(roomType.trim());
        } catch (IllegalArgumentException e) {
            return "Select a valid room type.";
        }
        return null;
    }

    /**
     * Validate date pair: both required, check-in must be before check-out,
     * check-in must not be in the past (only for new reservations).
     */
    public static String validateDates(String checkIn, String checkOut, boolean isNew) {
        if (checkIn == null || checkIn.isEmpty())
            return "Check-in date is required.";
        if (checkOut == null || checkOut.isEmpty())
            return "Check-out date is required.";
        try {
            LocalDate ci = LocalDate.parse(checkIn);
            LocalDate co = LocalDate.parse(checkOut);
            if (!co.isAfter(ci))
                return "Check-out must be at least 1 day after check-in.";
            if (isNew && ci.isBefore(LocalDate.now()))
                return "Check-in date cannot be in the past.";
        } catch (Exception e) {
            return "Invalid date format. Use YYYY-MM-DD.";
        }
        return null;
    }

    /**
     * Validate price: must be a positive number.
     */
    public static String validatePrice(String price) {
        if (price == null || price.trim().isEmpty())
            return "Price is required.";
        try {
            double p = Double.parseDouble(price.trim());
            if (p < 0)
                return "Price must not be negative.";
        } catch (NumberFormatException e) {
            return "Price must be a valid number.";
        }
        return null;
    }

    /**
     * Validate room count: 1-10.
     */
    public static String validateRooms(String rooms) {
        if (rooms == null || rooms.trim().isEmpty())
            return "Number of rooms is required.";
        try {
            int r = Integer.parseInt(rooms.trim());
            if (r < 1 || r > 10)
                return "Rooms must be between 1 and 10.";
        } catch (NumberFormatException e) {
            return "Rooms must be a valid integer.";
        }
        return null;
    }

    /**
     * Run all validations on a form and populate its error map.
     * Returns true if everything is valid.
     */
    public static boolean validateForm(ReservationForm form, boolean isNew) {
        boolean valid = true;

        String nameErr  = validateName(form.getGuestName());
        String phoneErr = validatePhone(form.getPhone());
        String emailErr = validateEmail(form.getEmail());
        String roomTypeErr = validateRoomType(form.getRoomType());
        String dateErr  = validateDates(form.getCheckIn(), form.getCheckOut(), isNew);
        String priceErr = validatePrice(form.getPrice());
        String roomsErr = validateRooms(form.getRooms());

        if (nameErr  != null) { form.addError("guestName", nameErr);  valid = false; }
        if (phoneErr != null) { form.addError("phone",     phoneErr); valid = false; }
        if (emailErr != null) { form.addError("email",     emailErr); valid = false; }
        if (roomTypeErr != null) { form.addError("roomType", roomTypeErr); valid = false; }
        if (dateErr  != null) { form.addError("dates",     dateErr);  valid = false; }
        if (priceErr != null) { form.addError("price",     priceErr); valid = false; }
        if (roomsErr != null) { form.addError("rooms",     roomsErr); valid = false; }

        return valid;
    }
}
