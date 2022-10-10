//
//  MainView.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import SwiftUI

struct MainView: View {
    @ObservedObject var eventos = EventoViewModel()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.init(red: 0.89, green: 0.92, blue: 0.94, alpha: 1.00)
    }
    
    var body: some View {
        TabView {
            HomeView()
                .environmentObject(eventos)
                .tabItem {
                    Image(systemName: "calendar")
                }
            
            ListaView()
                .environmentObject(eventos)
                .tabItem {
                    Image(systemName: "rectangle.grid.1x2")
                }
        }
        .accentColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
    }
}
