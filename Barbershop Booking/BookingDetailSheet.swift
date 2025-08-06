//
//  BookingDetailSheet.swift
//  Barbershop Booking
//
//  Created by Bootan Majeed on 2025-08-04.
//
import SwiftUI

struct BookingDetailSheet: View {
    let slot: Date
    let name: String
    let phoneNumber: String?
    let onCancel: () -> Void
    let onClose: () -> Void

    private var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Booking Details")
                    .font(.title2)
                    .padding(.top, 20)

                HStack {
                    Text("Name:")
                        .fontWeight(.bold)
                    Text(name)
                    Spacer()
                }

                HStack {
                    Text("Time:")
                        .fontWeight(.bold)
                    Text(timeFormatter.string(from: slot))
                    Spacer()
                }
                
                if let phone = phoneNumber, !phone.isEmpty {
                    HStack {
                        Text("Phone:")
                            .fontWeight(.bold)
                        Button(action: {
                            if let url = URL(string: "tel://\(phone.filter { $0.isNumber })") {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            Text(phone)
                                .foregroundColor(.blue)
                                .underline()
                        }
                        Spacer()
                    }
                }


                Spacer()

                Button(action: {
                    onCancel()
                }) {
                    Text("Cancel Booking")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(12)
                }

                Button(action: {
                    onClose()
                }) {
                    Text("Close")
                        .foregroundColor(.blue)
                        .padding(.bottom, 60)
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}
