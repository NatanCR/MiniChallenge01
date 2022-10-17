import SwiftUI

struct ListaView: View {
    
    @StateObject var eventoModel: EventoViewModel
    @State var procuraTexto = ""
    @State var segmentSelection: Evento.ID? = nil
    
    var eventosPassados: [Dados] {
        evento.criaListaPassada()
    }
    var eventosAtuais: [Dados] {
        evento.criaListaAtual()
    }
    
    private var eventosFiltrados: [Dados] {
        if procuraTexto.isEmpty {
            return eventosAtuais.sorted(by: {$0.dataFinal < $1.dataFinal})
        } else {
            return eventosAtuais.filter {
                $0.titulo.localizedCaseInsensitiveContains(procuraTexto)
            }
        }
        
    }
    
    
    
    var body: some View {
        NavigationView {
            if eventoModel.eventosAtualizados.count == 0{
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
                            .onDelete(perform: evento.remover)
                        } header: {
                            Text("Pendentes")
                        }
                        Section{
                            ForEach(eventosPassados, id: \.id) { passado in
                                NavigationLink {
                                    DetalhesView(agenda: passado)
                                        .environmentObject(evento)
                                } label: {
                                    CelulaLista(dados: passado)
                                }
                            }
                            .onDelete(perform: evento.remover)
                        } header: {
                            Text("Passados")
                        }
                    }
                    .listStyle(.insetGrouped)
                    .onAppear {
                        UITableView.appearance().backgroundColor = .clear
                        eventoModel.atualizarEstrutura(eventos: eventoModel.eventos)
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
