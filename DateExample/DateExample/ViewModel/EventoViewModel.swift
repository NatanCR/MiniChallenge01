//
//  Evento.swift
//  DateExample
//
//  Created by Bruno Lafayette on 22/09/22.
//

import SwiftUI

class EventoViewModel: ObservableObject{
    
    @Published var eventos: [Dados] = []
        
    init(){
        fetch()
    }
    
    func adicionarNovo(tituloSalvo: String, anotacoesSalvo: String, dataFinalSalvo: Date, dataLembrete: Date?, ativaLembrete: Bool, idLembrete: UUID) {
        if ativaLembrete == true {
            self.eventos.append(Dados(titulo: tituloSalvo, anotacoes: anotacoesSalvo, datafinal: dataFinalSalvo, dataLembrete: dataLembrete, ativaLembrete: ativaLembrete, idLembrete: idLembrete))
            for i in 0..<eventos.count{
                if idLembrete == eventos[i].idLembrete{
                    Notificacoes.criarLembrete(date: dataLembrete!, titulo: tituloSalvo, dataEvento: CalcularDatas.dateToString(indice: 0, date: dataFinalSalvo), id: idLembrete)
                    if let valoresCodificados = try? JSONEncoder().encode(eventos) {
                        UserDefaults.standard.set(valoresCodificados, forKey: "listaEventos")
                        fetch()
                    }
                }
            }
            
        } else {
            self.eventos.append(Dados(titulo: tituloSalvo, anotacoes: anotacoesSalvo, datafinal: dataFinalSalvo, dataLembrete: nil, ativaLembrete: ativaLembrete, idLembrete: idLembrete))
            if let valoresCodificados = try? JSONEncoder().encode(eventos) {
                UserDefaults.standard.set(valoresCodificados, forKey: "listaEventos")
                fetch()
            }
        }
    }
    
    func editarDados(titulo: String, anotacao: String, id: UUID, dataFinalSalvar: Date, idLembrete: UUID, dataLembrete: Date?, ativaLembrete: Bool){
        for i in 0..<self.eventos.count{
            if ativaLembrete == true {
                if idLembrete == eventos[i].idLembrete {
                    eventos[i].titulo = titulo
                    eventos[i].anotacoes = anotacao
                    eventos[i].dataFinal = dataFinalSalvar
                    eventos[i].dataLembrete = dataLembrete
                    eventos[i].ativaLembrete = true
                    Notificacoes.editarLembrete(id: id, date: dataLembrete!, titulo: titulo, dataEvento: CalcularDatas.dateToString(indice: 0, date: dataFinalSalvar))
                    if let valoresCodificados = try? JSONEncoder().encode(eventos) {
                        UserDefaults.standard.set(valoresCodificados, forKey: "listaEventos")
                        fetch()
                    }
                }
            } else {
                if id == eventos[i].id{
                    eventos[i].titulo = titulo
                    eventos[i].anotacoes = anotacao
                    eventos[i].dataFinal = dataFinalSalvar
                    eventos[i].ativaLembrete = false
                    eventos[i].dataLembrete = nil
                    if let valoresCodificados = try? JSONEncoder().encode(eventos) {
                        UserDefaults.standard.set(valoresCodificados, forKey: "listaEventos")
                        fetch()

                    }
                }
            }
        }
    }
    
    func remover(at offsets: IndexSet) {
        eventos.remove(atOffsets: offsets)
        if let valoresCodificados = try? JSONEncoder().encode(eventos) {
            UserDefaults.standard.set(valoresCodificados, forKey: "listaEventos")
            fetch()
            return
        }
    }
    
    func fetch() {
        if let anotacoesCodificadas = UserDefaults.standard.data(forKey: "listaEventos") {
            let decoder = JSONDecoder()
            if let anotacoesDecodificadas = try? decoder.decode([Dados].self, from: anotacoesCodificadas){
                self.eventos = anotacoesDecodificadas
            }
        }
    }
}
