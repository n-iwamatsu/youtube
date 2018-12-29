//
//  DateExtensions.swift
//  youtube
//
//  Created by noriki.iwamatsu on 2018/12/26.
//  Copyright © 2018 noriki.iwamatsu. All rights reserved.
//

import Foundation

extension Date {
    var string: String {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Date())
        if let year = components.year, 0 < year {
            return "\(year)年前"
        }
        if let month = components.month, 0 < month {
            return "\(month)ヶ月前"
        }
        if let day = components.day, 0 < day {
            return "\(day)日前"
        }
        if let hour = components.hour, 0 < hour {
            return "\(hour)時間前"
        }
        if let minute = components.minute, 0 < minute {
            return "\(minute)分前"
        }
        if let second = components.second, 0 < second {
            return "\(second)秒前"
        }
        return "今"
    }
}
