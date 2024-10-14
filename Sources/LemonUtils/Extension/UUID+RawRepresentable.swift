//
//  File.swift
//
//
//  Created by ailu on 2024/7/11.
//

import Foundation

extension UUID: @retroactive RawRepresentable {
    public var rawValue: String {
        uuidString
    }

    public typealias RawValue = String

    public init?(rawValue: RawValue) {
        self.init(uuidString: rawValue)
    }
}
