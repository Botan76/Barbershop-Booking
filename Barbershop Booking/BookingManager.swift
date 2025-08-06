//
//  BookingManager.swift
//  Barbershop Booking
//
//  Created by Bootan Majeed on 2025-08-04.
//

import Foundation

// MARK: - Booking Model
struct Booking: Codable {
    let name: String
    let phoneNumber: String?  // Optional phone number
}

// MARK: - Booking Manager
class BookingManager: ObservableObject {
    @Published var bookings: [String: Booking] = [:] {
        didSet {
            saveBookings()
        }
    }

    private let storageKey = "savedBookings"

    init() {
        loadBookings()
    }

    // MARK: - Public Methods

    func addBooking(date: Date, name: String, phoneNumber: String?) {
        let key = keyFrom(date)
        bookings[key] = Booking(name: name, phoneNumber: phoneNumber)
    }

    func getBooking(for date: Date) -> Booking? {
        bookings[keyFrom(date)]
    }

    func getName(for date: Date) -> String {
        getBooking(for: date)?.name ?? ""
    }

    func getPhone(for date: Date) -> String {
        getBooking(for: date)?.phoneNumber ?? ""
    }

    func removeBooking(date: Date) {
        let key = keyFrom(date)
        bookings.removeValue(forKey: key)
    }

    // MARK: - Private Helpers

    private func keyFrom(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }

    private func saveBookings() {
        if let data = try? JSONEncoder().encode(bookings) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func loadBookings() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([String: Booking].self, from: data) {
            bookings = decoded
        }
    }
}

