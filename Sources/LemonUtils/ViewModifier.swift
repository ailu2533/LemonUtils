//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/17.
//

import SwiftUI

public struct BoxModifier: ViewModifier {
    
    public func body(content: Content) -> some View {
        content
            .padding(4)
//            .background(Color(.white))
            .clipShape(RoundedRectangle(cornerRadius: 8))

    }
}

public extension View {
    func box() -> some View {
        modifier(BoxModifier())
    }
}

#Preview {
    Text("hello")
        .box()
}
