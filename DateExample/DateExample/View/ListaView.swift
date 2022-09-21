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
                    .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
            }else{
                VStack {
                    List {
                            ForEach(eventos, id: \.id) { anotacao in
                                NavigationLink(destination: DetalhesView(id: anotacao.id,
                                                                         titulo: anotacao.titulo,
                                                                         anotacao: anotacao.anotacoes,
                                                                         dataFinal: anotacao.dataFinal, dataLembrete: anotacao.dataLembrete ?? nil, ativaLembrete: anotacao.ativaLembrete)) {
                                    
                                    CustomRow(titulo: anotacao.titulo,
                                              dataFinal: conversorDataString(dataSalva: anotacao.dataFinal))
                                    
                                }
                            }
                            .onDelete(perform: remover)
                    }
                    .background(Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00))
                    .onAppear {
                        modeloEditar = .inactive
                        UITableView.appearance().backgroundColor = .clear
                    }
                }
                .navigationTitle("Seus eventos")
                .searchable(text: $procuraTexto, prompt: "Pesquisar")
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

