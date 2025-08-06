//
//  AddBookingView.swift
//  Barbershop Booking
//
//  Created by Bootan Majeed on 2025-08-04.
//

import SwiftUI

struct AddBookingView: View {
    let selectedDate: Date
    @ObservedObject var bookingManager: BookingManager

    @Environment(\.dismiss) var dismiss
    @State private var selectedTime: Date = Date()
    @State private var name: String = ""
    @State private var phoneNumber: String = ""

    private var availableTimeSlots: [Date] {
        var slots: [Date] = []
        let calendar = Calendar.current
        for hour in 9..<21 {
            if let slot1 = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: selectedDate),
               let slot2 = calendar.date(bySettingHour: hour, minute: 30, second: 0, of: selectedDate) {
                slots.append(slot1)
                slots.append(slot2)
            }
        }
        return slots
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Select Time")) {
                    Menu {
                        ForEach(availableTimeSlots, id: \.self) { time in
                            let isBooked = isTimeSlotBooked(time)
                            Button(action: {
                                if !isBooked {
                                    selectedTime = time
                                }
                            }) {
                                Button(action: {
                                    if !isBooked {
                                        selectedTime = time
                                    }
                                }) {
                                    Text(isBooked ? "\(timeFormatter.string(from: time))        Booked" : timeFormatter.string(from: time))
                                }
                                .disabled(isBooked)

                            }
                            .disabled(isBooked)
                        }
                    } label: {
                        Text(timeFormatter.string(from: selectedTime))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }

                Section(header: Text("Customer Name")) {
                    TextField("Enter name", text: $name)
                }
                Section(header: Text("Phone Number (optional)")) {
                    TextField("Enter phone number", text: $phoneNumber)
                        .keyboardType(.phonePad)
                }
            }
            .navigationBarTitle("New Booking", displayMode: .inline)
            .navigationBarItems(trailing: Button("Save") {
                saveBooking()
            }
            .disabled(name.isEmpty || isTimeSlotBooked(selectedTime)))
            .onAppear {
                if let firstAvailable = availableTimeSlots.first(where: { !isTimeSlotBooked($0) }) {
                    selectedTime = firstAvailable
                }
            }
        }
    }

    func isTimeSlotBooked(_ date: Date) -> Bool {
        !bookingManager.getName(for: date).isEmpty
    }

    func saveBooking() {
        bookingManager.addBooking(date: selectedTime, name: name, phoneNumber: phoneNumber.isEmpty ? nil : phoneNumber)
        dismiss()
    }


    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }
}
