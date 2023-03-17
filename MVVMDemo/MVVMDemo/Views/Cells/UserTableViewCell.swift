//
//  UserTableViewCell.swift
//  MVVMDemo
//
//  Created by Natalia Pashkova on 16.03.2023.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: "UserTableViewCell")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
