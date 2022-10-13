import SwiftUI

class ConversorData: ObservableObject{
    
    private static let dia: Double = 86400.0
    
    static func dataNotificacao (indice: Int, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        return dateFormatter.string(from: date.advanced(by: dia * Double(indice)))
    }
    
    static func conversorDataString(dataParaConversao: Date, recebeData: String = "SemData") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        if "dataHome" == recebeData{
            dateFormatter.dateFormat = "d MMMM yyyy"
            let data = dateFormatter.string(from: dataParaConversao)
            return data
        }else{
            dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
            let data = dateFormatter.string(from: dataParaConversao)
            return data
        }
    }
}

extension Calendar {
    
    private static let dia: Double = 86400.0
    
    static func dataParaString (indice: Int, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date.advanced(by: dia * Double(indice)))
    }
    
    func contadorDiasAte(dataFinal: Date, calculo: String) -> Int {
        let diaInicio = startOfDay(for: Date())
        let diaFinal = startOfDay(for: dataFinal)
        let diasCorridos = dateComponents([.day], from: diaInicio, to: diaFinal)
        if diasCorridos.day! <= 0 {
            return 0
        }
        
        switch calculo {
        case "corridos":
            return diasCorridos.day!
        case "uteis":
            var contador = 0
            for i in 0...diasCorridos.day! {
                let diaStr = Calendar.dataParaString(indice: i, date: Date())
                if diaStr != "sábado" && diaStr != "domingo"{
                    contador += 1
                }
            }
            return contador - 1
        case "semanas":
            if diasCorridos.day! <= 6 {
                return 0
            }
            let contador = Int(diasCorridos.day!/7)
            return contador
        case "finais":
            if diasCorridos.day! <= 0 {
                return 0
            }
            var contador = 0
            
            for i in 0...diasCorridos.day! {
                let diaStr = Calendar.dataParaString(indice: i, date: Date())
                if diaStr == "domingo"{
                    contador += 1
                }
            }
            return contador
        default:
            return 0
        }
    }
    
//    func calculoDiasCorridos(dataFinal: Date) -> Int {
//        let diaInicio = startOfDay(for: Date())
//        let diaFinal = startOfDay(for: dataFinal)
//        let diasCorridos = dateComponents([.day], from: diaInicio, to: diaFinal)
//
//        return diasCorridos.day!
//    }
//
//    func calculoDiasUteis(dataFinal: Date) -> Int {
//        let diaInicio = startOfDay(for: Date())
//        let diaFinal = startOfDay(for: dataFinal)
//        let diasCorridos = dateComponents([.day], from: diaInicio, to: diaFinal)
//
//        var contador = 0
//        for i in 0...diasCorridos.day! {
//            let diaStr = Calendar.dataParaString(indice: i, date: Date())
//            if diaStr != "sábado" && diaStr != "domingo"{
//                contador += 1
//            }
//        }
//        return contador - 1
//    }
//
//    func calculoSemanas(dataFinal: Date) -> Int {
//        let diaInicio = startOfDay(for: Date())
//        let diaFinal = startOfDay(for: dataFinal)
//        let diasCorridos = dateComponents([.day], from: diaInicio, to: diaFinal)
//
//        if diasCorridos.day! <= 6 {
//            return 0
//        }
//        let contador = Int(diasCorridos.day!/7)
//        return contador
//    }
}
