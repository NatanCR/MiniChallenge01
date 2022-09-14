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
                        CustomRow(anotacoes: anotacao)
                    }
                }
            }
        }
    }
}
