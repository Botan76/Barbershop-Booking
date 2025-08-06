//
//  TimeSlotListView.swift
//  Barbershop Booking
//
//  Created by Bootan Majeed on 2025-08-04.
//

import SwiftUI

struct TimeSlotListView: View {
    let selectedDate: Date
    @ObservedObject var bookingManager: BookingManager

    @State private var selectedSlot: IdentifiableDate?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(generateTimeSlots(), id: \.self) { slot in
                    let name = bookingManager.getName(for: slot)

                    HStack {
                        Text(timeFormatter.string(from: slot))
                            .frame(width: 80, alignment: .leading)

                        if name.isEmpty {
                            Text("Available").foregroundColor(.gray)
                        } else {
                            Text(name)
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                                .onTapGesture {
                                    selectedSlot = IdentifiableDate(date: slot)
                                }
                        }

                        Spacer()
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal)
                }
            }
        }
        .sheet(item: $selectedSlot) { slot in
            BookingDetailSheet(
                slot: slot.date,
                name: bookingManager.getName(for: slot.date),
                phoneNumber: bookingManager.getPhone(for: slot.date),
                onCancel: {
                    bookingManager.removeBooking(date: slot.date)
                    selectedSlot = nil
                },
                onClose: {
                    selectedSlot = nil
                }
            )
            .presentationDetents([.fraction(0.6)])
            .presentationDragIndicator(.visible)
        }
    }

    func generateTimeSlots() -> [Date] {
        var slots: [Date] = []
        let calendar = Calendar.current
        for hour in 9..<21 {
            let first = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: selectedDate)!
            let second = calendar.date(bySettingHour: hour, minute: 30, second: 0, of: selectedDate)!
            slots.append(first)
            slots.append(second)
        }
        return slots
    }

    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
}

// MARK: - Identifiable wrapper for Date
struct IdentifiableDate: Identifiable, Equatable {
    let id = UUID()
    let date: Date
}
