//
//  Model.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import Foundation

class Model: ObservableObject {

    @Published var anotacoes: [Dados] = []
        
    init(){
        if let anotacoesCodificadas = UserDefaults.standard.data(forKey: "listaDados") {
            let decoder = JSONDecoder()
            if let anotacoesDecodificadas = try? decoder.decode([Dados].self, from: anotacoesCodificadas){
                self.anotacoes = anotacoesDecodificadas
            }
        }
    }
    
    func salvar(tituloSalvo: String, anotacoesSalvo: String, dataFinalSalvo: Date) {
        self.anotacoes.append(Dados(titulo: tituloSalvo, anotacoes: anotacoesSalvo, datafinal: dataFinalSalvo))
        if let valoresCodificados = try? JSONEncoder().encode(anotacoes) {
            UserDefaults.standard.set(valoresCodificados, forKey: "listaDados")
        }
    }
}


class Dados: Codable, Identifiable{
    var id = UUID()
    var titulo: String
    var anotacoes: String
    var dataFinal: Date
    
    init(titulo: String, anotacoes: String, datafinal: Date) {
        self.titulo = titulo
        self.anotacoes = anotacoes
        self.dataFinal = datafinal
    }

//    enum CodingKeys: CodingKey {
//        case titulo
//        case anotacoes
//        case dataFinal
//    }
//
//
//    func encode(to encoder: Encoder) throws {
//
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(self.titulo, forKey: .titulo)
//        try container.encode(self.anotacoes, forKey: .anotacoes)
//        try container.encode(dataFinal, forKey: .dataFinal)
//
//    }
//
//    required init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        self.titulo = try values.decode(String.self, forKey: .titulo)
//        self.anotacoes = try values.decode(String.self, forKey: .anotacoes)
//        self.dataFinal = try values.decode(Date.self, forKey: .dataFinal)
//    }
    
}
