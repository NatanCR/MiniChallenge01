//
//  Resultado.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import Foundation

import SwiftUI

class dadosInseridos: ObservableObject {
    @Published var titulo: String?
    init() {
    }
}


struct Resultado: View {
    
    @EnvironmentObject var model: Model
    var dataFinalSalvar = Date()
    var resultadoDate = DateComponents()
    @ObservedObject var dados = dadosInseridos()
    @State var titulo: String = ""
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Título do evento")) {
                    TextField("Título", text: $titulo)
                }
                ZStack {
                    Text("Resultado: \n\(resultadoDate.day!) dias \n\(resultadoDate.hour!) horas e \(resultadoDate.minute!) minutos ")
                }
                Button  {
                    model.salvar(tituloSalvo: titulo, anotacoesSalvo: "Sem Anotacões ainda", dataFinalSalvo: dataFinalSalvar)
                } label: {
                    Text("SALVAR")
                }
                Button  {
//                    var lista = model.carregar()
//                    print(lista)
                } label: {
                    Text("Carregar")
                }
            }
            
            .navigationTitle("Salvar Data")
            .navigationBarTitleDisplayMode(.inline)
        }
            
    }
}

