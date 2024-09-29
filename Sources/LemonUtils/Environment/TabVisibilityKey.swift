//
//  tappedHabitUUID.swift
//  LemonUtils
//
//  Created by Lu Ai on 2024/9/26.
//

import SwiftUI


struct TabVisibilityKey: EnvironmentKey {
    static let defaultValue: Binding<Visibility> = .constant(.visible)
}

extension EnvironmentValues {
    var tabVisibility: Binding<Visibility> {
        get { self[TabVisibilityKey.self] }
        set { self[TabVisibilityKey.self] = newValue }
    }
}

struct TabVisibilityModifier: ViewModifier {
    @Binding var visibility: Visibility

    func body(content: Content) -> some View {
        content
            .environment(\.tabVisibility, $visibility)
    }
}

extension View {
    func tabVisibility(_ visibility: Binding<Visibility>) -> some View {
        modifier(TabVisibilityModifier(visibility: visibility))
    }
}
