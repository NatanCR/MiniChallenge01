//
//  TesteCalendario.swift
//  DateExample
//
//  Created by Bruno Lafayette on 19/09/22.
//

import SwiftUI
import EventKit

class AdicionarCalendario{
    
    static public func requestAccessToCalendar(dataFinalSalvar: Int, anotacao: String, titulo: String) {
        let store = EKEventStore()
        store.requestAccess(to: .event) { granted, error in
            if let error = error {
                print(error)
                return
            }
            
            if granted {
                guard let calendar = store.defaultCalendarForNewEvents else { return }
                let event = EKEvent(eventStore: store)
                
                event.title = titulo
                event.startDate = Calendar.current.date(byAdding: .day, value: dataFinalSalvar + 1, to: Date())
                event.notes = anotacao
                event.isAllDay = true
                event.endDate = event.startDate
                event.calendar = calendar
                
                do {
                    try store.save(event, span: .thisEvent)
                    try store.commit()
                } catch {
                    print(error)
                }
            }
        }
    }
}

