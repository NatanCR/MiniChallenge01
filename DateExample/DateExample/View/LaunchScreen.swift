//
//  LaunchScreen.swift
//  DateExample
//
//  Created by Natan Rodrigues on 26/09/22.
//

import SwiftUI

struct LaunchScreen: View {
    @State var isActive : Bool = false
    var body: some View {
        if isActive {
            MainView()
        } else {
            ZStack {
                Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00)
                    .ignoresSafeArea()
                VStack{
                    Image("logo_dias_ate05")
                        .padding(.trailing, 1)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

struct LaunchScreen_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreen()
    }
}
