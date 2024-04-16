//
//  Progress.swift
//  MyHabit
//
//  Created by ailu on 2024/3/30.
//

import SwiftUI

struct Progress: View {
    var progress: CGFloat {
        CGFloat(current) / CGFloat(total)
    }

    var total: Int
    var current: Int

    var body: some View {
        Circle()
            .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 20))
            .overlay {
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(Color.green, style: StrokeStyle(lineWidth: 20, lineCap: .round))
            }.overlay {
                HStack {
                    Text("\(current)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("/")
                        .font(.title3)
                    Text("\(total)")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
    }
}

#Preview {
    VStack {
        Spacer()
        Progress(total: 10, current: 5)
            .padding()
        Spacer()
    }
    .background(.gray.opacity(0.2))
}
