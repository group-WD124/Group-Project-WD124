package com.hotel.model;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.time.format.DateTimeFormatter;

/**
 * Represents a date range between check-in and check-out.
 */
public class DateRange {

    private LocalDate checkIn;
    private LocalDate checkOut;

    private static final DateTimeFormatter FMT = DateTimeFormatter.ofPattern("dd MMM yyyy");

    public DateRange(String checkIn, String checkOut) {
        this.checkIn  = LocalDate.parse(checkIn);
        this.checkOut = LocalDate.parse(checkOut);
    }

    /** Number of nights between check-in and check-out. */
    public long getNights() {
        return ChronoUnit.DAYS.between(checkIn, checkOut);
    }

    /** Human-readable formatted check-in date. */
    public String getFormattedCheckIn() {
        return checkIn.format(FMT);
    }

    /** Human-readable formatted check-out date. */
    public String getFormattedCheckOut() {
        return checkOut.format(FMT);
    }

    /** True if the date range is currently active (today is between check-in and check-out). */
    public boolean isActive() {
        LocalDate today = LocalDate.now();
        return !today.isBefore(checkIn) && !today.isAfter(checkOut);
    }

    /** True if check-out is in the past. */
    public boolean isPast() {
        return LocalDate.now().isAfter(checkOut);
    }

    /** True if check-in is in the future. */
    public boolean isUpcoming() {
        return LocalDate.now().isBefore(checkIn);
    }

    public LocalDate getCheckIn()  { return checkIn; }
    public LocalDate getCheckOut() { return checkOut; }
}
