//
//  DateExtensions.swift
//  ActiveCitizen
//
//  Created by Vladimir Vetrov on 12.12.2019.
//  Copyright © 2019 Novotorica. All rights reserved.
//

import Foundation
extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) {
        self.init()
        self.formatOptions = formatOptions
        self.timeZone = timeZone
    }
}
extension Formatter {
    static let iso8601 = ISO8601DateFormatter([.withInternetDateTime, .withTimeZone, .withFractionalSeconds])
}
extension Date {
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
    
    var userFriendlyTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.setLocalizedDateFormatFromTemplate("HH:mm")
        return formatter.string(from: self)
    }
    
    var userFriendlyDateTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.setLocalizedDateFormatFromTemplate("dd.MM.yy, HH:mm")
        return formatter.string(from: self)
        
    }
}
extension String {
    var iso8601: Date? {
        return Formatter.iso8601.date(from: self)
    }
}

extension Date {
    var timestamp: UInt64 {
        return UInt64((self.timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
    }
}
extension NSDate {
    var iso8601: String {
        return Formatter.iso8601.string(from: self as Date)
    }
    
    var userFriendlyTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.setLocalizedDateFormatFromTemplate("HH:mm")
        return formatter.string(from: self as Date)
    }
    
    var userFriendlyDateTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.setLocalizedDateFormatFromTemplate("dd.MM.yy, HH:mm")
        return formatter.string(from: self as Date)
        
    }
}
