//
//  DetalhesView.swift
//  DateExample
//
//  Created by Natan Rodrigues on 13/09/22.
//

import SwiftUI

struct DetalhesView: View {
    
    var lembrete: Date?
    var id: UUID
    var titulo: String
    var anotacao: String
    var dataFinal: Date
    @State private var opcoes = false
    var resultado: DateComponents {
        return Calendar.current.dateComponents([.day,.hour,.minute,.second], from: Date(), to: dataFinal)
    }
    private let grid = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        VStack {
            Text("Tempo restante \npara seu evento")
                .bold()
                .padding(.vertical, 30)
            LazyVGrid(columns: grid, spacing: 30) {
                
                ZStack {
                    VStack {
                        Text("\(resultado.day!)")
                        Text("Dias corridos")
                    }
                }
                ZStack {
                    VStack {
                        Text("\(CalcularDatas.calcularSemanas(dataInicio: Date(), totalDias: resultado.day ?? 0))")
                        Text("Semanas")
                    }
                }
                
                ZStack {
                    VStack {
                        Text("\(CalcularDatas.calcularDiasUteis(totalDias: resultado.day ?? 0, dataInicio: Date()))")
                        Text("Dias da semana")
                    }
                }
                ZStack {
                    VStack {
                        Text("\(CalcularDatas.calcularFinaisSemana(totalDias: resultado.day ?? 0, diaInicio: Date()))")
                        Text("Finais de Semana")
                    }
                }
            }
            Spacer()
            VStack {
                VStack {
                    Text("Notas").padding()
                    if anotacao != "" {
                        Text(anotacao)
                    }else{
                        Text("Nenhuma nota")
                    }
                }.padding(.vertical, 30)
                VStack {
                    Text("Notificação").padding()
                    
                    if lembrete != nil{
                        Text("Me lembrar \(converterData(date: lembrete))")
                    }else{
                        Text("Nenhuma")
                    }
                    
                }
                
            }
            Spacer()
        }
        .navigationTitle(titulo)
        Spacer()
    }
    
    
    func converterData (date: Date?) -> String {
        if date != nil{
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "pt_BR")
            dateFormatter.dateFormat = "EEEE\nd MMMM yyyy - HH:mm"
            return dateFormatter.string(from: date!)
        }
        return "Sem data marcada"
    }
    
    
    
    
}
