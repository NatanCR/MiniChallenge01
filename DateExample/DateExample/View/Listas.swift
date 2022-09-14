import SwiftUI

struct Listas: View {
    
    @EnvironmentObject var lista: Model
    
    var body: some View {
        NavigationView {
            if lista.anotacoes.count == 0{
                Text ("Você não possui nenhum registro")
            }else{
                List(lista.anotacoes) { anotacao in
                    NavigationLink(destination: DetalhesView(titulo: anotacao.titulo, anotacao: anotacao.anotacoes, dataFinal: anotacao.dataFinal)) {
                        CustomRow(titulo: anotacao.titulo, dataFinal: conversorDataString(dataSalva: anotacao.dataFinal))
                    }
                }
            }
        }
    }
    
    
    func conversorDataString(dataSalva: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt-br")
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let data = dateFormatter.string(from: dataSalva)
        return data
    }
    
    
    var dataInicio: Date = Date()
    var dataFinal: Date = Date().advanced(by: 60)
    
    var dia: Double {
        return 86400.0
    }
    
    var resultado: DateComponents {
        Calendar.current.dateComponents([.day,.hour,.minute], from: dataInicio, to: dataFinal)
    }
   
    }
    
