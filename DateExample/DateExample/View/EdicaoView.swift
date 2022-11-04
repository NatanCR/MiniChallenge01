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
    @Binding var listaEvento: EventoAtualizado
    @State var dataFinalSalvar: Date
    @State var titulo: String
    @State var anotacao: String
    @State var id: UUID
    @State var idLembrete: UUID
    @State var dataLembrete: Date
    @State var ativaLembrete: Bool
    @State private var mostrarAlerta = false
    @State private var contadorCaracter = 0
    @State var ativaCalendario: Bool
    @State var idCalendario: String?
    @State private var selecionarCalendario = 1
    let calendario = Calendar(identifier: .gregorian)
    @State private var confirmaAlerta = false
    private let altura = UIScreen.main.bounds.size.height
    
    var indiceCalendario: Int{
        let agenda = eventoModel.calendarioEventos.events(matching: eventoModel.periodo())
        if idCalendario != nil{
            for j in 0 ..< agenda.count{
                if agenda[j].eventIdentifier == idCalendario!{
                    for i in 0 ..< eventoModel.listaCalendario.count{
                        if agenda[j].calendar!.calendarIdentifier == eventoModel.listaCalendario[i].calendarIdentifier{
                            return i
                        }
                    }
                }
            }
        }
        return 0
    }

    var customLabel: some View {
        HStack {
            Text("Calendário")
                .font(.system(size: 17, weight: .regular, design: .rounded))
            Spacer()
            Picker("selecionar",selection: $selecionarCalendario) {
                ForEach(0 ..< eventoModel.listaCalendario.count, id:\.self){ evento in
                    if eventoModel.listaCalendario[evento].title != "Feriados" && eventoModel.listaCalendario[evento].title != "Sugestões da Siri" && eventoModel.listaCalendario[evento].title != "Aniversários" {
                        Text(eventoModel.listaCalendario[evento].title)
                            .font(.system(size: 15, weight: .regular, design: .rounded))
                    }
                }
            }
            .pickerStyle(.menu)
            Image(systemName: "chevron.up.chevron.down")
                .offset(x: -5)
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                Text("\(ConversorData.conversorDataString(dataParaConversao: dataFinalSalvar, recebeData: ""))")
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                    .accessibilityRemoveTraits(.isStaticText)
                Text("\(calendario.contadorDiasAte(dataFinal: dataFinalSalvar, calculo: "corridos")) dias corridos")
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                    .accessibilityRemoveTraits(.isStaticText)
            }
            .padding()
            VStack {
                Form {
                    Section(){
                        TextField("Título", text: $titulo)
                            .accessibilityHint(Text("Título do seu evento"))
                            .font(.system(size: 19, weight: .regular, design: .rounded))
                            .onReceive(titulo.publisher.collect()) {
                                titulo = String($0.prefix(20))
                            }.accessibilityRemoveTraits(.isStaticText)
                        HStack {
                            Text("Data do evento")
                                .font(.system(size: 19, weight: .semibold, design: .rounded))
                            Spacer()
                            DatePicker("", selection: $dataFinalSalvar,
                                       in: Date()...Date.distantFuture,
                                       displayedComponents: [.date])
                        }
                    }
                    Section() {
                        Toggle(isOn: $ativaLembrete) {
                            Text("Ativar notificação")
                                .font(.system(size: 19, weight: .semibold, design: .rounded))
                        }.accessibilityHint(Text("Ative para receber notificação do seu evento"))
                        if ativaLembrete{
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
                    }.id(dataLembrete)
                    Section() {
                        Toggle(isOn: $ativaCalendario) {
                            Text("Adicionar ao Calendario")
                                .font(.system(size: 19, weight: .semibold, design: .rounded))
                        }.disabled(!eventoModel.permissaoCalendario!)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if !eventoModel.permissaoCalendario!{
                                    self.mostrarAlerta.toggle()
                                }
                            }
                        if ativaCalendario {
                            customLabel
                        }
                    }
                    
                    Section(header: Text("Notas")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .accessibilityRemoveTraits(.isStaticText)
                                .foregroundColor(Color.gray)){
                        TextEditor(text: $anotacao)
                            .frame(height: altura * 0.2)
                            .accessibilityHint(Text("Adicione uma nota ao seu evento"))
                    }
                    Button(role: .destructive) {
                        confirmaAlerta = true
                    } label: {
                        Text("Apagar evento")
                            .font(.system(size: 17, weight: .regular, design: .default))
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.red)
                    }
                    .confirmationDialog("Deseja realmente apagar seu evento?",
                                        isPresented: $confirmaAlerta) {
                        Button("Apagar evento", role: .destructive) {
                            eventoModel.botaoRemoverEvento(id: self.id)
                        }
                    }
                                        .tint(.white)
                                        .buttonStyle(.borderedProminent)
                                        .frame(maxHeight: 5)
                                        .padding()
                }
                .onAppear {
                    UITableView.appearance().backgroundColor = .clear
                    selecionarCalendario = indiceCalendario
                }
            }
            .onTapGesture{
                eventoModel.esconderTeclado()
            }
        }
        .background(Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00))
        .navigationBarTitle("Editar evento")
        .accessibilityRemoveTraits(.isStaticText)
        .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
        .alert(isPresented: $mostrarAlerta) {
            if titulo == ""{
                return Alert(title: Text("Não foi possível salvar seu evento"), message: Text("Insira um título ao evento."), dismissButton: .default(Text("Ok")))
            }else if dataLembrete > dataFinalSalvar {
                return Alert(title: Text("Não foi possível salvar seu evento"), message: Text("Insira a data de notificação anterior a data do evento."), dismissButton: .default(Text("Ok")))
            } else {
                return Alert(title: Text("Permita acesso ao calendario"), message: Text("Altere as configuracoes no menu."), primaryButton: .default(Text("Ajustes"), action: {
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }),
                             secondaryButton: .cancel(Text("Agora não")))
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button  {
                    if titulo == "" || dataLembrete > dataFinalSalvar{
                        self.mostrarAlerta.toggle()
                    } else {
                        eventoModel.editarDados(titulo: titulo,
                                                anotacao: anotacao,
                                                id: listaEvento.id,
                                                dataFinalSalvar: dataFinalSalvar,
                                                idLembrete: idLembrete,
                                                dataLembrete: dataLembrete,
                                                ativaLembrete: ativaLembrete,
                                                eventoCalendario: ativaCalendario,
                                                idCalendario: idCalendario,
                                                calendario: eventoModel.listaCalendario[selecionarCalendario].calendarIdentifier, indexCalendario: selecionarCalendario)
                        dismiss()
                    }
                } label: {
                    Text("Salvar")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .accessibilityRemoveTraits(.isStaticText)
                }
            }
        }
    }
}
