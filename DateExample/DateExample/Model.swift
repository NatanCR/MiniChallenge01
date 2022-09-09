//
//  Model.swift
//  DateExample
//
//  Created by Natan Rodrigues on 09/09/22.
//

import Foundation

struct Dados: Codable {
    var titulo: String
    var anotacoes: String
    var dataFinal: Date
    
    init(titulo: String, anotacoes: String, datafinal: Date) {
        self.titulo = titulo
        self.anotacoes = anotacoes
        self.dataFinal = datafinal
    }
}

class Model {
    var listaDados: [Dados] = []
    let defaults = UserDefaults.standard
    
    func salvar(titulo: String) {
        self.listaDados.append(Dados(titulo: titulo, anotacoes: "teste01", datafinal: Date()))
        if let valoresCodificados = try? JSONEncoder().encode(listaDados) {
            defaults.set(valoresCodificados, forKey: "listaDados")
        }
    }
    
    func carregar() -> [Dados]{
        if let listaAtualizada = defaults.data(forKey: "listaDados") {
            if let valoresDecodificados = try? JSONDecoder().decode([Dados].self, from: listaAtualizada) {
                listaDados = valoresDecodificados
                return listaDados
            }
        }
        
        return []
    }
}
