import StoreKit

class Avaliacao {
    static func pedidoAvaliacao() {
        var cont = 0
        cont = UserDefaults.standard.integer(forKey: "contador")
        cont += 1
        UserDefaults.standard.set(cont, forKey: "contador")
        
        if cont == 4{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
        }
    }
}


