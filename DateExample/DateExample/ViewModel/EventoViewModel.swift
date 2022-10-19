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
    let vmCalendario = Calendario()
    var cancellables = Set<AnyCancellable>()
    var calendario = EKEventStore()

    init(){
        listaCalendario = vmCalendario.listarCalendarios()
        fetch()
        NotificationCenter.default.publisher(for: .EKEventStoreChanged)
            .sink { (_) in
                self.atualizarListas()
            }.store(in: &cancellables)
    }
    
    func adicionarNovo(tituloSalvo: String, anotacoesSalvo: String, dataFinalSalvo: Date, dataLembrete: Date?, ativaLembrete: Bool, idLembrete: UUID, adicionarCalendario: Bool, calendarioAdicionar: Int) {
        var idCalendario: String?
        if adicionarCalendario{
            idCalendario = Calendario().adicionarEvento(dataFinal: dataFinalSalvo, anotacao: anotacoesSalvo, titulo: tituloSalvo, calendario: listaCalendario[calendarioAdicionar].calendarIdentifier)
        }
        self.eventos.append(Evento(titulo: tituloSalvo, anotacoes: anotacoesSalvo, datafinal: dataFinalSalvo, dataLembrete: dataLembrete, ativaLembrete: ativaLembrete, idLembrete: idLembrete, idCalendario: idCalendario, adicionarCalendario: adicionarCalendario))
        
        if ativaLembrete{
            Notificacoes.criarLembrete(date: dataLembrete!, titulo: tituloSalvo, dataEvento: ConversorData.dataNotificacao(indice: 0, date: dataFinalSalvo), id: idLembrete)
        }

        if let valoresCodificados = try? JSONEncoder().encode(eventos) {
            UserDefaults.standard.set(valoresCodificados, forKey: "listaEventos")
        }
    }
    
    func editarDados(titulo: String, anotacao: String, id: UUID, dataFinalSalvar: Date, idLembrete: UUID, dataLembrete: Date?, ativaLembrete: Bool, eventoCalendario: Bool, idCalendario: String?, calendario: String?){
        let eventosAux = eventos
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
                    self.eventos = eventosAux
                    if let valoresCodificados = try? JSONEncoder().encode(self.eventos) {
                        UserDefaults.standard.set(valoresCodificados, forKey: "listaEventos")
                    }
                }
            }
        }
    }
    
    func remover(at offsets: IndexSet) {
        var listaOrdenada = eventos.sorted(by: {$0.dataFinal < $1.dataFinal})
        var index = 0
        for i in offsets{
            index = i
        }
        vmCalendario.removerCalendario(idCalendario: listaOrdenada[index].idCalendario ?? nil)
        listaOrdenada.remove(atOffsets: offsets)
        eventos = listaOrdenada
        if let valoresCodificados = try? JSONEncoder().encode(eventos) {
            UserDefaults.standard.set(valoresCodificados, forKey: "listaEventos")
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
}

//MARK: - Métodos do Calendário

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
        let agenda = calendario.events(matching: vmCalendario.periodo())
        let lista = eventos
        for i in 0 ..< agenda.count {
            for j in 0 ..< eventos.count{
                if agenda[i].eventIdentifier == eventos[j].idCalendario{
                    lista[j].titulo = agenda[i].title
                    lista[j].anotacoes = agenda[i].notes ?? ""
                }
                
            }
        }
        eventos = lista
        if let valoresCodificados = try? JSONEncoder().encode(eventos) {
            UserDefaults.standard.set(valoresCodificados, forKey: "listaEventos")
        }
    }
    
    func acessoCalendario(){
        calendario.requestAccess(to: EKEntityType.event) { [self] (permitido: Bool, naoPermitido: Error?) in
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
