//
//  Resultado.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import Foundation

import SwiftUI

struct ResultadoView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var model: Model
    @State var dataFinalSalvar = Date()
    @State private var alertasIndex = 0
    @State var titulo: String = ""
    @State var anotacao: String = ""
    @State var modoEditar = false
    @State var id: UUID?
    @State var dataLembrete: Date
    @State var ativaLembrete = false
    @State var ativaCalendario = false

    
    private let altura = UIScreen.main.bounds.size.height
    private var resultado: DateComponents {
        return Calendar.current.dateComponents([.day,.hour,.minute,.second],
                                               from: Date(),
                                               to: dataFinalSalvar)
    }
    
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
                                    DatePicker("", selection: $dataLembrete,
                                               displayedComponents: [.date, .hourAndMinute])
                                        .labelsHidden()
                                        .fixedSize()
                                Spacer()
                            }
                        }
                        
                    }
                    if !modoEditar{
                        
                            Toggle(isOn: $ativaCalendario) {
                                Text("Adicionar ao Calendario")
                            }
                        
                    }
                    
                    Section(header: Text("Notas")){
                        TextEditor(text: $anotacao)
                            .frame(height: altura * 0.2)
                    }
                }
            }
        }
        .navigationBarTitle("Adicionar Evento")
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button  {
                    if modoEditar == false {
                        model.salvar(tituloSalvo: titulo,
                                     anotacoesSalvo: anotacao,
                                     dataFinalSalvo: dataFinalSalvar,
                                     dataLembrete: dataLembrete,
                                     ativaLembrete: ativaLembrete,
                                     idLembrete: UUID())
                        if ativaCalendario{
                            AdicionarCalendario.requestAccessToCalendar(dataFinalSalvar: resultado.day!,
                                                                    anotacao: anotacao,
                                                                    titulo: titulo)
                        }
                        Notificacoes.permissao()
                        
                    } else {
                        for i in 0..<model.anotacoes.count {
                            if id == model.anotacoes[i].id {
                                model.editarEvento(titulo: titulo,
                                                   anotacao: anotacao,
                                                   id: model.anotacoes[i].id,
                                                   dataFinalSalvar: dataFinalSalvar,
                                                   idLembrete: model.anotacoes[i].idLembrete,
                                                   dataLembrete: dataLembrete,
                                                   ativaLembrete: ativaLembrete)
                            }
                        }
                    }
                    dismiss()
                } label: {
                    Text("Salvar")
                }
            }
        }
    }
}
