//
//  MainView.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import SwiftUI

struct MainView: View {
    @StateObject var eventoModel = EventoViewModel()
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.init(red: 0.89, green: 0.92, blue: 0.94, alpha: 1.00)
    }
    
    enum Tab {
        case contador
        case lista
    }
    
    @State private var selecaoTab: Tab = .contador
    
    var body: some View {
        TabView(selection: $selecaoTab) {
            HomeView(eventoModel: eventoModel)
                .tabItem {
                    Image(systemName: "calendar")
                }
                .tag(Tab.contador)
                .environment(\.currentTab, $selecaoTab)
            
            ListaView(eventoModel: eventoModel)
                .tabItem {
                    Image(systemName: "rectangle.grid.1x2")
                }
                .tag(Tab.lista)
                .environment(\.currentTab, $selecaoTab)
        }
        .accentColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
    }
}

struct CurrentTabKey: EnvironmentKey {
    static var defaultValue: Binding<MainView.Tab> = .constant(.contador)
}

extension EnvironmentValues {
    var currentTab: Binding<MainView.Tab> {
           get { self[CurrentTabKey.self] }
           set { self[CurrentTabKey.self] = newValue }
       }
}
