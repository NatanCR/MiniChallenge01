import SwiftUI

struct CustomRow: View {
    
    var anotacoes: Dados
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(anotacoes.titulo)
                    .font(.system(size: 27))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text(anotacoes.anotacoes)
                    .fontWeight(.light)
            }
        }
    }
    
}
