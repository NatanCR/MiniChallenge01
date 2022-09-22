//
//  DetalhesView.swift
//  DateExample
//
//  Created by Natan Rodrigues on 13/09/22.
//

import SwiftUI

struct DetalhesView: View {
    
    
    @State var id: UUID
    @State var titulo: String
    @State var anotacao: String
    @State var dataFinal: Date
    @State var dataLembrete: Date?
    @State var ativaLembrete: Bool
    @State var modoEditar = false
    var resultado: DateComponents {
        return Calendar.current.dateComponents([.day,.hour,.minute,.second], from: Date(), to: dataFinal)
    }
    private let grid = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        VStack {
            Spacer()
            Text("Tempo restante \npara seu evento")
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
                    if anotacao != "" {
                        Text(anotacao)
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
                    if dataLembrete != nil{
                        Text("Me lembrar \(converterData(date: dataLembrete))")
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
