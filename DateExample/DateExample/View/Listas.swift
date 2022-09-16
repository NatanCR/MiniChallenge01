import SwiftUI

struct Listas: View {
    
    @EnvironmentObject var lista: Model
    @State var procuraTexto = ""
    @State var modeloEditar: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            if lista.anotacoes.count == 0{
                Text ("Você não possui nenhum registro")
            }else{
                VStack {
                    List {
                        ForEach(eventos, id: \.id) { anotacao in
                            NavigationLink(destination: DetalhesView(id: anotacao.id, titulo: anotacao.titulo, anotacao: anotacao.anotacoes, dataFinal: anotacao.dataFinal)) {
                                CustomRow(titulo: anotacao.titulo, dataFinal: conversorDataString(dataSalva: anotacao.dataFinal))
                            }
                        }
                        .onDelete(perform: remover)
                    }.environment(\.editMode, $modeloEditar)
                        .navigationBarItems(trailing: botaoEditar)
                }
                .navigationTitle("Listas de eventos")
                .searchable(text: $procuraTexto)
            }
        }
    }
    
    private var eventos: [Dados] {
        if procuraTexto.isEmpty {
            return lista.anotacoes
        } else {
            return lista.anotacoes.filter {
                $0.titulo.localizedCaseInsensitiveContains(procuraTexto)
            }
        }
    }
    
    private var botaoEditar: some View {
        return Button {
            if modeloEditar == .inactive {
                modeloEditar = .active
            } else {
                modeloEditar = .inactive
            }
        } label: {
            Text(modeloEditar == .inactive ? "Editar" : "OK")
        }
    }
    
    func remover(at offsets: IndexSet) {
        lista.anotacoes.remove(atOffsets: offsets)
        if let valoresCodificados = try? JSONEncoder().encode(lista.anotacoes) {
            UserDefaults.standard.set(valoresCodificados, forKey: "listaDados")
            return
        }
    }
    
    func conversorDataString(dataSalva: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt-br")
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let data = dateFormatter.string(from: dataSalva)
        return data
    }
    
    var dataInicio: Date = Date()
    var dataFinal: Date = Date().advanced(by: 60)
    
    var dia: Double {
        return 86400.0
    }
    
    var resultado: DateComponents {
        Calendar.current.dateComponents([.day,.hour,.minute], from: dataInicio, to: dataFinal)
    }
    
}

