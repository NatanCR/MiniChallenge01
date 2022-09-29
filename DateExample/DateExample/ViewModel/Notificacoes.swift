//
//  Notificacoes.swift
//  DateExample
//
//  Created by Bruno Lafayette on 17/09/22.
//

import Foundation
import UserNotifications

class Notificacoes: ObservableObject {
    
    static func permissao(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { sucesso, error in
            if sucesso{
            } else if let erro = error{
                print(erro.localizedDescription)
            }
        }
    }
    static public func criarLembrete(date: Date, titulo: String, dataEvento: String, id: UUID){
        var gatilho: UNNotificationTrigger?
        let dateComponents = Calendar.current.dateComponents([.year,.month,.day, .hour,.minute], from: date)
        gatilho = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.title = titulo
        content.body = dataEvento
        let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: gatilho)
        UNUserNotificationCenter.current().add(request)
    }

    static public func editarLembrete(id: UUID, date: Date,  titulo: String, dataEvento: String) {
                var gatilho: UNNotificationTrigger?
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id.uuidString])
                let dateComponents = Calendar.current.dateComponents([.year,.month,.day, .hour,.minute], from: date)
                gatilho = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                let content = UNMutableNotificationContent()
                content.sound = UNNotificationSound.default
                content.title = titulo
                content.body = dataEvento
                let request = UNNotificationRequest(identifier: id.uuidString, content: content, trigger: gatilho)
                UNUserNotificationCenter.current().add(request)
            }
}
