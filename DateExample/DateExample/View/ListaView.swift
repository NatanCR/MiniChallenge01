import SwiftUI

struct ListaView: View {
    
    @StateObject var eventoModel: EventoViewModel
    @State var procuraTexto = ""
    @State var segmentSelection: EventoAtualizado.ID? = nil
    
    var eventosPassados: [EventoAtualizado] {
        eventoModel.criaListaPassada()
    }
    var eventosAtuais: [EventoAtualizado] {
        eventoModel.criaListaAtual()
    }
    
    private var buscarEventosFuturos: [EventoAtualizado] {
        if procuraTexto.isEmpty {
            return eventosAtuais
        } else {
            return eventosAtuais.filter {
                $0.titulo.localizedCaseInsensitiveContains(procuraTexto)
            }
        }
        
    }
    
    private var buscarEventosPassados: [EventoAtualizado] {
        if procuraTexto.isEmpty {
            return eventosPassados
        } else {
        return eventosPassados.filter {
            $0.titulo.localizedCaseInsensitiveContains(procuraTexto)
        }
    }
        
}
    
    var body: some View {
        NavigationView {
            if eventoModel.eventosAtualizados.count == 0{
                Text ("Você não possui nenhum registro")
                    .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                    .accessibilityRemoveTraits(.isStaticText)
                    .navigationTitle("Meus eventos")
            }else{
                VStack {
                    List {
                        Section{
                            ForEach(buscarEventosFuturos, id: \.id) { anotacao in
                                NavigationLink {
                                    DetalhesView(eventoModel: eventoModel, agenda: anotacao)
                                        .environmentObject(eventoModel)
                                } label: {
                                    CelulaLista(dados: anotacao)
                                }
                            }
                            .onDelete(perform: eventoModel.removerAtuais)
                        } header: {
                            Text("Futuros")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .accessibilityRemoveTraits(.isHeader)
                                .accessibilityRemoveTraits(.isStaticText)
                        }
                        Section{
                            ForEach(buscarEventosPassados, id: \.id) { passado in
                                NavigationLink {
                                    DetalhesView(eventoModel: eventoModel, agenda: passado)
                                        .environmentObject(eventoModel)
                                } label: {
                                    CelulaLista(dados: passado)
                                }
                            }
                            .onDelete(perform: eventoModel.removerPassados)
                        } header: {
                            Text("Passados")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .accessibilityRemoveTraits(.isHeader)
                                .accessibilityRemoveTraits(.isStaticText)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .onAppear {
                        UITableView.appearance().backgroundColor = .clear
                        eventoModel.mudarEstrutura(vmEventos: eventoModel)
                    }
                    .searchable(text: $procuraTexto, prompt: "Pesquisar")
                    .padding(.top, 1)
                    .background(Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00))
                }
                .navigationTitle("Meus eventos")
                .accessibilityRemoveTraits(.isHeader)
            }
        }
        .navigationViewStyle(.stack)
    }
}
