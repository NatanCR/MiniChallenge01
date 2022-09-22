import SwiftUI

struct CustomRow: View {
    
    var titulo: String
    var dataFinal: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(titulo)
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                Text(dataFinal)
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
            }
        }
    }
    
    
    
    
    
}
