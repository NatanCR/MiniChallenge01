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
    var resultado: DateComponents {
        return Calendar.current.dateComponents([.day,.hour,.minute,.second], from: dataInicio, to: dataFinal)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .center) {
                    Spacer()
                    VStack {
                        Text("Data Inicial")
                            .font(.title)
                        DatePicker("", selection: $dataInicio, displayedComponents: [.date])
                            .labelsHidden()
                        
                    }.padding(.vertical)
                    VStack {
                        Text("Data Final")
                            .font(.title)
                        DatePicker("", selection: $dataFinal, displayedComponents: [.date])
                            .labelsHidden()
                    }.padding(.vertical)
                    Spacer()
                    VStack {
                        Text("Resultado:")
                            .labelsHidden()
                            .font(.title3)
                        Text("Faltam \(resultado.day!) dias corridos")
                            .labelsHidden()
                            .font(.title3)
                    }.padding(.vertical)
                    VStack {
                        Text("\(resultado.hour!) horas \(resultado.minute!) minutos \(resultado.second!) segundos para a data \(dataFinal, style: .date) ")
                            .labelsHidden()
                            .font(.title3)
                            .padding(.horizontal)
                    }
                    Spacer()
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
