//
//  Resultado.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import Foundation
import SwiftUI

struct AdicionarEventoView: View {
    
//    @Environment(\.dismiss) private var dismiss
    @StateObject var eventoModel: EventoViewModel
    @State var selecionarCalendario = 1
    @State var dataFinalSalvar = Date()
    @State var titulo: String = ""
    @State var anotacao: String = ""
    @State var id: UUID?
    @State var idCalendario: String?
    @State var dataLembrete: Date
    @State var ativaLembrete = false
    @State var ativaCalendario = false
    @State var mostrarAlerta = false
    @State var modoEditar = false
    @State private var alertasIndex = 0
    @State private var contadorCaracter = 0
    @Environment(\.currentTab) var tab
    @Binding var mostrarTela: Bool
    let calendario = Calendar(identifier: .gregorian)
    let mvCalendario = Calendario()
    
    private let altura = UIScreen.main.bounds.size.height
    
    var body: some View {
        VStack {
            VStack {
                Text("\(dataFinalSalvar.formatted(.dateTime.day().month().year()))")
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                Text("\(calendario.contadorDiasAte(dataFinal: dataFinalSalvar, calculo: "corridos")) dias")
                    .font(.system(size: 19, weight: .regular, design: .rounded))
            }
            .padding()
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
                                           in: Date()...Date.distantFuture,
                                           displayedComponents: [.date, .hourAndMinute])
                                    .labelsHidden()
                                    .datePickerStyle(.automatic)
                                    .environment(\.locale, Locale.init(identifier: "pt_BR"))
                                Spacer()
                            }
                        }
                    }
                    .id(dataLembrete)
                    Toggle(isOn: $ativaCalendario) {
                            Text("Adicionar ao Calendario")
                                .font(.system(size: 19, weight: .semibold, design: .rounded))
                        }
                    if ativaCalendario{
                        // levar para outra view para selecionar qual calendario sera adicionado o evento
                        Picker("Calendário",selection: $selecionarCalendario) {
                            ForEach(0 ..< eventoModel.listaCalendario.count, id:\.self){ evento in
                                Text(eventoModel.listaCalendario[evento].title).tag(evento)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                    
                    Section(header: Text("Notas")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.gray)){
                        TextEditor(text: $anotacao)
                            .frame(height: altura * 0.2)
                            .onReceive(anotacao.publisher.collect()) {
                                anotacao = String($0.prefix(100))
                            }
                            .onChange(of: anotacao) { newValue in
                                contadorCaracter = newValue.count
                            }
                        Text("\(contadorCaracter)/100")
                            .foregroundColor(contadorCaracter == 100 ? .gray : Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
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
                                                  idLembrete: UUID(),
                                                  adicionarCalendario: ativaCalendario,
                                                  calendarioAdicionar: selecionarCalendario)
                        Notificacoes.permissao()
                        mostrarTela = false
//                        dismiss()
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
