//
//  Evento.swift
//  DateExample
//
//  Created by Bruno Lafayette on 22/09/22.
//

import SwiftUI
import EventKit

class EventoViewModel: ObservableObject{
    
    @Published var listaCalendario: [EKEvent] = []
    @Published var eventos = [Evento]()
    @Published var eventosAtualizados = [EventoAtualizado]()
    var trocarEstrutura = true
    let calendario = Calendar(identifier: .gregorian)
    
    init(){
        fetch()
    }
    
    func mudarEstrutura(vmEventos: EventoViewModel){
        if trocarEstrutura{
            print("entrei aqui", eventos.count)
            for i in 0 ..< eventos.count{
                eventosAtualizados.append(EventoAtualizado(titulo: eventos[i].titulo, anotacoes: eventos[i].anotacoes, datafinal: eventos[i].dataFinal, dataLembrete: eventos[i].dataLembrete, ativaLembrete: eventos[i].ativaLembrete, idLembrete: eventos[i].idLembrete, idCalendario: nil, adicionarCalendario: false))
                print(eventos[i])
            }
            trocarEstrutura = false
        }
        print(eventosAtualizados)
    }
    
    
    func adicionarNovo(tituloSalvo: String, anotacoesSalvo: String, dataFinalSalvo: Date, dataLembrete: Date?, ativaLembrete: Bool, idLembrete: UUID, adicionarCalendario: Bool, selecionarCalendario: Int) {
        var idCalendario: String?
        if adicionarCalendario{
            idCalendario = Calendario().adicionarEvento(dataFinal: dataFinalSalvo, anotacao: anotacoesSalvo, titulo: tituloSalvo, calendario: <#T##String#>)
        }
        
        if ativaLembrete == true {
            self.eventos.append(Evento(titulo: tituloSalvo, anotacoes: anotacoesSalvo, datafinal: dataFinalSalvo, dataLembrete: dataLembrete, ativaLembrete: ativaLembrete, idLembrete: idLembrete))
            Notificacoes.criarLembrete(date: dataLembrete!, titulo: tituloSalvo, dataEvento: ConversorData.dataNotificacao(indice: 0, date: dataFinalSalvo), id: idLembrete)
        } else {
            self.eventos.append(Evento(titulo: tituloSalvo, anotacoes: anotacoesSalvo, datafinal: dataFinalSalvo, dataLembrete: nil, ativaLembrete: ativaLembrete, idLembrete: idLembrete))
        }
        if let valoresCodificados = try? JSONEncoder().encode(eventos) {
            UserDefaults.standard.set(valoresCodificados, forKey: "listaEventos")
        }
    }
    
    func editarDados(titulo: String, anotacao: String, id: UUID, dataFinalSalvar: Date, idLembrete: UUID, dataLembrete: Date?, ativaLembrete: Bool){
        
        for i in 0..<eventos.count {
            if id == eventos[i].id {
                eventos[i].titulo = titulo
                eventos[i].anotacoes = anotacao
                eventos[i].dataFinal = dataFinalSalvar
                if ativaLembrete == true {
                    eventos[i].dataLembrete = dataLembrete
                    eventos[i].ativaLembrete = true
                    Notificacoes.editarLembrete(id: idLembrete, date: dataLembrete!, titulo: titulo, dataEvento: ConversorData.dataNotificacao(indice: 0, date: dataFinalSalvar))
                } else {
                    eventos[i].ativaLembrete = false
                    eventos[i].dataLembrete = nil
                }
                
                DispatchQueue.main.async {
                    if let valoresCodificados = try? JSONEncoder().encode(self.eventos) {
                        UserDefaults.standard.set(valoresCodificados, forKey: "listaEventos")
                        self.fetch()
                    }
                }
            }
        }
    }
    
    public func criaListaPassada() -> [EventoAtualizado]{
            var eventosPassados: [EventoAtualizado] = []
            var indexCancelar: [Int] = []
            let listaTemp = eventosAtualizados
            
            for i in 0..<listaTemp.count{
                if calendario.calculoDiasCorridos(dataFinal: eventosAtualizados[i].dataFinal) < 0{
                    eventosPassados.append(eventosAtualizados[i])
                    indexCancelar.append(i)
                }
                
            }
        return eventosPassados.sorted(by: {$0.dataFinal < $1.dataFinal})
        }
        
        public func criaListaAtual() -> [EventoAtualizado]{
            var eventosAtuais: [EventoAtualizado] = []
            var indexCancelar: [Int] = []
            let listaTemp = eventosAtualizados
            
            for i in 0..<listaTemp.count{
                if calendario.calculoDiasCorridos(dataFinal: eventosAtualizados[i].dataFinal) >= 0{
                    eventosAtuais.append(eventosAtualizados[i])
                    indexCancelar.append(i)
                }
                
            }
            return eventosAtuais.sorted(by: {$0.dataFinal < $1.dataFinal})
        }
    
    func removerPassados(at offsets: IndexSet) {
        let listaPassada = criaListaPassada()
        let listaModel = eventos
        var index = 0
        for i in offsets {
            index = i
        }
        
        for i in 0 ..< listaModel.count {
            if listaModel[i].id == listaPassada[index].id{
                eventos.remove(at: i)
            }
        }
        if let valoresCodificados = try? JSONEncoder().encode(eventos) {
            UserDefaults.standard.set(valoresCodificados, forKey: "listaEventos")
        }
    }
    
    func removerAtuais(at offsets: IndexSet) {
        let listaAtual = criaListaAtual()
        let listaModel = eventos
        var index = 0
        for i in offsets{
            index = i
        }
        
        for i in 0 ..< listaModel.count{
            if listaModel[i].id == listaAtual[index].id{
                eventos.remove(at: i)
            }
        }

        if let valoresCodificados = try? JSONEncoder().encode(eventos) {
            UserDefaults.standard.set(valoresCodificados, forKey: "listaEventos")
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
}
