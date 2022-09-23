//
//  DetalhesView.swift
//  DateExample
//
//  Created by Natan Rodrigues on 13/09/22.
//

import SwiftUI

struct DetalhesView: View {
    
    @EnvironmentObject var lista: EventoViewModel
    @Binding var agenda: Dados
    
    var resultado: DateComponents {
        return Calendar.current.dateComponents([.day,.hour,.minute,.second], from: Date(), to: agenda.dataFinal)
    }
    private let grid = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        VStack {
            Text(CalcularDatas.conversorDataString(dataParaConversao: agenda.dataFinal))
                .font(.system(size: 17, weight: .regular, design: .rounded))
                .padding(.vertical, 30)
            Text("Tempo restante")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
            Text("para seu evento")
                .font(.system(size: 17, weight: .semibold, design: .rounded))
            
            LazyVGrid(columns: grid, spacing: 30) {
                ZStack {
                    VStack {
                        Text("\(resultado.day!)")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("Dias corridos")
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                    }
                }
                ZStack {
                    VStack {
                        Text("\(CalcularDatas.calcularSemanas(dataInicio: Date(), totalDias: resultado.day ?? 0))")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("Semanas")
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                    }
                }
                
                ZStack {
                    VStack {
                        Text("\(CalcularDatas.calcularDiasUteis(totalDias: resultado.day ?? 0, dataInicio: Date()))")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("Dias da semana")
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                    }
                }
                ZStack {
                    VStack {
                        Text("\(CalcularDatas.calcularFinaisSemana(totalDias: resultado.day ?? 0, diaInicio: Date()))")
                            .font(.system(size: 30, weight: .semibold, design: .rounded))
                        Text("Finais de Semana")
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                    }
                }
                Spacer()
                
            }
            VStack {
                VStack {
                    Text("Notas")
                        .font(.system(size: 19, weight: .semibold, design: .rounded))
                    if agenda.anotacoes != "" {
                        Text(agenda.anotacoes)
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                            .multilineTextAlignment(.center)
                    }else{
                        Text("Nenhuma nota")
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                    }
                }
                .padding(.vertical, 30)
                VStack{
                    Text("Notificação")
                        .font(.system(size: 19, weight: .semibold, design: .rounded))
                    if agenda.dataLembrete != nil{
                        Text("Me lembrar \(converterDataDetalhes(date: agenda.dataLembrete))")
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                            .multilineTextAlignment(.center)
                    }else{
                        Text("Nenhuma")
                            .font(.system(size: 17, weight: .regular, design: .rounded))
                    }
                }
            }
            Spacer()
        }
        .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
        Spacer()
        
        .navigationTitle(agenda.titulo)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink {
                    EdicaoView(lista: $agenda,
                               dataFinalSalvar: agenda.dataFinal,
                               titulo: agenda.titulo,
                               anotacao: agenda.anotacoes,
                               id: agenda.id,
                               idLembrete: agenda.idLembrete,
                               dataLembrete: agenda.dataLembrete ?? Date(),
                               ativaLembrete: agenda.ativaLembrete)
                    .environmentObject(lista)
                } label: {
                    Text("Editar")
                        .font(.system(size: 17, weight: .semibold, design: .rounded))
                }
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
