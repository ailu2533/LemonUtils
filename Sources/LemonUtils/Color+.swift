//
//  File.swift
//
//
//  Created by ailu on 2024/4/16.
//

import Foundation
import SwiftUI

public extension Color {
    init?(hex: String) {
        guard let uiColor = UIColor(hex: hex) else {
            return nil
        }
        self.init(uiColor: uiColor)
    }

    func toHexString(includeAlpha: Bool = false) -> String? {
        return UIColor(self).toHexString(includeAlpha: includeAlpha)
    }

    static func random() -> Color {
        let uiColor = UIColor(red: .random(in: 0 ... 1), green: .random(in: 0 ... 1), blue: .random(in: 0 ... 1), alpha: 1.0)

        return Color(uiColor: uiColor)
    }
}

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

#Preview("彩虹色") {
    ScrollView {
        LazyVStack {
            ForEach(ColorSets.rainbow.indices, id: \.self) { i in
                let color = Color(hex: ColorSets.rainbow[i])!
                Rectangle()
                    .fill(color)
                    .frame(width: 100, height: 100)
            }
        }
    }
}
