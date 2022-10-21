//
//  Evento.swift
//  DateExample
//
//  Created by Bruno Lafayette on 22/09/22.
//

import SwiftUI
import Combine
import EventKit

class EventoViewModel: ObservableObject{
    
    @Published var listaCalendario: [EKCalendar] = []
    @Published var eventos = [Evento]()
    @Published var eventosAtualizados = [EventoAtualizado]()
    let vmCalendario = Calendario()
    let calendarioEventos = EKEventStore()
    let calendario = Calendar(identifier: .gregorian)
    var forkeyUserDefaults = "listaEventosAtualizado"
    var trocarEstrutura: Bool {
        !UserDefaults.standard.bool(forKey: "atualizarEstrutura")
    }
    var cancelavel = Set<AnyCancellable>()

    init(){
        listaCalendario = vmCalendario.listarCalendarios()
        
        // esse é novo
//        trocarEstrutura = UserDefaults.standard.bool(forKey: "teste25")
        verificarAtualizacaoLista()
        NotificationCenter.default.publisher(for: .EKEventStoreChanged)
            .sink { (_) in
                self.atualizarListas()
            }.store(in: &cancelavel)
    }
    
    func mudarEstrutura(vmEventos: EventoViewModel){
        if trocarEstrutura{
            for i in 0 ..< eventos.count{
                print(eventos[i].titulo)
                eventosAtualizados.append(EventoAtualizado(titulo: eventos[i].titulo, anotacoes: eventos[i].anotacoes, datafinal: eventos[i].dataFinal, dataLembrete: eventos[i].dataLembrete, ativaLembrete: eventos[i].ativaLembrete, idLembrete: eventos[i].idLembrete, idCalendario: nil, adicionarCalendario: false))
                print(eventos[i])
            }
            UserDefaults.standard.set(true, forKey: "atualizarEstrutura")
        }
        print(eventosAtualizados)
    }
    
    
    func adicionarNovo(tituloSalvo: String, anotacoesSalvo: String, dataFinalSalvo: Date, dataLembrete: Date?, ativaLembrete: Bool, idLembrete: UUID, adicionarCalendario: Bool, selecionarCalendario: Int) {
        var idCalendario: String?
        if adicionarCalendario{
            idCalendario = Calendario().adicionarEvento(dataFinal: dataFinalSalvo, anotacao: anotacoesSalvo, titulo: tituloSalvo, calendario: listaCalendario[selecionarCalendario].calendarIdentifier)
        }
        self.eventosAtualizados.append(EventoAtualizado(titulo: tituloSalvo, anotacoes: anotacoesSalvo, datafinal: dataFinalSalvo, dataLembrete: dataLembrete, ativaLembrete: ativaLembrete, idLembrete: idLembrete, idCalendario: idCalendario, adicionarCalendario: adicionarCalendario))
        
        if ativaLembrete{
            Notificacoes.criarLembrete(date: dataLembrete!, titulo: tituloSalvo, dataEvento: ConversorData.dataNotificacao(indice: 0, date: dataFinalSalvo), id: idLembrete)
        }
        if let valoresCodificados = try? JSONEncoder().encode(eventosAtualizados) {
            UserDefaults.standard.set(valoresCodificados, forKey: forkeyUserDefaults)
        }
    }
    
    func editarDados(titulo: String, anotacao: String, id: UUID, dataFinalSalvar: Date, idLembrete: UUID, dataLembrete: Date?, ativaLembrete: Bool, eventoCalendario: Bool, idCalendario: String?, calendario: String?){
            let eventosAux = eventosAtualizados
            for i in 0..<eventosAux.count {
                if id == eventosAux[i].id {
                    eventosAux[i].titulo = titulo
                    eventosAux[i].anotacoes = anotacao
                    eventosAux[i].dataFinal = dataFinalSalvar
                    eventosAux[i].idCalendario = vmCalendario.editarEventoCalendario(addEventoCalendario: eventoCalendario,idCalendario: idCalendario, dataEvento: dataFinalSalvar, anotacao: anotacao, titulo: titulo, calendario: calendario)
                    if ativaLembrete{
                        eventosAux[i].dataLembrete = dataLembrete
                        eventosAux[i].ativaLembrete = true
                        Notificacoes.editarLembrete(id: idLembrete, date: dataLembrete!, titulo: titulo, dataEvento: ConversorData.dataNotificacao(indice: 0, date: dataFinalSalvar))
                    } else {
                        eventosAux[i].ativaLembrete = false
                        eventosAux[i].dataLembrete = nil
                    }
                    DispatchQueue.main.async {
                        self.eventosAtualizados = eventosAux
                        if let valoresCodificados = try? JSONEncoder().encode(self.eventosAtualizados) {
                            UserDefaults.standard.set(valoresCodificados, forKey: self.forkeyUserDefaults)
                        }
                    }
                }
            }
        }
    
