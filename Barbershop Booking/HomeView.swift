//
//  HomeView.swift
//  Barbershop Booking
//
//  Created by Bootan Majeed on 2025-08-06.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var bookingManager: BookingManager
    @State private var currentTime = Date()
    @State private var today = Date()   // 👈 keeps track of current day
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var todayBookings: [(date: Date, booking: Booking)] {
        let startOfDay = Calendar.current.startOfDay(for: today)
        return bookingManager.bookings
            .compactMap { key, booking in
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm"
                if let date = formatter.date(from: key),
                   Calendar.current.isDate(date, inSameDayAs: startOfDay) {
                    return (date: date, booking: booking)
                }
                return nil
            }
            .sorted(by: { $0.date < $1.date })
    }

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                
                // 🕒 Digital Clock
                HStack {
                    Spacer()
                    Text(clockFormatter.string(from: currentTime))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .onReceive(timer) { now in
                            currentTime = now
                        }
                    Spacer()
                }
                .padding(.top)
                
                // 📊 Today's Bookings count
                HStack {
                    Text("Total")
                        .foregroundColor(.green)
                    Text("Bookings: \(todayBookings.count)")
                        .foregroundColor(.red) // default color
                    Text("|")
                        .foregroundColor(.green)
                    Text("Remaining: \(bookingsLeft)")
                        .foregroundColor(.red)
                }
                .font(.title2)
                .fontWeight(.bold)
                .padding(.horizontal)
                
                if todayBookings.isEmpty {
                    Text("No bookings today.")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                } else {
                    ScrollView {
                        VStack(spacing: 12) {
                            ForEach(todayBookings, id: \.date) { item in
                                HStack {
                                    // LEFT SIDE → Name + Tel
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.booking.name)
                                            .fontWeight(.semibold)
                                        if let phone = item.booking.phoneNumber, !phone.isEmpty {
                                            Text("📞 \(phone)")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    // RIGHT SIDE → Time
                                    Text(timeFormatter.string(from: item.date))
                                        .font(.headline)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(
                                    item.date < Date() // ✅ if time has passed
                                    ? Color.green.opacity(0.2) // light green
                                    : Color.gray.opacity(0.1)  // default gray
                                )                                .cornerRadius(10)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.top, 8)
                    }
                }
                
                Spacer()
            }
            .padding(.top)
            .onAppear { today = Date() } // 👈 refresh when screen appears
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                today = Date()  // 👈 refresh when app comes back
            }
            .onAppear {
                // 👈 optional: auto-refresh every minute
                Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                    today = Date()
                }
            }
        }
    }

    // Formatter for booking times
    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }

    // Formatter for live clock
    private var clockFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm" // 👈 Change to "HH:mm:ss" if you want seconds too
        return formatter
    }
    private var bookingsLeft: Int {
        let now = Date()
        return todayBookings.filter { $0.date >= now }.count
    }
}


