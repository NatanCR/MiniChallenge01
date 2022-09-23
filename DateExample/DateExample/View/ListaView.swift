




import SwiftUI

struct ListaView: View {
    
    @EnvironmentObject var evento: EventoViewModel
    @State var procuraTexto = ""
    @State var segmentSelection: Dados.ID? = nil
    @State var condicao = false
    
    private var eventosFiltrados: [Dados] {
        if procuraTexto.isEmpty {
            return evento.eventos
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
                        ForEach($evento.eventos, id: \.id) { $anotacao in
                            NavigationLink {
                                DetalhesView(agenda: $anotacao)//
                                    .environmentObject(evento)
                            } label: {
                                CelulaLista(dados: $anotacao)
                            }
                        }
                        .onDelete(perform: evento.remover)
                    }
                    .background(Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00))
                    .onAppear {
                        UITableView.appearance().backgroundColor = .clear
                    }
                }
                .navigationTitle("Seus eventos")
                .searchable(text: $procuraTexto, prompt: "Pesquisar")
                
            }
        }
        .background(Color(red: 0.89, green: 0.92, blue: 0.94, opacity: 1.00))
    }
    
    
    func conversorDataString(dataSalva: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt-br")
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let data = dateFormatter.string(from: dataSalva)
        return data
    }
    
}

