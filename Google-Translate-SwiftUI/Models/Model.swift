//
//  Model.swift
//  Google-Translate-Clone
//
//  Created by SCG on 5/29/21.
//

import Foundation
import SwiftUI

//MARK: - Model for translations
struct TranslationResults: Codable {
    var data: TranslationData
}

struct TranslationData: Codable {
    var translation: String
}

//MARK: - Model for list of languages
struct ListResults: Codable {
    var data: Languages
}

struct Languages: Codable {
    var languages: [Language]
}

struct Language: Codable {
    var language: String
    var name: String
}
