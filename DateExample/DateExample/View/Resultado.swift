//
//  Resultado.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import Foundation

import SwiftUI

struct Resultado: View {
    
    var alertas = ["2 semanas", "1 semana", "5 dias", "3 dias", "2 dias", "1 dia"]
    @State private var alertasIndex = 0
    
    @EnvironmentObject var model: Model
    @State var dataFinalSalvar = Date()
    var resultadoDate = DateComponents()
    @State var titulo: String = ""
    @State var anotacao: String
    @Environment(\.dismiss) private var dismiss
    let altura = UIScreen.main.bounds.size.height
    
    var body: some View {
        VStack {
            VStack {
                Text("\(dataFinalSalvar.formatted(.dateTime.day().month().year()))")
                Text("\(resultadoDate.day!) dias")
            }.padding(.vertical, 20)
            VStack {
                Form {
                    Section(){
                        TextField("Título", text: $titulo)
                        Picker(selection: $alertasIndex, label: Text("Alerta")) {
                            ForEach(0 ..< alertas.count) {
                                Text(self.alertas[$0])
                            }
                        }
                        HStack {
                            DatePicker("Data Final", selection: $dataFinalSalvar, displayedComponents: [.date])
                        }
                    }
                    Section(header: Text("Anotações")){
                        TextEditor(text: $anotacao)
                            .frame(height: altura * 0.2)
                    }
                }
            }
        }
        .navigationBarTitle("Salvar Data")
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button  {
                    model.salvar(tituloSalvo: titulo, anotacoesSalvo: anotacao, dataFinalSalvo: dataFinalSalvar)
                    dismiss()
                } label: {
                    Text("Salvar")
                }
            }
        }
    }
}
