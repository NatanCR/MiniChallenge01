//
//  DateExampleApp.swift
//  DateExample
//
//  Created by Natan Rodrigues on 29/08/22.
//

import SwiftUI

@main
struct DateExampleApp: App {
    
    var body: some Scene {
        
        let dados = Model()
        
        WindowGroup {
            MainView()
                .environmentObject(dados)
        }
    }
}
