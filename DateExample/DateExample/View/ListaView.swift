import SwiftUI

struct ListaView: View {
    
    @StateObject var eventoModel: EventoViewModel
    @State var procuraTexto = ""
    @State var segmentSelection: Evento.ID? = nil
    
    var eventosPassados: [EventoAtualizado] {
        eventoModel.criaListaPassada()
    }
    var eventosAtuais: [EventoAtualizado] {
        eventoModel.criaListaAtual()
    }
    
    private var eventosFiltrados: [EventoAtualizado] {
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
                        Section{
                            ForEach(eventosFiltrados, id: \.id) { anotacao in
                                NavigationLink {
                                    DetalhesView(eventoModel: eventoModel, agenda: anotacao)
                                        .environmentObject(eventoModel)
                                } label: {
                                    CelulaLista(dados: anotacao)
                                }
                            }
                            .onDelete(perform: eventoModel.remover)
                        } header: {
                            Text("Pendentes")
                        }
                        Section{
                            ForEach(eventosPassados, id: \.id) { passado in
                                NavigationLink {
                                    DetalhesView(eventoModel: eventoModel, agenda: passado)
                                        .environmentObject(eventoModel)
                                } label: {
                                    CelulaLista(dados: passado)
                                }
                            }
                            .onDelete(perform: eventoModel.remover)
                        } header: {
                            Text("Passados")
                        }
                    }
                    .listStyle(.insetGrouped)
                    .onAppear {
                        print(eventoModel.eventos)
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
