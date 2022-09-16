import SwiftUI

struct CustomRow: View {
    
    var titulo: String
    var dataFinal: String
    
    var body: some View {
            HStack {
                VStack(alignment: .leading){
                    Text(titulo)
                        .font(.system(size: 27))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text(dataFinal)
                        .fontWeight(.light)
                }
            }
        }
    
    

    
    
}
