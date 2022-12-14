//
//  Resultado.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import Foundation
import SwiftUI

struct AdicionarEventoView: View {
    
    @StateObject var eventoModel: EventoViewModel
    @State var dataFinalSalvar = Date()
    @State private var alertasIndex = 0
    @State var titulo: String = ""
    @State var anotacao: String = ""
    @State var id: UUID?
    @State var modoEditar = false
    @State var dataLembrete: Date
    @State var ativaLembrete = false
    @State var ativaCalendario = false
    @State var mostrarAlerta = false
    @State private var contadorCaracter = 0
    @Environment(\.currentTab) var tab
    @Binding var mostrarTela: Bool
    
    private let altura = UIScreen.main.bounds.size.height
    
    var body: some View {
        VStack {
            VStack {
                Text("\(dataFinalSalvar.formatted(.dateTime.day().month().year()))")
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                    .accessibilityRemoveTraits(.isStaticText)
                Text("\(eventoModel.calendario.contadorDiasAte(dataFinal: dataFinalSalvar, calculo: "corridos")) dias")
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                    .accessibilityRemoveTraits(.isStaticText)
            }
            .padding()
            VStack {
                Form {
                    Section(){
                        TextField("Título", text: $titulo)
                            .accessibilityRemoveTraits(.isStaticText)
                            .accessibility(hint: Text("Titulo do seu evento"))
                            .font(.system(size: 19, weight: .regular, design: .rounded))
                            .onReceive(titulo.publisher.collect()) {
                                titulo = String($0.prefix(20))
                            }
                        Toggle(isOn: $ativaLembrete) {
                            Text("Ativar notificação")
                                .font(.system(size: 19, weight: .semibold, design: .rounded))
                                
                        }.accessibilityHint(Text("Ative para receber notificação do seu evento"))
                        if ativaLembrete == true {
                            HStack {
                                Spacer()
                                DatePicker("", selection: $dataLembrete,
                                           in: Date()...Date.distantFuture,
                                           displayedComponents: [.date, .hourAndMinute])
                                    .labelsHidden()
                                    .datePickerStyle(.automatic)
                                    .environment(\.locale, Locale.init(identifier: "pt_BR"))
                                    .accessibilityHint(Text("Escolha a data para receber a notificacao"))
                                Spacer()
                            }
                        }
                    }
                    .id(dataLembrete)
                    Toggle(isOn: $ativaCalendario) {
                            Text("Adicionar ao Calendário")
                           
                                .font(.system(size: 19, weight: .semibold, design: .rounded))
                        }.accessibilityHint(Text("Evento será adicionado no calendário"))
                    
                    Section(header: Text("Notas")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .accessibilityRemoveTraits(.isStaticText)
                                .foregroundColor(Color.gray)){
                        TextEditor(text: $anotacao)
                            .accessibilityHint(Text("Adicione uma nota ao seu evento"))
                            .frame(height: altura * 0.2)
                            .onReceive(anotacao.publisher.collect()) {
                                anotacao = String($0.prefix(100))
                            }
                            .onChange(of: anotacao) { newValue in
                                contadorCaracter = newValue.count
                            }
                        HStack {
                            Text("Limite de caractéres: ")
                                .accessibilityRemoveTraits(.isStaticText)
                            Spacer()
                            Text("\(contadorCaracter)/100")
                                    .foregroundColor(contadorCaracter == 100 ? .gray : Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                                    .accessibilityRemoveTraits(.isStaticText)
                        }
                    }
                }
                .onAppear {
                    UITableView.appearance().backgroundColor = .clear
                }
            }
            .onTapGesture{
                eventoModel.esconderTeclado()
            }
        }
        .background(Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00))
        .navigationBarTitle("Adicionar evento")
       
        .navigationBarBackButtonHidden(true)
        .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
        .alert(isPresented: $mostrarAlerta) {
            if titulo == ""{
                return Alert(title: Text("Não foi possível salvar seu evento"), message: Text("Insira um título ao evento."), dismissButton: .default(Text("Ok")))
                  
                    
            }else{
                return Alert(title: Text("Não foi possível salvar seu evento"), message: Text("Insira a data de notificação anterior a data do evento."), dismissButton: .default(Text("Ok")))
            }
        }
        .accessibilityRemoveTraits(.isStaticText)
        .accessibilityRemoveTraits(.isHeader)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    mostrarTela = false
                }, label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                        Text("Contador")
                    }
                })
            }
          
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    titulo = titulo.trimmingCharacters(in: .whitespacesAndNewlines)
                    if titulo == "" || dataLembrete > dataFinalSalvar {
                        self.mostrarAlerta.toggle()
                    } else {
                        eventoModel.adicionarNovo(tituloSalvo: titulo,
                                            anotacoesSalvo: anotacao,
                                            dataFinalSalvo: dataFinalSalvar,
                                            dataLembrete: dataLembrete,
                                            ativaLembrete: ativaLembrete,
                                            idLembrete: UUID())
                        if ativaCalendario {
                            Calendario.adicionarEvento(dataFinalSalvar: eventoModel.calendario.contadorDiasAte(dataFinal: dataFinalSalvar, calculo: "corridos"),
                                                       anotacao: anotacao,
                                                       titulo: titulo)
                        }
                        Notificacoes.permissao()
                        mostrarTela = false
                        tab.wrappedValue = .lista
                    }
                } label: {
                    Text("Salvar")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                }
            }
        }
    }
}
