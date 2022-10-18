//
//  DetalhesView.swift
//  DateExample
//
//  Created by Natan Rodrigues on 13/09/22.
//

import SwiftUI

struct DetalhesView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var eventoModel: EventoViewModel
    @State var agenda: Evento
    
    var resultado: DateComponents {
        return Calendar.current.dateComponents([.day,.hour,.minute,.second], from: Date(), to: agenda.dataFinal)
    }
    private let grid = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ScrollView {
        VStack {
            Text(ConversorData.conversorDataString(dataParaConversao: agenda.dataFinal))
                .font(.system(size: 17, weight: .regular, design: .rounded))
                .padding(.vertical, 30)
                .accessibilityRemoveTraits(.isStaticText)
            Text("Tempo restante")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .accessibilityRemoveTraits(.isStaticText)
            Text("para seu evento")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
                .accessibilityRemoveTraits(.isStaticText)
            
            LazyVGrid(columns: grid, spacing: 30) {
                ZStack {
                    VStack {
                        Text("\(eventoModel.calendario.contadorDiasAte(dataFinal: agenda.dataFinal, calculo: "corridos"))")
                            .font(.system(size: 30, weight: .regular, design: .rounded))
                            .accessibilityRemoveTraits(.isStaticText)
                        if ("\(eventoModel.calendario.contadorDiasAte(dataFinal: agenda.dataFinal, calculo: "corridos"))") == "1" {
                            Text("Dia corrido")
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                .accessibilityRemoveTraits(.isStaticText)
                        }else {
                            Text("Dias corridos")
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                .accessibilityRemoveTraits(.isStaticText)
                        }
                    }
                }
                ZStack {
                    VStack {
                        Text("\(eventoModel.calendario.contadorDiasAte(dataFinal: agenda.dataFinal, calculo: "semanas"))")
                            .font(.system(size: 30, weight: .regular, design: .rounded))
                            .accessibilityRemoveTraits(.isStaticText)
                        if ("\(eventoModel.calendario.contadorDiasAte(dataFinal: agenda.dataFinal, calculo: "semanas"))") == "1" {
                            Text("Semana")
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                .accessibilityRemoveTraits(.isStaticText)
                        } else{
                            Text("Semanas")
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                .accessibilityRemoveTraits(.isStaticText)
                        }
                    }
                }
                
                ZStack {
                    VStack {
                        Text("\(eventoModel.calendario.contadorDiasAte(dataFinal: agenda.dataFinal, calculo: "uteis"))")
                            .font(.system(size: 30, weight: .regular, design: .rounded))
                            .accessibilityRemoveTraits(.isStaticText)
                        if ("\(eventoModel.calendario.contadorDiasAte(dataFinal: agenda.dataFinal, calculo: "uteis"))") == "1" {
                            Text("Dia de semana")
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                .accessibilityRemoveTraits(.isStaticText)
                        } else {
                            Text("Dias de semana")
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                .accessibilityRemoveTraits(.isStaticText)
                        }
                    }
                }
                ZStack {
                    VStack {
                        Text("\(eventoModel.calendario.contadorDiasAte(dataFinal: agenda.dataFinal, calculo: "finais"))")
                            .font(.system(size: 30, weight: .regular, design: .rounded))
                            .accessibilityRemoveTraits(.isStaticText)
                        if ("\(eventoModel.calendario.contadorDiasAte(dataFinal: agenda.dataFinal, calculo: "finais"))") == "1" {
                            Text("Final de semana")
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                .accessibilityRemoveTraits(.isStaticText)
                        }else{
                            Text("Finais de semana")
                                .font(.system(size: 17, weight: .regular, design: .rounded))
                                .multilineTextAlignment(.center)
                                .accessibilityRemoveTraits(.isStaticText)
                        }
                    }
                }
                Spacer()
                
            }
            VStack {
                VStack {
                    Text("Notas")
                        .font(.system(size: 19, weight: .semibold, design: .rounded))
                        .accessibilityRemoveTraits(.isStaticText)
                    if agenda.anotacoes != "" {
                        Text(agenda.anotacoes)
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                            .multilineTextAlignment(.center)
                            .accessibilityRemoveTraits(.isStaticText)
                    }else{
                        Text("Nenhuma nota")
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                            .accessibilityRemoveTraits(.isStaticText)
                    }
                }
                .padding(.vertical, 30)
                .padding(.horizontal, 8)
                VStack{
                    Text("Notificação")
                        .font(.system(size: 19, weight: .semibold, design: .rounded))
                        .accessibilityRemoveTraits(.isStaticText)
                    if agenda.dataLembrete != nil{
                        Text("Lembrar-me \(converterDataDetalhes(date: agenda.dataLembrete))")
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                            .multilineTextAlignment(.center)
                            .accessibilityRemoveTraits(.isStaticText)
                    }else{
                        Text("Nenhuma")
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                            .accessibilityRemoveTraits(.isStaticText)
                    }
                }
            }
            Spacer()
        }
    }
        .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
        Spacer()
        .navigationBarBackButtonHidden(true)
        .navigationTitle(agenda.titulo)
        .accessibilityRemoveTraits(.isStaticText)
       
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                        Text("Seus eventos")
                    }
                })
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    EdicaoView(eventoModel: eventoModel, listaEvento: $agenda,
                               dataFinalSalvar: agenda.dataFinal,
                               titulo: agenda.titulo,
                               anotacao: agenda.anotacoes,
                               id: agenda.id,
                               idLembrete: agenda.idLembrete,
                               dataLembrete: agenda.dataLembrete ?? Date(),
                               ativaLembrete: agenda.ativaLembrete)
                    .environmentObject(eventoModel)
                } label: {
                    Text("Editar")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                        .accessibilityRemoveTraits(.isStaticText)
                }.disabled(eventoModel.calendario.calculoDiasCorridos(dataFinal: agenda.dataFinal) < 0)
            }
        }
    }
    
    
    func converterDataDetalhes (date: Date?) -> String {
        if date != nil{
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "pt_BR")
            dateFormatter.dateFormat = "EEEE\nd MMMM yyyy - HH:mm"
            return dateFormatter.string(from: date!)
        }
        return "Sem data marcada"
    }

}
