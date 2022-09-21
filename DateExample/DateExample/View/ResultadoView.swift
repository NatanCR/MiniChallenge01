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
    @State var id: UUID?
    @State var modoEditar = false
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
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                Text("\(resultado.day ?? 0) dias")
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                    
            }
            .background(Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00))
            VStack {
                Form {
                    Section(){
                        TextField("Título", text: $titulo)
                            .font(.system(size: 19, weight: .regular, design: .rounded))
                            .onReceive(titulo.publisher.collect()) {
                                    titulo = String($0.prefix(20))
                            }
                        Toggle(isOn: $ativaLembrete) {
                            Text("Ativar notificação")
                                .font(.system(size: 19, weight: .semibold, design: .rounded))
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
                                    .font(.system(size: 19, weight: .semibold, design: .rounded))
                            }
                    }
                    
                    Section(header: Text("Notas")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.gray)){
                        TextEditor(text: $anotacao)
                            .frame(height: altura * 0.2)
                    }
                }
                .onAppear {
                  UITableView.appearance().backgroundColor = .clear
                }
                .background(Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00)) // Segunda cor
//                                 (red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00)) Primeira cor
//                                  UIColor(red: 0.89, green: 0.92, blue: 0.94, alpha: 1.00) Terceira cor
                .padding(.top, -10)
            }
        }
        .navigationBarTitle("Adicionar Evento")
        .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
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
