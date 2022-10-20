//
//  DateExampleApp.swift
//  DateExample
//
//  Created by Natan Rodrigues on 29/08/22.
//

import SwiftUI

@main
struct DateExampleApp: App {
    @ObservedObject var dados = EventoViewModel()
    init() {
//        dados.trocarEstrutura = UserDefaults.standard.set(true, forKey: "AtualizarLista")
        print(UserDefaults.standard.bool(forKey: "AtualizarLista"))
        print(dados.trocarEstrutura)
    }

    var body: some Scene {
        WindowGroup {
            LaunchScreen()
                .environmentObject(dados)
        }
    }
}
