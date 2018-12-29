//
//  IntExtensions.swift
//  youtube
//
//  Created by noriki.iwamatsu on 2018/12/26.
//  Copyright © 2018 noriki.iwamatsu. All rights reserved.
//

import Foundation

extension Int {
    var separate: String? {
        return self.format(.decimal)
    }

    func format(_ numberStyle: NumberFormatter.Style) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = numberStyle
        return formatter.string(from: self as NSNumber)
    }
}
