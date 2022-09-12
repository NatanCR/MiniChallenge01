import SwiftUI

struct Listas: View {
    
    @EnvironmentObject var lista: Model
    
    var body: some View {
        
        if lista.anotacoes.count == 0{
            Text ("Você não possui nenhum registro")
        
        }else{
            
            List(lista.anotacoes) { anotacao in
                HStack {
                    Text("")
                        .font(.system(size: 30))
                        .foregroundColor(.black)
                        .padding(.all)
                    VStack(alignment: .leading){
                        Text(anotacao.titulo)
                            .font(.system(size: 27))
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                        Text(anotacao.anotacoes)
                            .fontWeight(.light)
                    }
                }
            }
        }
    }
}
