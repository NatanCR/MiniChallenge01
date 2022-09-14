//
//  ContentView.swift
//  DateExample
//
//  Created by Natan Rodrigues on 29/08/22.
//

import SwiftUI

struct ContentView: View {
    @State var dataInicio = Date()
    @State var dataFinal = Date()
    
    private let grid = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .center) {
                    
                    Text("Quanto tempo falta para seu evento?")
                    
                    VStack {
                        Text("Data Inicial")
                            .font(.title)
                        DatePicker("", selection: $dataInicio,
                                   in: Date.distantPast...dataFinal,
                                   displayedComponents: [.date])
                        .labelsHidden()
                        
                    }.padding(.vertical)
                    VStack {
                        Text("Data Final")
                            .font(.title)
                        DatePicker("", selection: $dataFinal,
                                   in: dataInicio...Date.distantFuture,
                                   displayedComponents: [.date])
                        .labelsHidden()
                    }.padding(.vertical)
                    
                    LazyVGrid(columns: grid, spacing: 30) {
                        ZStack {
                            
                            VStack{
                                Text("\(calcularDiasCorridos(totalDias: resultado.day ?? 0))")
                                    .labelsHidden()
                                
                                Text("Dias Corridos")
                                    .labelsHidden()
                                    .font(.title3)
                            }
                        }
                        
                        ZStack{
                            VStack{
                                Text("\(calcularSemanas(totalDias: resultado.day ?? 0))")
                                    .labelsHidden()
                                    .font(.body)
                                
                                Text("Semanas")
                                    .labelsHidden()
                                    .font(.title3)
                            }
                        }
                        ZStack{
                            VStack{
                                Text("\(calcularDiasUteis(totalDias: resultado.day ?? 0))")
                                    .labelsHidden()
                                
                                Text("Dias de Semana")
                                    .labelsHidden()
                                    .font(.title3)
                            }
                        }
                        ZStack{
                            VStack{
                                Text("\(calcularFinaisSemana(totalDias: resultado.day ?? 0))")
                                    .labelsHidden()
                                    .font(.body)
                                
                                Text("Finais de Semana")
                                    .labelsHidden()
                                    .font(.title3)
                            }
                            
                        }
                    }
                    
                }
                .navigationBarTitle("Contador de dias")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: Resultado(dataFinalSalvar: dataFinal, resultadoDate: resultado), label: {
                            Text("Salvar")
                        })
                    }
                }
            }
        } 
        
    }
}

extension ContentView{
    private var resultado: DateComponents {
        Calendar.current.dateComponents([.day,.hour,.minute,.second], from: dataInicio, to: dataFinal)
    }
    
    private var dia: Double {
        return 86400.0
    }
    
    func conversorDate (indice: Int) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: dataInicio.advanced(by: dia * Double(indice)))
    }
    
    func calcularSemanas(totalDias: Int) -> Int{
        var contador = -1
        if totalDias == 0 {
            return 0
        }
        else{
            if totalDias >= 7 {
                for i in 0...totalDias {
                    let diaStr = conversorDate(indice: i)
                    if diaStr == "domingo"{
                        contador += 1
                    }
                }
            } else {
                return 0
            }
            return contador
        }
    }
    
    
    func calcularDiasCorridos(totalDias: Int) -> Int{
        if totalDias == 0 {
            return 0
        }
        else{
            return totalDias
        }
    }
    
    func calcularFinaisSemana(totalDias: Int) -> Int{
        var contador = 0
        if totalDias == 0 {
            return 0
        }
        else{
            for i in 0...totalDias {
                let diaStr = conversorDate(indice: i)
                if diaStr == "domingo"{
                    contador += 1
                }
            }
            return contador
        }
    }
    
    
    
    func calcularDiasUteis(totalDias: Int) -> Int{
        var contador = -1
        if totalDias == 0 {
            print("Contando todos os dias \(resultado)")
            return 0
        }
        else{
            for i in 0...totalDias {
                let diaStr = conversorDate(indice: i)
                if diaStr != "sábado" && diaStr != "domingo"{
                    contador += 1
                }
            }
            return contador
        }
    }
}
