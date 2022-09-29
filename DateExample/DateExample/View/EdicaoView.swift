//
//  EditcaoView.swift
//  DateExample
//
//  Created by Bruno Lafayette on 22/09/22.
//

import SwiftUI

struct EdicaoView: View {
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var evento: EventoViewModel
    @Binding var lista: Dados
    @State var dataFinalSalvar: Date
    @State var titulo: String
    @State var anotacao: String
    @State var id: UUID
    @State var idLembrete: UUID
    @State var dataLembrete: Date
    @State var ativaLembrete: Bool
    @State var mostrarAlerta = false

    
    private let altura = UIScreen.main.bounds.size.height
    
    private var resultado: DateComponents {
        return Calendar.current.dateComponents([.day,.hour,.minute,.second],
                                               from: Date(),
                                               to: lista.dataFinal)
    }
    
    
    var body: some View {
        VStack {
            VStack {
                Text("\(lista.dataFinal.formatted(.dateTime.day().month().year()))")
                    .font(.system(size: 19, weight: .regular, design: .rounded))
                Text("\(resultado.day ?? 0) dias")
                    .font(.system(size: 19, weight: .regular, design: .rounded))
            }
            VStack {
                Form {
                    Section(){
                        TextField("Título", text: $titulo)
                            .font(.system(size: 19, weight: .regular, design: .rounded))
                            .onReceive(lista.titulo.publisher.collect()) {
                                lista.titulo = String($0.prefix(20))
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
                                        .id(dataLembrete)
                                Spacer()
                            }
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
            }.onTapGesture{
                evento.esconderTeclado()
            }
        }
        .background(Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00))
        .navigationBarTitle("Editar Evento")
        .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
        .alert(isPresented: $mostrarAlerta) {
            if titulo == ""{
                
                return Alert(title: Text("Atenção"), message: Text("Insira um título ao evento para salvar"), dismissButton: .default(Text("Ok")))
            }else{
                return Alert(title: Text("Atenção"), message: Text("A data de notificação não pode ser superior a data do evento"), dismissButton: .default(Text("Ok")))
            }
        }
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button  {
                    if titulo == "" || dataLembrete > dataFinalSalvar{
                        self.mostrarAlerta.toggle()
                    } else {
                    evento.editarDados(titulo: titulo,
                                       anotacao: anotacao,
                                       id: lista.id,
                                       dataFinalSalvar: dataFinalSalvar,
                                       idLembrete: idLembrete,
                                       dataLembrete: dataLembrete,
                                       ativaLembrete: ativaLembrete)
                dismiss()
                }
                } label: {
                    Text("Salvar")
                }
            }
        }
    }
}
