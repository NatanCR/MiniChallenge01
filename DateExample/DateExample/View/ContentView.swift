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
                            .foregroundColor(Color.init(red: 0.89, green: 0.92, blue: 0.94, opacity: 1.00))
                        
//                        RoundedRectangle(cornerRadius: 50)
//                            .strokeBorder()
//                            .frame(width: 250, height: 200)
//                            
                        VStack{
                            
                            VStack {
                                Text("Data Inicial")
                                    .font(.system(size: 20,
                                                  weight: .semibold,
                                                  design: .default))
                                    .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                                
                                DatePicker("", selection: $dataInicio,
                                           in: Date.distantPast...dataFinal,
                                           displayedComponents: [.date])
                                .labelsHidden()
                                
                            }
                            VStack {
                                Text("Data Final")
                                    .font(.system(size: 20,
                                                  weight: .semibold,
                                                  design: .default))
                                    .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
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
                                    .font(.system(size: 30, weight: .regular, design: .rounded))
                                Text("Dias Corridos")
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                            }
                        }
                        
                        ZStack{
                            VStack{
                                Text("\(CalcularDatas.calcularSemanas(dataInicio: dataInicio,totalDias: resultado.day ?? 0))")
                                    .font(.system(size: 30, weight: .regular, design: .rounded))
                                
                                Text("Semanas")
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                            }
                        }
                        ZStack{
                            VStack{
                                Text("\(CalcularDatas.calcularDiasUteis(totalDias: resultado.day ?? 0, dataInicio: dataInicio))")
                                    .font(.system(size: 30, weight: .regular, design: .rounded))

                                Text("Dias de Semana")
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                            }
                        }
                        ZStack{
                            VStack{
                                Text("\(CalcularDatas.calcularFinaisSemana(totalDias: resultado.day ?? 0, diaInicio: dataInicio))")
                                    .font(.system(size: 30, weight: .regular, design: .rounded))
                                
                                Text("Finais de Semana")
                                    .font(.system(size: 17, weight: .regular, design: .rounded))
                            }
                        }
                    }
                    .padding([.top, .leading, .trailing],30)
                    Spacer()
                    
                }
                .background(Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00))
                .navigationBarTitle("Contador")
                .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(destination: ResultadoView(dataFinalSalvar: dataFinal, dataLembrete: Date()), label: {
                            Text("Adicionar")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                        })
                    }
                }
            }
        }
        .navigationAppearance(backgroundColor: UIColor.init(red: 0.89, green: 0.92, blue: 0.94, alpha: 1.00), foregroundColor: UIColor.init(red: 0.00, green: 0.16, blue: 0.35, alpha: 1.00), tintColor: UIColor.init(red: 0.00, green: 0.16, blue: 0.35, alpha: 1.00), hideSeparator: true)
    }
}
