import SwiftUI

class CalcularDatas: ObservableObject{
    
    private static let dia: Double = 86400.0
    
    public static func calcularResultado(dataInicio: Date, dataFim: Date) -> DateComponents {
        return Calendar.current.dateComponents([.day,.hour,.minute,.second], from: dataInicio, to: dataFim)
    }
    
    public static func dateToString (indice: Int, date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date.advanced(by: dia * Double(indice)))
    }
    
    public static func calcularSemanas(dataInicio: Date, totalDias: Int) -> Int {
        if totalDias <= 6 {
            return 0
        }
        
        var contador = -1
        
        for i in 0...totalDias {
            let diaStr = dateToString(indice: i, date: dataInicio)
            if diaStr == "domingo"{
                contador += 1
            }
        }
        return contador
    }
    
    public static func calcularDiasCorridos(totalDias: Int) -> Int {
        return totalDias
    }
    
    public static func calcularFinaisSemana(totalDias: Int, diaInicio: Date) -> Int{
        if totalDias <= 0 {
            return 0
        }
        
        var contador = 0
        
        for i in 0...totalDias {
            let diaStr = dateToString(indice: i, date: diaInicio)
            if diaStr == "domingo"{
                contador += 1
            }
        }
        return contador
    }
    
    public static func calcularDiasUteis(totalDias: Int, dataInicio: Date) -> Int {
        if totalDias <= 0 {
            return 0
        }
        
        var contador = -1
        
        for i in 0...totalDias {
            let diaStr = dateToString(indice: i, date: dataInicio)
            if diaStr != "sábado" && diaStr != "domingo"{
                contador += 1
            }
        }
        return contador
    }
}
