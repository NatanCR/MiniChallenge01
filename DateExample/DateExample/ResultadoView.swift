//
//  ResultadoView.swift
//  DateExample
//
//  Created by Natan Rodrigues on 01/09/22.
//

import SwiftUI

//class DatasSalvas: ObservableObject {
//    @Published var titulo: String {
//        didSet {
//            UserDefaults.standard.set(titulo, forKey: "titulo")
//        }
//    }
//
//    init() {
//        self.titulo = UserDefaults.standard.object(forKey: "titulo") as? String ?? ""
//    }
//}

class dadosInseridos: ObservableObject {
    @Published var titulo: String?
    
//    init(titulo: String) {
//        self.titulo = titulo
//    }
    
    init() {
       
    }
}


struct ResultadoView: View {
    var resultadoDate = DateComponents()
    //@ObservedObject var datasSalvas = DatasSalvas()
    @ObservedObject var dados = dadosInseridos()
    @State var titulo: String = ""
    let model = Model()
    
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Título do evento")) {
                    TextField("Título", text: $titulo)
                }
                ZStack {
                    Text("Resultado: \n\(resultadoDate.day!) dias \n\(resultadoDate.hour!) horas e \(resultadoDate.minute!) minutos ")
                }
                Button  {
                    model.salvar(titulo: titulo)
                } label: {
                    Text("SALVAR")
                }
                Button  {
                    model.listaDados = model.carregar()
                } label: {
                    Text("Carregar")
                }
                
                Text("\(model.listaDados)")

            }
            
            .navigationTitle("Salvar Data")
            .navigationBarTitleDisplayMode(.inline)
        }
            
    }
}

struct ResultadoView_Previews: PreviewProvider {
    static var previews: some View {
        ResultadoView()
    }
}
