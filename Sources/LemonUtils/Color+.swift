//
//  File.swift
//
//
//  Created by ailu on 2024/4/16.
//

import Foundation
import SwiftUI


struct MyColor {
    static let buttonBgBlue = Color("buttonBgBlue", bundle: .module)
    static let buttonButtonBigBlue = Color("buttonButtonBigBlue", bundle: .module)
    static let buttonFontBlue = Color("buttonFontBlue", bundle: .module)

    
}

#Preview {
    ScrollView {
        VStack {
            Rectangle()
                .fill(Color("buttonBgBlue", bundle: .module))
                .frame(width: 200, height: 200)

            Rectangle()
                .fill(Color("buttonButtonBigBlue", bundle: .module))
                .frame(width: 200, height: 200)

            Rectangle()
                .fill(Color("buttonFontBlue", bundle: .module))

                .frame(width: 200, height: 200)
        }
    }
}
