//
//  BotaoCalendario.swift
//  DateExample
//
//  Created by Natan Rodrigues on 19/10/22.
//

import Foundation
import SwiftUI

struct BotaoCalendario: MenuStyle {
    
    func  makeBody ( configuration : Configuration ) -> some  View {
       HStack {
         Spacer ()
         // 1
        Menu (configuration)
         Spacer ()
         Image (systemName: "chevron.up.chevron.down" )
      }
      .padding() // 2
      . background( Color .mint)
      .cornerRadius( 8 )
       // 3
      .foregroundColor(.white)
    }
}

extension MenuStyle where Self == BotaoCalendario {
  static var customMenu: BotaoCalendario { .init() }
}
