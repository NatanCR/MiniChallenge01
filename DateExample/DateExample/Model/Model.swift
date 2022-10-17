//
//  Model.swift
//  DateExample
//
//  Created by Bruno Lafayette on 11/09/22.
//

import Foundation

class Evento: Codable, Identifiable{
    var id = UUID()
    var titulo: String
    var anotacoes: String
    var dataFinal: Date
    var dataLembrete: Date?
    var ativaLembrete: Bool
    var idLembrete: UUID
    
    init(titulo: String, anotacoes: String, datafinal: Date, dataLembrete: Date?, ativaLembrete: Bool, idLembrete: UUID) {
        self.titulo = titulo
        self.anotacoes = anotacoes
        self.dataFinal = datafinal
        self.dataLembrete = dataLembrete
        self.ativaLembrete = ativaLembrete
        self.idLembrete = idLembrete
    }
}

class EventoAtualizado: Codable, Identifiable{
    var id = UUID()
    var titulo: String
    var anotacoes: String
    var dataFinal: Date
    var dataLembrete: Date?
    var ativaLembrete: Bool
    var idLembrete: UUID
    var idCalendario: String?
    var adicionarCalendario = false
    
    init(titulo: String, anotacoes: String, datafinal: Date, dataLembrete: Date?, ativaLembrete: Bool, idLembrete: UUID, idCalendario: String?, adicionarCalendario: Bool) {
        self.titulo = titulo
        self.anotacoes = anotacoes
        self.dataFinal = datafinal
        self.dataLembrete = dataLembrete
        self.ativaLembrete = ativaLembrete
        self.idLembrete = idLembrete
        self.idCalendario = idCalendario
        self.adicionarCalendario = adicionarCalendario
    }
}
