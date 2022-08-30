//
//  ContentView.swift
//  DateExample
//
//  Created by Natan Rodrigues on 29/08/22.
//

import SwiftUI

struct ContentView: View {
    @State var dataInicio: Date = Date()
    @State var dataFinal: Date = Date()

    
    var resultado: DateComponents {
        return Calendar.current.dateComponents([.day,.hour,.minute], from: dataInicio, to: dataFinal)
    }
    
    func dateComponent() -> Date? {
        var comps = DateComponents()
        comps.day = resultado.day
        comps.hour = resultado.hour
        comps.minute = resultado.minute
        
        return Calendar.current.date(from: comps)
    }
    
    var body: some View {
        let data = dateComponent()
        
        VStack {
            DatePicker("Data inicio", selection: $dataInicio, displayedComponents: [.date])
            DatePicker("Data fim", selection: $dataFinal, displayedComponents: [.date])
            Text("RESULTADO: \(resultado)")
           // Text(resultado, format: Date.FormatStyle().year().month().day())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//formatação da data de hoje usando Date e DateFormatter
//    func dataResultado() -> String {
//        let date = Date()
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .none
//
//        return dateFormatter.string(from: date)
//    }

//    static let stackDateFormat: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "dd MM yyy"
//        return formatter
//    }()
