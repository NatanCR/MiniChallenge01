//
//  Resultado.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import Foundation

import SwiftUI

struct Resultado: View {
    
    @State var alertas = ["2 semanas", "1 semana", "5 dias", "3 dias", "2 dias", "1 dia"]
    
    @EnvironmentObject var model: Model
    @State var isActive : Bool = false
    var dataFinalSalvar = Date()
    var resultadoDate = DateComponents()
    @State var titulo: String = ""
    @State var dataFinal = Date()
    @State var anotacao: String
    
    
    var body: some View {
        VStack {
            VStack {
                Text("\(dataFinalSalvar.formatted(.dateTime.day().month().year()))")
                Text("\(resultadoDate.day!) dias")
            }
            VStack {
                Form {
                    TextField("Título", text: $titulo)
                    Picker(selection: $alertas) {
                        ForEach(alertas, id: \.self) { alerta in
                            Text(alerta)
                        }
                    } label: {
                        Text("Alertas")
                    }
                    HStack {
                        DatePicker("Data Final", selection: $dataFinal, displayedComponents: [.date])
                    }
                }
                HStack {
                    Form {
                        TextEditor(text: $anotacao)
                    }
                }
            }
        }
        .navigationBarTitle("Salvar Data")
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button  {
                    model.salvar(tituloSalvo: titulo, anotacoesSalvo: "Sem Anotacões ainda", dataFinalSalvo: dataFinalSalvar)
                    
                } label: {
                    Text("Salvar")
                }
            }
        }
    }
}
