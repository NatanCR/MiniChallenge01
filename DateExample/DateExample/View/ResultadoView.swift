//
//  Resultado.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import Foundation

import SwiftUI

struct ResultadoView: View {
    
    @State private var alertasIndex = 0
    
    @EnvironmentObject var model: Model
    
    @State var dataFinalSalvar = Date()
    var resultado: DateComponents {
        return Calendar.current.dateComponents([.day,.hour,.minute,.second], from: Date(), to: dataFinalSalvar)
    }
    @State var titulo: String = ""
    @State var anotacao: String = ""
    @State var modoEditar = false
    @State var id: UUID?
    @State var dataLembrete = Date()
    @State var ativaLembrete = false
    
    @Environment(\.dismiss) private var dismiss
    let altura = UIScreen.main.bounds.size.height
    
    var body: some View {
        VStack {
            VStack {
                Text("\(dataFinalSalvar.formatted(.dateTime.day().month().year()))")
                Text("\(resultado.day ?? 0) dias")
            }.padding(.vertical, 20)
            VStack {
                Form {
                    Section(){
                        TextField("Título", text: $titulo)
                        
                            
                        Toggle(isOn: $ativaLembrete) {
                            Text("Ativar notificação")
                        }
                        if ativaLembrete == true {
                            HStack {
                                Spacer()
                                DatePicker("", selection: $dataLembrete, displayedComponents: [.date, .hourAndMinute])
                                    .labelsHidden()
                                Spacer()
                            }
                        }
                        
                    }
                    Section(header: Text("Notas")){
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
                    if modoEditar == false {
                        model.salvar(tituloSalvo: titulo, anotacoesSalvo: anotacao, dataFinalSalvo: dataFinalSalvar, dataLembrete: dataLembrete, ativaLembrete: ativaLembrete, idLembrete: UUID())
//                        Notificacoes.criarLembrete(date: dataLembrete, titulo: titulo, dataEvento: CalcularDatas.dateToString(indice: 0, date: dataFinalSalvar), id: UUID())
                        Notificacoes.permissao()
                    } else {
                        for i in 0..<model.anotacoes.count {
                            if id == model.anotacoes[i].id {
                                model.editarEvento(titulo: titulo, anotacao: anotacao, id: id!, dataFinalSalvar: dataFinalSalvar, idLembrete: UUID(), dataLembrete: dataLembrete, ativaLembrete: ativaLembrete)
                            }
                        }
                        
//                        for i in 0..<model.anotacoes.count{
//                            if id == model.anotacoes[i].id{
//                                model.anotacoes[i].titulo = titulo
//                                model.anotacoes[i].anotacoes = anotacao
//                                model.anotacoes[i].dataFinal = dataFinalSalvar
//                                if let valoresCodificados = try? JSONEncoder().encode(model.anotacoes) {
//                                    UserDefaults.standard.set(valoresCodificados, forKey: "listaDados")
//                                }
//                            }
                        }
//                    }
                    dismiss()
                } label: {
                    Text("Salvar")
                }
            }
        }
    }
}
