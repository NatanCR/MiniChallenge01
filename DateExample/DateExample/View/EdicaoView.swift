//
//  EditcaoView.swift
//  DateExample
//
//  Created by Bruno Lafayette on 22/09/22.
//

import SwiftUI

struct EdicaoView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var eventoModel: EventoViewModel
    @Binding var listaEvento: Evento
    @State var dataFinalSalvar: Date
    @State var titulo: String
    @State var anotacao: String
    @State var id: UUID
    @State var idLembrete: UUID
    @State var dataLembrete: Date
    @State var ativaLembrete: Bool
    @State var ativaCalendario: Bool
    @State var idCalendario: String?
    @State var selecionarCalendario = 1
    @State var mostrarAlerta = false
    @State private var contadorCaracter = 0
    let teste = ["um", "dois", "tres", "quatro", "cinco", "seis"]
    let calendario = Calendar(identifier: .gregorian)

    var customLabel: some View {
        HStack {
            Text("Calendário")
            Spacer()
            Picker("Calendário",selection: $selecionarCalendario) {
                ForEach(0 ..< eventoModel.listaCalendario.count, id:\.self){ evento in
                    Text(eventoModel.listaCalendario[evento].title)

                }
            }
            .pickerStyle(.menu)
            Image(systemName: "chevron.up.chevron.down")
                .offset(x: -5)
        }
    }
    
    
    
    private let altura = UIScreen.main.bounds.size.height
    
    var body: some View {
        VStack {
            VStack {
                Text("\(listaEvento.dataFinal.formatted(.dateTime.day().month().year()))")
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                Text("\(calendario.contadorDiasAte(dataFinal: dataFinalSalvar, calculo: "corridos")) dias")
                    .font(.system(size: 19, weight: .regular, design: .rounded))
            }
            VStack {
                Form {
                    Section(){
                        TextField("Título", text: $titulo)
                            .font(.system(size: 19, weight: .regular, design: .rounded))
                            .onReceive(listaEvento.titulo.publisher.collect()) {
                                listaEvento.titulo = String($0.prefix(20))
                            }
                        Toggle(isOn: $ativaLembrete) {
                            Text("Ativar notificação")
                                .font(.system(size: 19, weight: .semibold, design: .rounded))
                        }
                        if ativaLembrete{
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
                        Toggle(isOn: $ativaCalendario) {
                                Text("Adicionar ao Calendario")
                                    .font(.system(size: 19, weight: .semibold, design: .rounded))
                            }
                        if ativaCalendario{
//                  levar para outra view para selecionar qual calendario sera adicionado o evento
//                            Picker("Calendário",selection: $selecionarCalendario) {
//                                ForEach(0 ..< eventoModel.listaCalendario.count, id:\.self){ evento in
//                                    Text(eventoModel.listaCalendario[evento].title)
//                                }
//                            }
//                            .pickerStyle(.menu)
//                            Picker(selection: $selecionarCalendario) {
//                                ForEach(0 ..< eventoModel.listaCalendario.count, id:\.self){ evento in
//                                    Text(eventoModel.listaCalendario[evento].title)
//                                }
//                            } label: {
//                                Text("Calendario")
//                            }

                            
                            
                            customLabel
                                
                        }
                        
                        
                        
                    }.id(dataLembrete)
                    
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
            }.onTapGesture{
                eventoModel.esconderTeclado()
            }
        }
        .background(Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00))
        .navigationBarTitle("Editar evento")
        .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
        .alert(isPresented: $mostrarAlerta) {
            if titulo == ""{
                return Alert(title: Text("Não foi possível salvar seu evento"), message: Text("Insira um título ao evento."), dismissButton: .default(Text("Ok")))
            }else{
                return Alert(title: Text("Não foi possível salvar seu evento"), message: Text("Insira a data de notificação anterior a data do evento."), dismissButton: .default(Text("Ok")))
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button  {
                    if titulo == "" || dataLembrete > dataFinalSalvar{
                        self.mostrarAlerta.toggle()
                    } else {
                    eventoModel.editarDados(titulo: titulo,
                                            anotacao: anotacao, id: id,
                                            dataFinalSalvar: dataFinalSalvar,
                                            idLembrete: idLembrete,
                                            dataLembrete: dataLembrete,
                                            ativaLembrete: ativaLembrete,
                                            eventoCalendario: ativaCalendario,
                                            idCalendario: idCalendario,
                                            calendario: eventoModel.listaCalendario[selecionarCalendario].calendarIdentifier)
                dismiss()
                }
                } label: {
                    Text("Salvar")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                }
            }
        }
    }
}
