//
//  MainView.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Calcular", systemImage: "calendar.circle")
                }
            ListaView()
                .tabItem {
                    Label("Lista", systemImage: "rectangle.grid.1x2")
                }
        }
    }
}
