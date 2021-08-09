//
//  Model.swift
//  Google-Translate-Clone
//
//  Created by SCG on 5/29/21.
//

import Foundation
import SwiftUI

struct Results: Codable {
    var results: [Result]
}

struct Result: Codable {
    var id: Int
    let title: String
    let image: String
    
}

struct Data: Codable {
    var data: Languages
}

struct Languages: Codable {
    var languages: [Language]
}

struct Language: Codable {
//    var id = UUID()
    var language: String
    var name: String
}
