//
//  HorizontalCalendarView.swift
//  Barbershop Booking
//
//  Created by Bootan Majeed on 2025-08-04.
//

import SwiftUI

struct HorizontalCalendarView: View {
    @Binding var selectedDate: Date

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0..<30) { offset in
                    let date = Calendar.current.date(byAdding: .day, value: offset, to: Date())!
                    VStack {
                        Text(shortWeekdayString(from: date))
                            .font(.caption)
                        Text(dayString(from: date))
                            .fontWeight(.bold)
                    }
                    .frame(width: 50, height: 60)
                    .background(Calendar.current.isDate(date, inSameDayAs: selectedDate) ? Color.blue.opacity(0.3) : Color.clear)
                    .cornerRadius(10)
                    .onTapGesture {
                        selectedDate = date
                    }
                }
            }
            .padding(.horizontal)
        }
    }

    func shortWeekdayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }

    func dayString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
}
