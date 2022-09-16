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
    
    func deletar(id: UUID){
            for i in 0 ..< self.anotacoes.count{
                if id == anotacoes[i].id{
                    self.anotacoes.remove(at: i)
                    if let valoresCodificados = try? JSONEncoder().encode(anotacoes) {
                        UserDefaults.standard.set(valoresCodificados, forKey: "listaDados")
                        return
                    }
                }
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
}
