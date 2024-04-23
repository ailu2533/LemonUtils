//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/22.
//

import SwiftUI

struct SwiftUIView: View {
    var body: some View {
        Rectangle()
            .fill(.blue.opacity(0.2))
            .frame(width: 150, height: 200)
            .overlay {
                GeometryReader { proxy in
                    ZStack {
                        Rectangle()
                            .fill(.blue.opacity(0.01))
                            .overlay(alignment: .bottomTrailing) {
                                Image(systemName: "xmark.circle")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .offset(x: 10, y: 10)
                                    .onTapGesture {
                                        print(proxy.size)
                                    }
                                    .gesture(DragGesture()
                                        .onChanged({ value in
                                            print(value.location)
                                        })
                                    )
                            }
                    }
                }
            }
    }
}

#Preview {
    SwiftUIView()
}
