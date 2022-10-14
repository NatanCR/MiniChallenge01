import SwiftUI

struct ListaView: View {
    
    @StateObject var eventoModel: EventoViewModel
    @State var procuraTexto = ""
    @State var segmentSelection: Evento.ID? = nil
    
    private var eventosFiltrados: [Evento] {
        if procuraTexto.isEmpty {
            return eventoModel.eventos.sorted(by: {$0.dataFinal < $1.dataFinal})
        } else {
            return eventoModel.eventos.filter {
            $0.titulo.localizedCaseInsensitiveContains(procuraTexto)
            }
        }
    }
    
    var body: some View {
        NavigationView {
            if eventoModel.eventos.count == 0{
                Text ("Você não possui nenhum registro")
                    .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
            }else{
                VStack {
                    List {
                        ForEach(eventosFiltrados, id: \.id) { anotacao in
                            NavigationLink {
                                DetalhesView(eventoModel: eventoModel, agenda: anotacao)
                                    .environmentObject(eventoModel)
                            } label: {
                                CelulaLista(dados: anotacao)
                            }
                        }
                        .onDelete(perform: eventoModel.remover)
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
        .refreshable {
            eventoModel.fetch()
        }
    }
}
