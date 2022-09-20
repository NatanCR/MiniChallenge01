import SwiftUI

struct ContentView: View{
    
    @State var dataInicio = Date()
    @State var dataFinal = Date()
    private var resultado: DateComponents {
        Calendar.current.dateComponents([.day,.hour,.minute,.second],
                                        from: dataInicio,
                                        to: dataFinal)
    }
    
    private let grid = [
        GridItem(.adaptive(minimum: 150))
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .center) {
                    Text("Quanto tempo\nfalta para o seu evento?")
                        .font(.system(size: 20,
                                      weight: .bold,
                                      design: .rounded))
                        .multilineTextAlignment(.center)
                        .padding(.top, 40)
                        .padding(.bottom, 50)

                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 50)
                            .frame(width: 250, height: 200)
                            .foregroundColor(Color(hue: 1.0, saturation: 0.005, brightness: 0.969))
                        
                        RoundedRectangle(cornerRadius: 50)
                            .strokeBorder(.blue)
                            .frame(width: 250, height: 200)
                            
                        VStack{
                            
                            VStack {
                                Text("Data Inicial")
                                    .font(.system(size: 20,
                                                  weight: .medium,
                                                  design: .default))
                                    .foregroundColor(.gray)
                                
                                DatePicker("", selection: $dataInicio,
                                           in: Date.distantPast...dataFinal,
                                           displayedComponents: [.date])
                                .labelsHidden()
                                
                            }
                            VStack {
                                Text("Data Final")
                                    .font(.system(size: 20,
                                                  weight: .medium,
                                                  design: .default))
                                    .foregroundColor(.gray)
                                DatePicker("", selection: $dataFinal,
                                           in: dataInicio...Date.distantFuture,
                                           displayedComponents: [.date])
                                .labelsHidden()
                            }
                            .onAppear {
                                dataInicio = Date()
                                dataFinal = Date()
                            }
                        }
                    }
                    .padding(.bottom, 40)
                    
                    LazyVGrid(columns: grid, spacing: 30) {
                        ZStack {
                            VStack{
                                Text("\(CalcularDatas.calcularDiasCorridos(totalDias: resultado.day ?? 0))")
                                    .font(.system(size: 30, weight: .regular, design: .default))
                                Text("Dias Corridos")
                                    .font(.system(size: 15))

                                    .foregroundColor(.gray)
                            }
                        }
                        
                        ZStack{
                            VStack{
                                Text("\(CalcularDatas.calcularSemanas(dataInicio: dataInicio,totalDias: resultado.day ?? 0))")
                                    .font(.system(size: 30, weight: .regular, design: .default))
                                
                                Text("Semanas")
                                    .font(.system(size: 15))

                                    .foregroundColor(.gray)
                            }
                        }
                        ZStack{
                            VStack{
                                Text("\(CalcularDatas.calcularDiasUteis(totalDias: resultado.day ?? 0, dataInicio: dataInicio))")
                                    .font(.system(size: 30, weight: .regular, design: .default))

                                Text("Dias de Semana")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }
                        ZStack{
                            VStack{
                                Text("\(CalcularDatas.calcularFinaisSemana(totalDias: resultado.day ?? 0, diaInicio: dataInicio))")
                                    .font(.system(size: 30, weight: .regular, design: .default))
                                
                                Text("Finais de Semana")
                                    .font(.system(size: 15))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding([.top, .leading, .trailing],30)
                    Spacer()
                    
                }
                .navigationBarTitle("Contador")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: ResultadoView(dataFinalSalvar: dataFinal, dataLembrete: Date()), label: {
                            Text("Adicionar")
                        })
                    }
                }
            }
        }
    }
}
