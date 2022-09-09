import SwiftUI

struct CustomRow: View {
    var body: some View {
        HStack {
           Text("80 Dias")
                .font(.system(size: 30))
                .foregroundColor(.black)
                .padding(.all)
            VStack(alignment: .leading){
                Text("Mini Challenge para o termino do mes")
                    .font(.system(size: 27))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Text("80 dias corridos")
                    .fontWeight(.light)
            }
        }
    }
}

struct CustomRow_Previews: PreviewProvider {
    static var previews: some View {
        CustomRow()
    }
}
