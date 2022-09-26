import SwiftUI

struct CelulaLista: View {
    @State var dados: Dados
    
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text(dados.titulo)
                    .font(.system(size: 19, weight: .bold, design: .rounded))
                    .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                Text(converterData(date: dados.dataFinal))
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
            }
        }
    }
    
    func converterData (date: Date?) -> String {
        if date != nil{
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "pt_BR")
            dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
            return dateFormatter.string(from: date!)
        }
        return "Sem data marcada"
    }
    
}
