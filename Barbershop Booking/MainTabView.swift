//
//  MainTabView.swift
//  Barbershop Booking
//
//  Created by Bootan Majeed on 2025-08-06.
//

import SwiftUI

struct MainTabView: View {
    @StateObject var bookingManager = BookingManager()  

    var body: some View {
        TabView {
            HomeView(bookingManager: bookingManager)
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            ContentView(bookingManager: bookingManager)
                .tabItem {
                    Label("Schedule", systemImage: "calendar")
                }
        }
    }
}

#Preview {
    MainTabView()
}
