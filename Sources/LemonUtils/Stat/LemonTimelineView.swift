//
//  SwiftUIView.swift
//
//
//  Created by ailu on 2024/4/17.
//

import SwiftUI

public struct TimelineItem<Data>: Identifiable {
    public var id: UUID
    let timeString: String
    public let data: Data

    public init(id: UUID, timeString: String, data: Data) {
        self.id = id
        self.timeString = timeString
        self.data = data
    }
}

private struct TimelineItemCardView<Data, Card: View>: View {
    let item: TimelineItem<Data>
    let cardBuilder: (TimelineItem<Data>) -> Card

    init(item: TimelineItem<Data>, cardBuilder: @escaping (TimelineItem<Data>) -> Card) {
        self.item = item
        self.cardBuilder = cardBuilder
    }

    var body: some View {
        HStack {
            Text(item.timeString)
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .frame(width: 50)

            DotLineShape(lineWidth: 2)
                .frame(width: 25)
                .foregroundStyle(Color(.systemGray2))

            cardBuilder(item)

            Spacer()
        }
        .frame(minHeight: 40)
    }
}

public struct LemonTimelineView<Data, Card: View>: View {
    private var items: [TimelineItem<Data>]
    private let cardBuilder: (TimelineItem<Data>) -> Card

    public init(items: [TimelineItem<Data>], cardBuilder: @escaping (TimelineItem<Data>) -> Card) {
        self.items = items
        self.cardBuilder = cardBuilder
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(items) { habit in
                TimelineItemCardView(item: habit, cardBuilder: cardBuilder)
            }
        }
        .box()
    }
}
