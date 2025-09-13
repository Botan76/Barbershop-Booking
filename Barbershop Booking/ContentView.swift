//
//  ContentView.swift
//  Barbershop Booking
//
//  Created by Bootan Majeed on 2025-08-04.
//

import SwiftUI

    
struct ContentView: View {
    @State private var selectedDate = Date()
    @ObservedObject var bookingManager: BookingManager
    @State private var showAddBooking = false

    var body: some View {
        NavigationView {
            VStack {
                HorizontalCalendarView(selectedDate: $selectedDate)
                    .padding(.top)

                Divider()

                TimeSlotListView(
                    selectedDate: selectedDate,
                    bookingManager: bookingManager
                )

                Spacer()

                Button(action: {
                    showAddBooking = true
                }) {
                    Text("➕ Add Booking")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                }
                .sheet(isPresented: $showAddBooking) {
                    AddBookingView(
                        selectedDate: selectedDate,
                        bookingManager: bookingManager
                    )
                }

                Spacer(minLength: 12)
            }
            .navigationBarTitle("Bookings", displayMode: .inline)
        }
    }
}



