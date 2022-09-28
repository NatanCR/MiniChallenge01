import SwiftUI

struct ListaView: View {
    
    @EnvironmentObject var evento: EventoViewModel
    @State var procuraTexto = ""
    @State var segmentSelection: Dados.ID? = nil
    @State var condicao = false
    @State var mostrarInfos = false
    
    private var eventosFiltrados: [Dados] {
        if procuraTexto.isEmpty {
            return evento.eventos.sorted(by: {$0.dataFinal < $1.dataFinal})
        } else {
            return evento.eventos.filter {
            $0.titulo.localizedCaseInsensitiveContains(procuraTexto)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            if evento.eventos.count == 0{
                Text ("Você não possui nenhum registro")
                    .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
            }else{
                VStack {
                    List {
                        ForEach(eventosFiltrados, id: \.id) { anotacao in
                            NavigationLink {
                                DetalhesView(agenda: anotacao)
                                    .environmentObject(evento)
                            } label: {
                                CelulaLista(dados: anotacao)
                            }
                        }
                        .onDelete(perform: evento.remover)
                    }
                    
                    .onAppear {
                        UITableView.appearance().backgroundColor = .clear
                    }
                    .searchable(text: $procuraTexto, prompt: "Pesquisar")
                    .padding(.top, 1)
                    .background(Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00))
                }
                .navigationTitle("Seus eventos")
            }
        }
    }
}
