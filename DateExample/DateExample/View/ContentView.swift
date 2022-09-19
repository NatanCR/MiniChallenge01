import SwiftUI

struct ContentView: View{
    
    @State var dataInicio = Date()
    @State var dataFinal = Date()
    private var resultado: DateComponents {
        Calendar.current.dateComponents([.day,.hour,.minute,.second], from: dataInicio, to: dataFinal)
    }
    
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
                    }
                    .padding(.vertical)
                    VStack {
                        Text("Data Final")
                            .font(.title)
                        DatePicker("", selection: $dataFinal,
                                   in: dataInicio...Date.distantFuture,
                                   displayedComponents: [.date])
                        .labelsHidden()
                    }
                    .padding(.vertical)
                        .onAppear {
                            dataInicio = Date()
                            dataFinal = Date()
                        }
                    
                    LazyVGrid(columns: grid, spacing: 30) {
                        ZStack {
                            VStack{
                                Text("\(CalcularDatas.calcularDiasCorridos(totalDias: resultado.day ?? 0))")
                                    .labelsHidden()
                                
                                Text("Dias Corridos")
                                    .labelsHidden()
                                    .font(.title3)
                            }
                        }
                        
                        ZStack{
                            VStack{
                                Text("\(CalcularDatas.calcularSemanas(dataInicio: dataInicio, totalDias: resultado.day ?? 0))")
                                    .labelsHidden()
                                    .font(.body)
                                
                                Text("Semanas")
                                    .labelsHidden()
                                    .font(.title3)
                            }
                        }
                        ZStack{
                            VStack{
                                Text("\(CalcularDatas.calcularDiasUteis(totalDias: resultado.day ?? 0, dataInicio: dataInicio))")
                                    .labelsHidden()
                                
                                Text("Dias de Semana")
                                    .labelsHidden()
                                    .font(.title3)
                            }
                        }
                        ZStack{
                            VStack{
                                Text("\(CalcularDatas.calcularFinaisSemana(totalDias: resultado.day ?? 0, diaInicio: dataInicio))")
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
                        NavigationLink(destination: ResultadoView(dataFinalSalvar: dataFinal), label: {
                            Text("Adicionar Evento")
                        })
                    }
                }
            }
        }
        
    }
}
