import SwiftUI

struct CustomRow: View {
    
    var titulo: String
    var dataFinal: String
    
    var body: some View {
            HStack {
                VStack(alignment: .leading){
                    Text(titulo)
                    Text(dataFinal)
                }
            }
        }
    
    

    
    
}
