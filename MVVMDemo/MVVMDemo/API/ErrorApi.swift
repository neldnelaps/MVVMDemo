//
//  ErrorApi.swift
//  MVVMDemo
//
//  Created by Natalia Pashkova on 04.04.2023.
//

import Foundation

struct ErrorApi: Error {
    let message: String
    var localizedDescription: String { message }
}
