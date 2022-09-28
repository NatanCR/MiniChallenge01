//
//  Resultado.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import Foundation
import SwiftUI

struct AdicionarEventoView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var model: EventoViewModel
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
                                        .id(dataLembrete)
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
            }
        }
        .background(Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00))
        .navigationBarTitle("Adicionar Evento")
        .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
        .alert(isPresented: $mostrarAlerta) {
            if titulo == ""{
                return Alert(title: Text("Não foi possível salvar seu evento"), message: Text("Insira um título ao evento."), dismissButton: .default(Text("Ok")))
            } else if resultado.day == 0{
                return Alert(title: Text("Não foi possível salvar seu evento"), message: Text("Você tem menos de um dia para seu evento."), dismissButton: .default(Text("Ok")))
            }else{
                return Alert(title: Text("Não foi possível salvar seu evento"), message: Text("Insira a data de notificação anterior a data do evento."), dismissButton: .default(Text("Ok")))
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button  {
                    if titulo == "" || dataLembrete > dataFinalSalvar || resultado.day == 0 {
                        self.mostrarAlerta.toggle()
                    } else {
                        model.adicionarNovo(tituloSalvo: titulo,
                                     anotacoesSalvo: anotacao,
                                     dataFinalSalvo: dataFinalSalvar,
                                     dataLembrete: dataLembrete,
                                     ativaLembrete: ativaLembrete,
                                     idLembrete: UUID())
                        if ativaCalendario{
                            Calendario.adicionarEvento(dataFinalSalvar: resultado.day!,
                                                                    anotacao: anotacao,
                                                                    titulo: titulo)
                        }
                        Notificacoes.permissao()
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
