import SwiftUI

@available(iOS 17.0, *)
struct HorizontalPickerButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    var animationNamespace: Namespace.ID
    var groupID: String
    var isSelected = false
    var backgroundColor: Color = Color.clear

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(backgroundColor)
            .foregroundStyle(Color(.systemGray))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .saturation(isEnabled ? 1 : 0)
            .opacity(configuration.isPressed ? 0.5 : 1)
            .background {
                if isSelected {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(MyColor.buttonBgBlue)
                        .matchedGeometryEffect(id: groupID, in: animationNamespace)
                }
            }
    }
}

public struct HorizontalSelectionPicker<ItemType: Hashable, Content: View>: View {
    var items: [ItemType]
    @Binding private var selectedItem: ItemType

    var backgroundColor: Color

    @ViewBuilder var itemViewBuilder: (ItemType) -> Content

    @Namespace private var animationNamespace

    private var uniqueID = UUID().uuidString
    private var isEmbeddedInScrollView = true

    // MARK:

    public init(items: [ItemType], selectedItem: Binding<ItemType>, backgroundColor: Color = Color(.clear), isEmbeddedInScrollView: Bool = true,
                groupId: String = "picker",
                itemViewBuilder: @escaping (ItemType) -> Content) {
        self.items = items
        uniqueID = groupId
        _selectedItem = selectedItem
        self.backgroundColor = backgroundColor
        self.itemViewBuilder = itemViewBuilder
        self.isEmbeddedInScrollView = isEmbeddedInScrollView
    }

    public var body: some View {
        if isEmbeddedInScrollView {
            ScrollView(.horizontal) {
                itemsStackView()
            }.scrollIndicators(.hidden)
        } else {
            itemsStackView()
        }
    }

    private func itemsStackView() -> some View {
        HStack {
            ForEach(items, id: \.self) { dataItem in
                Button(action: {
                    selectedItem = dataItem
                }, label: {
                    itemViewBuilder(dataItem)
                        .frame(minWidth: 30)
                }).buttonStyle(HorizontalPickerButtonStyle(animationNamespace: animationNamespace, groupID: uniqueID, isSelected: selectedItem == dataItem, backgroundColor: backgroundColor))
            }.animation(.snappy, value: selectedItem)
        }
    }
}

struct WeekdaySelectionView: View {
    static let weekdays = [
        "星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日",
    ]

    @State private var selectedWeekday = WeekdaySelectionView.weekdays.first!

    var body: some View {
        HorizontalSelectionPicker(items: WeekdaySelectionView.weekdays, selectedItem: $selectedWeekday, backgroundColor: .gray.opacity(0.1)) { weekday in
            Text("\(weekday)")
        }
    }
}

// Preview
struct HorizontalPickerPreview: PreviewProvider {
    static var previews: some View {
        WeekdaySelectionView()
    }
}
