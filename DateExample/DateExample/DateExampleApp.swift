//
//  DateExampleApp.swift
//  DateExample
//
//  Created by Natan Rodrigues on 29/08/22.
//

import SwiftUI

@main
struct DateExampleApp: App {
    
    
    @StateObject private var dados: EventoViewModel
    
    public init() {
        self._dados = StateObject(wrappedValue: EventoViewModel())
    }

    var body: some Scene {
        WindowGroup {
            LaunchScreen(eventoModel: dados)
        }
    }
}
