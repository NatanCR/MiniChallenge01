//
//  HomeView.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var eventoModel: EventoViewModel
    
    @State private var dataInicio = Date()
    @State private var dataFinal = Date()
    let calendario = Calendar(identifier: .gregorian)
    @State private var mostrarTela = false
    
//    private var resultado: DateComponents {
//        Calendar.current.dateComponents([.day, .hour],
//                                        from: dataInicio,
//                                        to: dataFinal)
//    }
    
    private let grid = [
        GridItem(.adaptive(minimum: 120, maximum: 200))
    ]
    
    var periodo: ClosedRange<Date>{
        let max = Calendar.current.date(byAdding: .year, value: 15, to: Date())!
        return Date()...max
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    VStack(alignment: .center) {
                        Text("Quanto tempo")
                            .font(.system(size: 20,
                                          weight: .bold,
                                          design: .rounded))
                            .padding(.top, 40)
                        Text("falta para o seu evento?")
                            .font(.system(size: 20,
                                          weight: .bold,
                                          design: .rounded))
                        ZStack{
                            RoundedRectangle(cornerRadius: 50)
                                .frame(width: 250, height: 200)
                                .foregroundColor(Color.init(red: 0.89, green: 0.92, blue: 0.94, opacity: 1.00))
                            VStack{
                                VStack {
                                    Text("Data inicial")
                                        .font(.system(size: 20,
                                                      weight: .semibold,
                                                      design: .default))
                                        .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                                    
                                    Text(ConversorData.conversorDataString(dataParaConversao: Date(), recebeData: "dataHome"))
                                }
                                .padding()
                                VStack {
                                    Text("Data final")
                                        .font(.system(size: 20,
                                                      weight: .semibold,
                                                      design: .default))
                                        .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                                    DatePicker("", selection: $dataFinal,
                                               in: periodo,
                                               displayedComponents: [.date])
                                        .labelsHidden()
                                        .environment(\.locale, Locale.init(identifier: "pt_BR"))
                                    
                                }
                                .id(dataFinal)
                                .onAppear {
                                    dataInicio = Date()
                                    dataFinal = Date()
                                    Avaliacao.pedidoAvaliacao()
                                }
                            }
                        }
                        LazyVGrid(columns: grid, spacing: 30) {
                            ZStack {
                                VStack{
                                    Text("\(calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "corridos"))")
                                        .font(.system(size: 30, weight: .regular, design: .rounded))
                                    if ("\(calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "corridos"))") == "1" {
                                        Text("Dia corrido")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                    }else {
                                        Text("Dias corridos")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                    }
                                }
                            }
                            ZStack{
                                VStack{
                                    Text("\(calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "semanas"))")
                                        .font(.system(size: 30, weight: .regular, design: .rounded))
                                    if ("\(calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "semanas"))") == "1" {
                                        Text("Semana")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                    } else{
                                        Text("Semanas")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                    }
                                }
                            }
                            ZStack{
                                VStack{
                                    Text("\(calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "uteis"))")
                                        .font(.system(size: 30, weight: .regular, design: .rounded))
                                    if ("\(calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "uteis"))") == "1" {
                                        Text("Dia de semana")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                    } else {
                                        Text("Dias de semana")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                    }
                                }
                            }
                            ZStack{
                                VStack{
                                    Text("\(calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "finais"))")
                                        .font(.system(size: 30, weight: .regular, design: .rounded))
                                    if ("\(calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "finais"))") == "1" {
                                        Text("Final de semana")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                    }else{
                                        Text("Finais de semana")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                            .multilineTextAlignment(.center)
                                    }
                                }
                            }
                        }
                        .padding([.top, .leading, .trailing],30)
                        Spacer()
                    }
                    .navigationBarTitle("Contador")
                    .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: AdicionarEventoView(eventoModel: eventoModel, dataFinalSalvar: dataFinal, dataLembrete: Date(), mostrarTela: $mostrarTela), isActive: $mostrarTela) {
                                Text("Adicionar")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                            }.disabled(calendario.contadorDiasAte(dataFinal: dataFinal, calculo: "corridos") == 0)
                        }
                    }
                }
            }
            .background(Color.init(red: 0.77, green: 0.84, blue: 0.90, opacity: 1.00))
            .navigationAppearance(backgroundColor: UIColor.init(red: 0.89, green: 0.92, blue: 0.94, alpha: 1.00), foregroundColor: UIColor.init(red: 0.00, green: 0.16, blue: 0.35, alpha: 1.00), tintColor: UIColor.init(red: 0.00, green: 0.16, blue: 0.35, alpha: 1.00), hideSeparator: true)
        }
    }
}
