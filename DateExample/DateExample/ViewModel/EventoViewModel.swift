//
//  Evento.swift
//  DateExample
//
//  Created by Bruno Lafayette on 22/09/22.
//

import SwiftUI

class EventoViewModel: ObservableObject{
    
    @Published var eventos = [Evento]()
    //    var eventosAux = [Dados]()
    
    init(){
        fetch()
    }
    
    func adicionarNovo(tituloSalvo: String, anotacoesSalvo: String, dataFinalSalvo: Date, dataLembrete: Date?, ativaLembrete: Bool, idLembrete: UUID) {
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
        @State var eventosAux = eventos
        
        for i in 0..<eventosAux.count {
            if id == eventosAux[i].id {
                eventosAux[i].titulo = titulo
                eventosAux[i].anotacoes = anotacao
                eventosAux[i].dataFinal = dataFinalSalvar
                if ativaLembrete == true {
                    eventosAux[i].dataLembrete = dataLembrete
                    eventosAux[i].ativaLembrete = true
                    Notificacoes.editarLembrete(id: id, date: dataLembrete!, titulo: titulo, dataEvento: ConversorData.dataNotificacao(indice: 0, date: dataFinalSalvar))
                } else {
                    eventosAux[i].ativaLembrete = false
                    eventosAux[i].dataLembrete = nil
                }
                
                DispatchQueue.main.async {
                    self.eventos = eventosAux
                    if let valoresCodificados = try? JSONEncoder().encode(self.eventos) {
                        UserDefaults.standard.set(valoresCodificados, forKey: "listaEventos")
//                        self.fetch()
                    }
                }
            }
        }
    }
    
    func remover(at offsets: IndexSet) {
        var listaOrdenada = eventos.sorted(by: {$0.dataFinal < $1.dataFinal})
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
    
    //    func recarregarLista() async {
    //        self.eventos = self.eventosAux
    //    }
}
