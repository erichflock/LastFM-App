//
//  CaseIterableDefault.swift
//  LastFM-App
//
//  Created by Erich Flock on 28.02.21.
//

protocol CaseIterableDefault: Codable & CaseIterable & RawRepresentable where RawValue: Codable {
    static var defaultValue: Self { get }
}

extension CaseIterableDefault {
    
    init(from decoder: Decoder) throws {
        let rawValue = try decoder.singleValueContainer().decode(RawValue.self)
        if let initValue = Self(rawValue: rawValue) {
            self = initValue
        } else {
            self = Self.defaultValue
        }
    }
}
