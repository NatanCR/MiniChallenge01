//
//  HomeView.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var eventos: EventoViewModel
    
    @State private var dataInicio = Date()
    @State private var dataFinal = Date()
    @State private var mostrarAlerta = false
    
    private var resultado: DateComponents {
        Calendar.current.dateComponents([.day,.hour,.minute,.second],
                                        from: dataInicio,
                                        to: dataFinal)
    }
    
    private let grid = [
        GridItem(.adaptive(minimum: 150))
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
                                    Text("Data Inicial")
                                        .font(.system(size: 20,
                                                      weight: .semibold,
                                                      design: .default))
                                        .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                                    
                                    Text(CalcularDatas.conversorDataString(dataParaConversao: Date(), recebeData: "dataHome"))
                                }
                                .padding()
                                VStack {
                                    Text("Data Final")
                                        .font(.system(size: 20,
                                                      weight: .semibold,
                                                      design: .default))
                                        .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                                    DatePicker("", selection: $dataFinal,
                                               in: periodo,
                                               displayedComponents: [.date])
                                        .labelsHidden()
                                        .id(dataFinal)
                                }
                                .onAppear {
                                    dataInicio = Date()
                                    dataFinal = Date()
                                }
                            }
                        }
                        
                        
                        LazyVGrid(columns: grid, spacing: 30) {
                            ZStack {
                                VStack{
                                    Text("\(CalcularDatas.calcularDiasCorridos(totalDias: resultado.day ?? 0))")
                                        .font(.system(size: 30, weight: .regular, design: .rounded))
                                    if ("\(CalcularDatas.calcularDiasCorridos(totalDias: resultado.day ?? 0))") == "1" {
                                        Text("Dia Corrido")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                    }else {
                                        Text("Dias Corridos")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                    }
                                }
                            }
                            
                            ZStack{
                                VStack{
                                    Text("\(CalcularDatas.calcularSemanas(dataInicio: dataInicio,totalDias: resultado.day ?? 0))")
                                        .font(.system(size: 30, weight: .regular, design: .rounded))
                                    if ("\(CalcularDatas.calcularSemanas(dataInicio: dataInicio,totalDias: resultado.day ?? 0))") == "1" {
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
                                    Text("\(CalcularDatas.calcularDiasUteis(totalDias: resultado.day ?? 0, dataInicio: dataInicio))")
                                        .font(.system(size: 30, weight: .regular, design: .rounded))
                                    if ("\(CalcularDatas.calcularDiasUteis(totalDias: resultado.day ?? 0, dataInicio: dataInicio))") == "1" {
                                        Text("Dia de Semana")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                    } else {
                                        Text("Dias de Semana")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                    }
                                }
                            }
                            ZStack{
                                VStack{
                                    Text("\(CalcularDatas.calcularFinaisSemana(totalDias: resultado.day ?? 0, diaInicio: dataInicio))")
                                        .font(.system(size: 30, weight: .regular, design: .rounded))
                                    if ("\(CalcularDatas.calcularFinaisSemana(totalDias: resultado.day ?? 0, diaInicio: dataInicio))") == "1" {
                                        Text("Final de Semana")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                    }else{
                                        Text("Finais de Semana")
                                            .font(.system(size: 17, weight: .regular, design: .rounded))
                                    }
                                }
                            }
                        }
                        .padding([.top, .leading, .trailing],30)
                        Spacer()
                    }
                    .navigationBarTitle("Contador")
                    .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                    .alert(isPresented: $mostrarAlerta) {
                        return Alert(title: Text("Atenção"), message: Text("Você tem menos de um dia para seu evento."), dismissButton: .default(Text("Ok")))
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink(destination: AdicionarEventoView(dataFinalSalvar: dataFinal, dataLembrete: Date()), label: {
                                Text("Adicionar")
                                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                            })
                        }
                    }
                }
            }
            .background(Color.init(red: 0.77, green: 0.84, blue: 0.90, opacity: 1.00))

        }
        .navigationAppearance(backgroundColor: UIColor.init(red: 0.89, green: 0.92, blue: 0.94, alpha: 1.00), foregroundColor: UIColor.init(red: 0.00, green: 0.16, blue: 0.35, alpha: 1.00), tintColor: UIColor.init(red: 0.00, green: 0.16, blue: 0.35, alpha: 1.00), hideSeparator: true)
    }
}
