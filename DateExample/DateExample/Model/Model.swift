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
    
    func salvar(tituloSalvo: String, anotacoesSalvo: String, dataFinalSalvo: Date, dataLembrete: Date?, ativaLembrete: Bool, idLembrete: UUID?) {
        if ativaLembrete == true {
            self.anotacoes.append(Dados(titulo: tituloSalvo, anotacoes: anotacoesSalvo, datafinal: dataFinalSalvo, dataLembrete: dataLembrete, ativaLembrete: ativaLembrete, idLembrete: idLembrete!))
            Notificacoes.criarLembrete(date: dataLembrete!, titulo: tituloSalvo, dataEvento: CalcularDatas.dateToString(indice: 0, date: dataFinalSalvo), id: idLembrete!)
            if let valoresCodificados = try? JSONEncoder().encode(anotacoes) {
                UserDefaults.standard.set(valoresCodificados, forKey: "listaDados")
            }
        } else {
            self.anotacoes.append(Dados(titulo: tituloSalvo, anotacoes: anotacoesSalvo, datafinal: dataFinalSalvo, dataLembrete: nil, ativaLembrete: ativaLembrete, idLembrete: nil))
            if let valoresCodificados = try? JSONEncoder().encode(anotacoes) {
                UserDefaults.standard.set(valoresCodificados, forKey: "listaDados")
            }
        }
    }
    
    func editarEvento(titulo: String, anotacao: String, id: UUID, dataFinalSalvar: Date, idLembrete: UUID, dataLembrete: Date?, ativaLembrete: Bool){
        
        for i in 0..<anotacoes.count{
            if idLembrete == anotacoes[i].idLembrete {
                if ativaLembrete == true {
                    print("entrei no ativa true")
                    anotacoes[i].titulo = titulo
                    anotacoes[i].anotacoes = anotacao
                    anotacoes[i].dataFinal = dataFinalSalvar
                    anotacoes[i].dataLembrete = dataLembrete
                    anotacoes[i].ativaLembrete = true
                    Notificacoes.editarLembrete(id: id, date: dataLembrete!, titulo: titulo, dataEvento: CalcularDatas.dateToString(indice: 0, date: dataFinalSalvar))
                    if let valoresCodificados = try? JSONEncoder().encode(anotacoes) {
                        UserDefaults.standard.set(valoresCodificados, forKey: "listaDados")
                    }
                }
            } else {
                if id == anotacoes[i].id{
                    anotacoes[i].titulo = titulo
                    anotacoes[i].anotacoes = anotacao
                    anotacoes[i].dataFinal = dataFinalSalvar
                    anotacoes[i].ativaLembrete = false
                    anotacoes[i].dataLembrete = nil
                    anotacoes[i].idLembrete = nil
                    if let valoresCodificados = try? JSONEncoder().encode(anotacoes) {
                        UserDefaults.standard.set(valoresCodificados, forKey: "listaDados")
                    }
                }
            }
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
    var dataLembrete: Date?
    var ativaLembrete: Bool
    var idLembrete: UUID?
    
    init(titulo: String, anotacoes: String, datafinal: Date, dataLembrete: Date?, ativaLembrete: Bool, idLembrete: UUID?) {
        self.titulo = titulo
        self.anotacoes = anotacoes
        self.dataFinal = datafinal
        self.dataLembrete = dataLembrete
        self.ativaLembrete = ativaLembrete
        self.idLembrete = idLembrete
    }
}
