//
//  ResultadoView.swift
//  DateExample
//
//  Created by Natan Rodrigues on 01/09/22.
//

import SwiftUI

class DatasSalvas: ObservableObject {
    @Published var titulo: String {
        didSet {
            UserDefaults.standard.set(titulo, forKey: "titulo")
        }
    }
    
    init() {
        self.titulo = UserDefaults.standard.object(forKey: "titulo") as? String ?? ""
    }
}

struct ResultadoView: View {
    var resultadoDate = DateComponents()
    @ObservedObject var datasSalvas = DatasSalvas()
   // @State var titulo: String
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Título do evento")) {
                 //   TextField("D", text: $titulo)
                }
                ZStack {
                    Text("Resultado: \n\(resultadoDate.day!) dias \n\(resultadoDate.hour!) horas e \(resultadoDate.minute!) minutos ")
                }
            }
            
            .navigationTitle("Salvar Data")
        }
            
    }
}

struct ResultadoView_Previews: PreviewProvider {
    static var previews: some View {
        ResultadoView()
    }
}
