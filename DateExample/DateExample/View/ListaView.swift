import SwiftUI

struct ListaView: View {
    
    @EnvironmentObject var lista: Model
    @State var procuraTexto = ""
    @State var modeloEditar: EditMode = .inactive
    @State var segmentSelection: Dados.ID? = nil
    @State var condicao = false 

    var body: some View {
        NavigationView {
            if lista.anotacoes.count == 0{
                Text ("Você não possui nenhum registro")
            }else{
                VStack {
                    List {
                        if modeloEditar == .inactive {
                            ForEach(eventos, id: \.id) { anotacao in
                                NavigationLink(destination: DetalhesView(lembrete: anotacao.dataLembrete ?? nil,
                                                                         id: anotacao.id,
                                                                         titulo: anotacao.titulo,
                                                                         anotacao: anotacao.anotacoes,
                                                                         dataFinal: anotacao.dataFinal)) {
                                    
                                    CustomRow(titulo: anotacao.titulo,
                                              dataFinal: conversorDataString(dataSalva: anotacao.dataFinal))
                                    
                                }
                            }
                            .onDelete(perform: remover)
                            
                        } else {
                            ForEach(eventos, id: \.id) { anotacao in
                                NavigationLink(destination: ResultadoView(dataFinalSalvar: anotacao.dataFinal,
                                                                          titulo: anotacao.titulo,
                                                                          anotacao: anotacao.anotacoes,
                                                                          modoEditar: true,
                                                                          id: anotacao.id),
                                               
                                               tag: anotacao.id,
                                               selection: self.$segmentSelection) {
                                    
                                    CustomRow(titulo: anotacao.titulo,
                                              dataFinal: conversorDataString(dataSalva: anotacao.dataFinal))
                                    
                                }
                                .onTapGesture(perform: { self.segmentSelection = anotacao.id })
                            }
                            .onDelete(perform: remover)
                        }
                    }
                    .environment(\.editMode, $modeloEditar)
                    .navigationBarItems(trailing: botaoEditar)
                }
                .navigationTitle("Listas de eventos")
                .searchable(text: $procuraTexto)
            }
        }
    }
    
    private var tapGesture: some Gesture {
        TapGesture().onEnded {
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
    
}

