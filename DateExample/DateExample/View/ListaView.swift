import SwiftUI

struct ListaView: View {

    @ObservedObject var eventoModel: EventoViewModel
    @State var procuraTexto = ""
    @State var segmentSelection: EventoAtualizado.ID? = nil

    public init(eventoModel: EventoViewModel) {
        self.eventoModel = eventoModel
    }
    
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

                        if eventosPassados.isEmpty{


                        } else{
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
                        }
                         header: {
                            Text("Passados")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                                .accessibilityRemoveTraits(.isHeader)
                                .accessibilityRemoveTraits(.isStaticText)
                        }
                    }
                    }
                    .listStyle(.insetGrouped)
                    .onAppear {
                        UITableView.appearance().backgroundColor = .clear
                    }
                    .searchable(text: $procuraTexto, prompt: "Pesquisar")
                    .padding(.top, 1)
                    .background(Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00))
                }
                .toolbar {
                    EditButton()
                }
                .navigationTitle("Meus eventos")
                .accessibilityRemoveTraits(.isHeader)
            }
        }
        .navigationViewStyle(.stack)
    }
}
