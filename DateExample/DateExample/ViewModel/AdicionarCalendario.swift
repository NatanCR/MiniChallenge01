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
            
            //            isGranted = granted
            
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
    
//    func fetchEventsFromCalendar() {
//        store.requestAccess(to: .event) { granted, error in
//            if let error = error {
//                print(error)
//                return
//            }
//
//            if !granted {
//                print("Acesso não permitido")
//                return
//            }
//
//            let calendars = store.calendars(for: .event)
//            var calendar = store.calendar(withIdentifier: "Calendar")
//
//            for i in calendars {
//                if i.title == "Calendar" {
//                    calendar = i
//                }
//            }
//
//            let oneMonthAgo = Date(timeIntervalSinceNow: -30*24*3600)
//            let oneMonthAfter = Date(timeIntervalSinceNow: 30*24*3600)
//            let predicate =  store.predicateForEvents(withStart: oneMonthAgo, end: oneMonthAfter, calendars: [calendar!])
//            let events = store.events(matching: predicate)
//            for event in events {
//                print(event.title ?? "SEM TÍTULO")
//                print(event.startDate ?? Date())
//                print(event.endDate ?? Date())
//            }
//        }
//    }
}

