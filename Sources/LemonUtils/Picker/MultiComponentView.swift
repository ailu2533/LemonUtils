//
//  MultiComponentView.swift
//  MyHabit
//
//  Created by ailu on 2024/4/2.
//

import SwiftUI

public struct MultiComponentPickerView: UIViewRepresentable {
    var data: [[String]]
    @Binding var selections: [Int]

    public init(data: [[String]], selections: Binding<[Int]>) {
        self.data = data
        _selections = selections
    }

    // makeCoordinator()
    public func makeCoordinator() -> MultiComponentPickerView.Coordinator {
        Coordinator(self)
    }

    // makeUIView(context:)
    public func makeUIView(context: UIViewRepresentableContext<MultiComponentPickerView>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)

        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator

        return picker
    }

    // updateUIView(_:context:)
    public func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<MultiComponentPickerView>) {
        for i in 0 ... (selections.count - 1) {
            view.selectRow(selections[i], inComponent: i, animated: false)
        }
        context.coordinator.parent = self // fix
    }

    public class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: MultiComponentPickerView

        // init(_:)
        init(_ pickerView: MultiComponentPickerView) {
            parent = pickerView
        }

        // numberOfComponents(in:)
        public func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return parent.data.count
        }

        // pickerView(_:numberOfRowsInComponent:)
        public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.data[component].count
        }

        // pickerView(_:titleForRow:forComponent:)
        public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return parent.data[component][row]
        }

        // pickerView(_:didSelectRow:inComponent:)
        public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            parent.selections[component] = row
        }
    }
}
