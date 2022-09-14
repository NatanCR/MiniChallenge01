//
//  DetalhesView.swift
//  DateExample
//
//  Created by Natan Rodrigues on 13/09/22.
//

import SwiftUI

struct DetalhesView: View {
    var titulo: String
    var anotacao: String
    var dataFinal: Date
    //var alerta: String
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
                            Text("80")
                            Text("Semanas")
                        }
                    }
                    
                    ZStack {
                        VStack {
                            Text("39")
                            Text("Dias da semana")
                        }
                    }
                    ZStack {
                        VStack {
                            Text("10")
                            Text("Finais de Semana")
                        }
                    }
                }
                Spacer()
                VStack {
                    VStack {
                        Text("Notas").padding()
                        Text(anotacao)
                    }.padding(.vertical, 30)
                    VStack {
                        Text("Alerta").padding()
                        Text("Me avisar 1 semana antes")
                    }
                }
                Spacer()
            }
        .navigationTitle(titulo)
        Spacer()
        
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
//                    NavigationLink(destination: Resultado(dataFinalSalvar: dataFinal, resultadoDate: resultado), label: {
              //          Text("Editar")
//                    })
                    Button("Editar") {
                        opcoes = true
                    }.confirmationDialog("Selecione a opção", isPresented: $opcoes, titleVisibility: .visible) {
                        Button("Editar") {
                           
                        }
                        Button("Deletar", role: .destructive) {
                        
                        }
                    }
                }
            }
    }
}


//struct DetalhesView_Previews: PreviewProvider {
//    static var previews: some View {
//        DetalhesView()
//    }
//}
