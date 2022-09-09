import SwiftUI

struct Listas: View {
    var body: some View {
        List (0..<10) { index in
            CustomRow()
        }
    }
}

struct listas_Previews: PreviewProvider {
    static var previews: some View {
        Listas()
    }
}
