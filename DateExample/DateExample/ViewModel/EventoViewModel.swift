//
//  Evento.swift
//  DateExample
//
//  Created by Bruno Lafayette on 22/09/22.
//

import SwiftUI

class EventoViewModel: ObservableObject{
    
    @Published var eventos = [Evento]()
    @Published var eventosAtualizados = [EventoAtualizado]()
    private var chave = "listaEventosNovos"
        
    init(){
        fetch()
        fetchAtualizado()
    }
    
    func atualizarEstrutura(eventos: [Evento]) {
        if eventosAtualizados.count == 0 {
            for i in 0..<eventos.count {
                eventosAtualizados.append(EventoAtualizado(titulo: eventos[i].titulo, anotacoes: eventos[i].anotacoes, datafinal: eventos[i].dataFinal, dataLembrete: eventos[i].dataLembrete, ativaLembrete: eventos[i].ativaLembrete, idLembrete: eventos[i].idLembrete, idCalendario: nil, adicionarCalendario: false))
            }
            
        } else {
            return
        }
        
//        self.eventos.removeAll()
//        if let valoresCodificados = try? JSONEncoder().encode(eventos) {
//            UserDefaults.standard.set(valoresCodificados, forKey: "listaEventos")
//        }
        
        print("ESTOU AQUIIIII \(eventosAtualizados)")
        
        if let valoresCodificados = try? JSONEncoder().encode(eventosAtualizados) {
            UserDefaults.standard.set(valoresCodificados, forKey: chave)
        }
    }
    
    func adicionarNovo(tituloSalvo: String, anotacoesSalvo: String, dataFinalSalvo: Date, dataLembrete: Date?, ativaLembrete: Bool, idLembrete: UUID, idCalendario: String?, adicionarCalendario: Bool) {
        if ativaLembrete == true {
            self.eventosAtualizados.append(EventoAtualizado(titulo: tituloSalvo, anotacoes: anotacoesSalvo, datafinal: dataFinalSalvo, dataLembrete: dataLembrete, ativaLembrete: ativaLembrete, idLembrete: idLembrete, idCalendario: idCalendario, adicionarCalendario: adicionarCalendario))
            Notificacoes.criarLembrete(date: dataLembrete!, titulo: tituloSalvo, dataEvento: ConversorData.dataNotificacao(indice: 0, date: dataFinalSalvo), id: idLembrete)
        } else {
            self.eventosAtualizados.append(EventoAtualizado(titulo: tituloSalvo, anotacoes: anotacoesSalvo, datafinal: dataFinalSalvo, dataLembrete: nil, ativaLembrete: ativaLembrete, idLembrete: idLembrete, idCalendario: idCalendario, adicionarCalendario: adicionarCalendario))
        }
        if let valoresCodificados = try? JSONEncoder().encode(eventosAtualizados) {
            UserDefaults.standard.set(valoresCodificados, forKey: chave)
        }
    }
    
    func editarDados(titulo: String, anotacao: String, id: UUID, dataFinalSalvar: Date, idLembrete: UUID, dataLembrete: Date?, ativaLembrete: Bool){
        
        for i in 0..<eventosAtualizados.count {
            if id == eventosAtualizados[i].id {
                eventosAtualizados[i].titulo = titulo
                eventosAtualizados[i].anotacoes = anotacao
                eventosAtualizados[i].dataFinal = dataFinalSalvar
                if ativaLembrete == true {
                    eventosAtualizados[i].dataLembrete = dataLembrete
                    eventosAtualizados[i].ativaLembrete = true
                    Notificacoes.editarLembrete(id: idLembrete, date: dataLembrete!, titulo: titulo, dataEvento: ConversorData.dataNotificacao(indice: 0, date: dataFinalSalvar))
                } else {
                    eventosAtualizados[i].ativaLembrete = false
                    eventosAtualizados[i].dataLembrete = nil
                }
                
                DispatchQueue.main.async {
                    if let valoresCodificados = try? JSONEncoder().encode(self.eventosAtualizados) {
                        UserDefaults.standard.set(valoresCodificados, forKey: self.chave)
                        self.fetchAtualizado()
                    }
                }
            }
        }
    }
    
    public func criaListaPassada() -> [EventoAtualizado]{
        var eventosPassados: [EventoAtualizado] = []
        var indexCancelar: [Int] = []
        let listaTemp: [EventoAtualizado] = eventosAtualizados
        
        for i in 0..<listaTemp.count{
            if Calendar.current.dateComponents([.day],
                                                           from: Date(),
                                               to: eventosAtualizados[i].dataFinal).day! < 0{
                eventosPassados.append(eventosAtualizados[i])
                indexCancelar.append(i)
            }
            
        }
        return eventosPassados
    }
    
    
    public func criaListaAtual() -> [EventoAtualizado]{
        var eventosPassados: [EventoAtualizado] = []
        var indexCancelar: [Int] = []
        let listaTemp: [EventoAtualizado] = eventosAtualizados
        
        for i in 0..<listaTemp.count{
            if Calendar.current.dateComponents([.day],
                                                           from: Date(),
                                               to: eventosAtualizados[i].dataFinal).day! >= 0{
                eventosPassados.append(eventosAtualizados[i])
                indexCancelar.append(i)
            }
            
        }
        return eventosPassados
    }
    
    func remover(at offsets: IndexSet) {
        var listaOrdenada = eventosAtualizados.sorted(by: {$0.dataFinal < $1.dataFinal})
        listaOrdenada.remove(atOffsets: offsets)
        eventosAtualizados = listaOrdenada
        if let valoresCodificados = try? JSONEncoder().encode(eventosAtualizados) {
            UserDefaults.standard.set(valoresCodificados, forKey: chave)
            return
        }
    }
    
    func esconderTeclado() {
        let resposta = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resposta, to: nil, from: nil, for: nil)
    }
    
    func fetch() {
        if let anotacoesCodificadas = UserDefaults.standard.object(forKey: "listaEventos") as? Data {
            if let anotacoesDecodificadas = try? JSONDecoder().decode([Evento].self, from: anotacoesCodificadas){
                DispatchQueue.main.async {
                    self.eventos = anotacoesDecodificadas
                }
            }
        }
    }
    
    func fetchAtualizado() {
        if let anotacoesCodificadas = UserDefaults.standard.object(forKey: chave) as? Data {
            if let anotacoesDecodificadas = try? JSONDecoder().decode([EventoAtualizado].self, from: anotacoesCodificadas){
                DispatchQueue.main.async {
                    self.eventosAtualizados = anotacoesDecodificadas
                }
            }
        }
    }
}
