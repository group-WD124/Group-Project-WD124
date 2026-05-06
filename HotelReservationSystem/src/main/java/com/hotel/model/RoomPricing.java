package com.hotel.model;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.Map;

public final class RoomPricing {
    private static final Map<String, Double> NIGHTLY_RATES = Map.of(
            "Single", 2200.0,
            "Double", 3800.0,
            "Deluxe", 5600.0,
            "Suite", 8200.0
    );

    private RoomPricing() {}

    public static double nightlyRate(String roomType) {
        Double rate = NIGHTLY_RATES.get(roomType);
        if (rate == null) {
            throw new IllegalArgumentException("Unknown room type.");
        }
        return rate;
    }

    public static double calculateTotal(String roomType, String rooms, String checkIn, String checkOut) {
        int roomCount = Integer.parseInt(rooms);
        LocalDate start = LocalDate.parse(checkIn);
        LocalDate end = LocalDate.parse(checkOut);
        long nights = ChronoUnit.DAYS.between(start, end);

        if (roomCount < 1 || nights < 1) {
            throw new IllegalArgumentException("Invalid stay details.");
        }

        return nightlyRate(roomType) * roomCount * nights;
    }
}
