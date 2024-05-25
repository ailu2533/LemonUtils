import SwiftUI

@available(iOS 17.0, *)
struct HorizontalPickerButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    var isSelected = false
    var backgroundColor: Color = Color.clear

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundStyle(.secondary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
//            .frame(minWidth: 40)
            .background(backgroundView(configuration: configuration))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color.orange : Color.clear, lineWidth: isSelected ? 2 : 0)
                    // .fill(Color.clear)
                    .shadow(color: isSelected ? Color.orange.opacity(0.5) : Color.clear, radius: 3, x: 2, y: 0)
                    .blur(radius: isSelected ? 1 : 0)
            )
            .blur(radius: configuration.isPressed ? 3 : 0)
            .animation(.easeInOut, value: configuration.isPressed)
            .saturation(isEnabled ? 1 : 0.5)
//            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }

    @ViewBuilder
    private func backgroundView(configuration: Self.Configuration) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(isSelected ? Color.orange.opacity(0.4) : Color(.systemGray6))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: isSelected ? 2 : 0)
            )
    }
}

public struct HorizontalSelectionPicker<ItemType: Hashable, Content: View>: View {
    var items: [ItemType]
    @Binding private var selectedItem: ItemType

    var backgroundColor: Color

    @ViewBuilder var itemViewBuilder: (ItemType) -> Content

    private var shouldEmbedInScrollView = true

    var feedback: SensoryFeedback?

    public init(items: [ItemType], selectedItem: Binding<ItemType>, backgroundColor: Color = Color(.clear), shouldEmbedInScrollView: Bool = true, feedback: SensoryFeedback? = nil,
                itemViewBuilder: @escaping (ItemType) -> Content) {
        self.items = items
        _selectedItem = selectedItem
        self.backgroundColor = backgroundColor
        self.itemViewBuilder = itemViewBuilder
        self.shouldEmbedInScrollView = shouldEmbedInScrollView
        self.feedback = feedback
    }

    public var body: some View {
        Group {
            if shouldEmbedInScrollView {
                ScrollView(.horizontal) {
                    itemsStackView()
                }
                .scrollIndicators(.hidden)
            } else {
                itemsStackView()
            }
        }.contentMargins(.vertical, 4)
            .contentMargins(.horizontal, 12)
    }

    private func itemsStackView() -> some View {
        HStack {
            ForEach(items, id: \.self) { dataItem in
                Button(action: {
                    selectedItem = dataItem
                }, label: {
                    itemViewBuilder(dataItem)
                        .frame(minWidth: 30)
                        .contentShape(Rectangle())
                })
                .buttonStyle(HorizontalPickerButtonStyle())
                .modifier(FeedbackViewModifier(feedback: feedback, trigger: selectedItem))
                .animation(.default, value: selectedItem)
            }
        }
        .padding(.trailing)
    }
}

struct FeedbackViewModifier<Trigger: Equatable>: ViewModifier {
    var feedback: SensoryFeedback?
    var trigger: Trigger

    func body(content: Content) -> some View {
        if let feedback {
            content.sensoryFeedback(feedback, trigger: trigger)
        } else {
            content
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
            Text(weekday)
        }
    }
}

// Preview
struct HorizontalPickerPreview: PreviewProvider {
    static var previews: some View {
        WeekdaySelectionView()
    }
}

public struct ComparableHorizontalSelectionPicker<ItemType: Hashable, Content: View>: View {
    var items: [ItemType]
    @Binding private var selectedItem: ItemType

    var backgroundColor: Color

    @ViewBuilder var itemViewBuilder: (ItemType) -> Content

    private var isEmbeddedInScrollView = true

    public init(items: [ItemType], selectedItem: Binding<ItemType>, backgroundColor: Color = Color(.clear), isEmbeddedInScrollView: Bool = true,
                itemViewBuilder: @escaping (ItemType) -> Content) {
        self.items = items
        _selectedItem = selectedItem
        self.backgroundColor = backgroundColor
        self.itemViewBuilder = itemViewBuilder
        self.isEmbeddedInScrollView = isEmbeddedInScrollView
    }

    public var body: some View {
        Group {
            if isEmbeddedInScrollView {
                ScrollView(.horizontal) {
                    itemsStackView()
                }
                .scrollIndicators(.hidden)
            } else {
                itemsStackView()
            }
        }.contentMargins(.vertical, 4)
            .contentMargins(.horizontal, 12)
    }

    private func itemsStackView() -> some View {
        HStack {
            ForEach(items, id: \.self) { dataItem in
                Button(action: {
                    selectedItem = dataItem
                }, label: {
                    itemViewBuilder(dataItem)
                        .frame(minWidth: 30)
                        .contentShape(Circle())
                }).buttonStyle(HorizontalPickerButtonStyle2(isSelected: selectedItem == dataItem, backgroundColor: backgroundColor))
            }
        }
        .padding(.trailing)
    }
}

struct HorizontalPickerButtonStyle2: ButtonStyle {
    @Environment(\.isEnabled) var isEnabled

    var isSelected = false
    var backgroundColor: Color = Color.clear

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(isSelected ? Color.white : backgroundColor)
            .foregroundColor(isSelected ? .black : .gray)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isSelected ? Color.orange : Color.gray, lineWidth: 2)
                    .shadow(color: isSelected ? Color.orange.opacity(0.5) : Color.clear, radius: 4, x: 0, y: 2)
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}

