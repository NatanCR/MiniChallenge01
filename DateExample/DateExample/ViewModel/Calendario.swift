//
//  TesteCalendario.swift
//  DateExample
//
//  Created by Bruno Lafayette on 19/09/22.
//

import SwiftUI
import EventKit

class Calendario {
    
    let evento = EKEventStore()


    func periodo() -> NSPredicate {
        let calendar = Calendar.autoupdatingCurrent
        var dataFim = DateComponents()
        dataFim.year = 1
        let dataFinal = calendar.date(byAdding: dataFim, to: .now)
        let predicate = self.evento.predicateForEvents(withStart: .now,
                                                           end: dataFinal!,
                                                           calendars: nil)
        return predicate
    }
    
    
    func listarCalendarios() -> [EKCalendar]{
        let listaCalendarios = evento.calendars(for: EKEntityType.event)
        return listaCalendarios
    }
    
    func adicionarEvento(dataFinal: Date, anotacao: String, titulo: String, calendario: String) -> String {
        guard let calendar = evento.calendar(withIdentifier: calendario) else { return "Erro"}
        let event = EKEvent(eventStore: evento)
        event.title = titulo
        event.notes = anotacao
        event.isAllDay = true
        event.startDate = dataFinal
        event.endDate = dataFinal
        event.calendar = calendar
        do {
            try evento.save(event, span: .thisEvent)
            try evento.commit()
        } catch {
            print(error)
        }
        return event.eventIdentifier
    }
    
    func editarEventoCalendario(addEventoCalendario: Bool, idCalendario: String?, dataEvento: Date, anotacao: String, titulo: String, calendario: String?) -> String?{
        var idEvento: String?
        let agenda = evento.events(matching: periodo())
        if idCalendario != nil{
            for i in 0 ..< agenda.count{
                if agenda[i].eventIdentifier == idCalendario{
                    if addEventoCalendario{
                        agenda[i].title = titulo
                        agenda[i].notes = anotacao
                        agenda[i].endDate = dataEvento
                        agenda[i].calendar = evento.calendar(withIdentifier: calendario!)
                        do {
                            try evento.save(agenda[i], span: .thisEvent, commit: true)
                            return agenda[i].eventIdentifier
                        } catch {
                            // adicionar um alerta caso tenha erro
                        }
                    }
                    else {
                        do {
                            try evento.remove(agenda[i], span: .thisEvent, commit: true)
                            return nil
                        } catch {
                            //adicionar alerta
                        }
                    }
                }
            }
        }
        if addEventoCalendario{
            idEvento = adicionarEvento(dataFinal: dataEvento, anotacao: anotacao, titulo: titulo, calendario: calendario!)
            return idEvento
        } else {
            return nil
        }
    }
    
    func removerCalendario(idCalendario: String?){
        let agenda = evento.events(matching: periodo())

        if idCalendario != nil{
            for i in 0 ..< agenda.count{
                if agenda[i].eventIdentifier == idCalendario{
                    do{
                        try evento.remove(agenda[i], span: .thisEvent, commit: true)
                    } catch{
                        // adicionar algum alerta
                    }
                }
            }
        }
    }
    
}