    public func criaListaPassada() -> [EventoAtualizado]{
            var eventosPassados: [EventoAtualizado] = []
            let listaTemp = eventosAtualizados
            
            for i in 0..<listaTemp.count{
                if calendario.calculoDiasCorridos(dataFinal: eventosAtualizados[i].dataFinal) < 0{
                    eventosPassados.append(eventosAtualizados[i])
                }
                
            }
        return eventosPassados.sorted(by: {$0.dataFinal < $1.dataFinal})
        }
        
        public func criaListaAtual() -> [EventoAtualizado]{
            var eventosAtuais: [EventoAtualizado] = []
            let listaTemp = eventosAtualizados
            
            for i in 0..<listaTemp.count{
                if calendario.calculoDiasCorridos(dataFinal: eventosAtualizados[i].dataFinal) >= 0{
                    eventosAtuais.append(eventosAtualizados[i])
                }
                
            }
            return eventosAtuais.sorted(by: {$0.dataFinal < $1.dataFinal})
        }
    
    func removerPassados(at offsets: IndexSet) {
        let listaPassada = criaListaPassada()
        let listaModel = eventosAtualizados
        var index = 0
        for i in offsets {
            index = i
        }
        
        for i in 0 ..< listaModel.count {
            if listaModel[i].id == listaPassada[index].id{
                vmCalendario.removerCalendario(idCalendario: eventosAtualizados[index].idCalendario ?? nil)
                eventosAtualizados.remove(at: i)
            }
        }
        if let valoresCodificados = try? JSONEncoder().encode(eventosAtualizados) {
            UserDefaults.standard.set(valoresCodificados, forKey: forkeyUserDefaults)
        }
    }
    
    func removerAtuais(at offsets: IndexSet) {
        let listaAtual = criaListaAtual()
        let listaModel = eventosAtualizados
        var index = 0
        for i in offsets{
            index = i
        }
        
        for i in 0 ..< listaModel.count{
            if listaModel[i].id == listaAtual[index].id{
                vmCalendario.removerCalendario(idCalendario: eventosAtualizados[index].idCalendario ?? nil)
                eventosAtualizados.remove(at: i)
            }
        }

        if let valoresCodificados = try? JSONEncoder().encode(eventosAtualizados) {
            UserDefaults.standard.set(valoresCodificados, forKey: forkeyUserDefaults)
        }
    }
    
    func esconderTeclado() {
        let resposta = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resposta, to: nil, from: nil, for: nil)
    }
    
    func fetch() {
        if let anotacoesCodificadas = UserDefaults.standard.object(forKey: forkeyUserDefaults) as? Data {
            if let anotacoesDecodificadas = try? JSONDecoder().decode([EventoAtualizado].self, from: anotacoesCodificadas){
                DispatchQueue.main.async {
                    self.eventosAtualizados = anotacoesDecodificadas
                }
            }
        }
    }
    
    func fetchListaAntiga() {
        if let anotacoesCodificadas = UserDefaults.standard.object(forKey: "listaEventos") as? Data {
            if let anotacoesDecodificadas = try? JSONDecoder().decode([Evento].self, from: anotacoesCodificadas){
                DispatchQueue.main.async {
                    self.eventos = anotacoesDecodificadas
                }
            }
        }
    }
    
//    func atualizarEstrutura() -> Bool{
//        return UserDefaults.standard.set(true, forKey: "Atualizar")
//    }
    
    func verificarAtualizacaoLista(){
        if trocarEstrutura{
            fetchListaAntiga()
            fetch()
        }else{
            fetch()
        }
    }
    
}

extension EventoViewModel{
    
    func checarPermissaoCalendario(){
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch(status){

        case .notDetermined:
            acessoCalendario()
        case .restricted, .denied:
            acessoCalendario()
        case .authorized:
            fetch()
        @unknown default:
            // mostrar um alerta de erro
            print("Error")
        }
    }
    
    func atualizarListas(){
        let agenda = calendarioEventos.events(matching: vmCalendario.periodo())
        let lista = eventosAtualizados
        for i in 0 ..< agenda.count {
            for j in 0 ..< eventosAtualizados.count{
                if agenda[i].eventIdentifier == eventosAtualizados[j].idCalendario{
                    lista[j].titulo = agenda[i].title
                    lista[j].anotacoes = agenda[i].notes ?? ""
                }
                
            }
        }
        eventosAtualizados = lista
        if let valoresCodificados = try? JSONEncoder().encode(eventosAtualizados) {
            UserDefaults.standard.set(valoresCodificados, forKey: "listaEventos")
        }
    }
    
    func acessoCalendario(){
        calendarioEventos.requestAccess(to: EKEntityType.event) { [self] (permitido: Bool, naoPermitido: Error?) in
            if permitido == true{
                fetch()
            } else {
                // adicionar alerta para levar usuario para configuracoes
                // confirmar quais acoes serao feitas caso o usuario nao aceite ou desabilite a funcao de ativar o calendario.
                print("Deu erro")
            }
        }
    }
}
