//
//  MultipleSelectionView.swift
//  MyHabit
//
//  Created by ailu on 2024/3/25.
//

import SwiftUI

struct MultipleSelectionView<Item: Hashable>: View {
    @Binding private var selections: Set<Item>

    private var data: [Item]

    init(selections: Binding<Set<Item>>, data: [Item]) {
        _selections = selections
        self.data = data
    }

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 50, maximum: 200))], content: {
            ForEach(data, id: \.self) { item in
                Button(action: {
                    if selections.contains(item) {
                        selections.remove(item)
                    } else {
                        selections.insert(item)
                    }
                }, label: {
                    Text("\(item)")
                }).buttonStyle(MyButtonStyle(selected: selections.contains(item)))
            }
        })
    }
}

struct MultipleSelectionViewPreview: View {
    @State private var selections: Set<String> = Set<String>()

    @State private var data: [String] = ["周一", "周二", "周三"]

    var body: some View {
        MultipleSelectionView(selections: $selections, data: data)
    }
}

#Preview {
    MultipleSelectionViewPreview()
}
