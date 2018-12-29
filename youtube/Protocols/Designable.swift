//
//  Designable.swift
//  youtube
//
//  Created by noriki.iwamatsu on 2018/12/26.
//  Copyright © 2018 noriki.iwamatsu. All rights reserved.
//

import UIKit

protocol Designable { }

extension Designable where Self: UITableViewCell {
    static var nib: UINib {
        return UINib(nibName: self.className, bundle: nil)
    }
}
