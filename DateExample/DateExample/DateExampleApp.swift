//
//  DateExampleApp.swift
//  DateExample
//
//  Created by Natan Rodrigues on 29/08/22.
//

import SwiftUI

@main
struct DateExampleApp: App {
    let dados = Model()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(dados)
        }
    }
}
