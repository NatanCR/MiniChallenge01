//
//  LaunchScreen.swift
//  DateExample
//
//  Created by Natan Rodrigues on 26/09/22.
//

import SwiftUI
//
//struct LaunchScreen: View {
//    @State var isActive : Bool = false
//    var body: some View {
//        if isActive {
//            MainView()
//        } else {
//            ZStack {
//                Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00)
//                    .ignoresSafeArea()
//                VStack{
//                    Image("logo_dias_ate05")
//                        .padding(.trailing, 1)
//                }
//            }
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//                    withAnimation {
//                        self.isActive = true
//                    }
//                }
//            }
//        }
//    }
//}

struct LaunchScreen: View {
    
    @State var animationValues: [Bool] = Array(repeating: false, count: 10)
    @State private var moverCirculo = -2.5
    @State var isActive : Bool = false
    
    var body: some View {
        if isActive {
            MainView()
        } else {
        ZStack {
            Color.init(red: 0.79, green: 0.85, blue: 0.90, opacity: 1.00)
                .ignoresSafeArea()
            HStack {
                Text("dias")
                    .padding()
                    .font(.system(size: 37, weight: .bold, design: .rounded))
                    .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
//                    .scaleEffect(animationValues[2] ? 1 : 0, anchor: .bottom)
                ZStack {
                    
                    ZStack {
                        Circle() // borda de cima
                            .trim(from: 0.61, to: 0.99)
                            .stroke(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00), lineWidth: 7)
                            .frame(width: 100, height: 100)
                            .rotationEffect(.init(degrees: -16))
                            .offset(y: 1)
//                            .scaleEffect(animationValues[2] ? 1 : 0, anchor: .bottom)
                        
                        Circle() //borda de baixo
                            .trim(from: 0.1, to: 0.49)
                            .stroke(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00), lineWidth: 7)
                            .frame(width: 100, height: 100)
                            .rotationEffect(.init(degrees: -16))
                            .offset(y: 1)
//                            .scaleEffect(animationValues[2] ? 1 : 0, anchor: .bottom)
                    }
//                    .opacity(animationValues[2] ? 1 : 0)
                    
                    ZStack {
//                        if animationValues[2] {
                            Circle() //circulo direito
                                .fill(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                                .frame(width: 40, height: 40)
//                                .scaleEffect(animationValues[2] ? 1 : 0, anchor: .bottom)
                                .offset(x: 50)
//                        }
                        Image(systemName: "circle.fill")
                            .font(.system(size: 35))
                            .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
                            .offset(x: -50)
                            .rotationEffect(.degrees(moverCirculo))
                            .animation (
                                Animation
                                    .easeOut(duration: 1)
                                    .delay(0.5)
                                    .repeatForever(autoreverses: false)
                                    .speed(0.8))
                        
                        Circle() //circulo esquerdo
                            .stroke(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00), lineWidth: 6)
                            .frame(width: 35, height: 35)
//                            .scaleEffect(animationValues[2] ? 1 : 0, anchor: .bottom)
                            .offset(x: -50)
                    }
                    .task {
                        moverCirculo = 180
                    }
                    .environment(\.colorScheme, .light)
                }
                Text("até")
                    .padding()
                    .font(.system(size: 37, weight: .bold, design: .rounded))
                    .foregroundColor(Color.init(red: 0.00, green: 0.16, blue: 0.35, opacity: 1.00))
//                    .scaleEffect(animationValues[2] ? 1 : 0, anchor: .bottom)
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 0.3)){
                    animationValues[0] = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                    withAnimation {
                        self.isActive = true
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3){
                    animationValues[1] = true
                    
                    withAnimation(.easeInOut(duration: 0.4).delay(0.25)){
                        animationValues[2] = true
                    }
                    
                    withAnimation(.easeInOut(duration: 0.3).delay(0.45)){
                        animationValues[3] = true
                    }
                }
            }
        }
    }
    }
}


//struct LaunchScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        LaunchScreen()
//    }
//}
