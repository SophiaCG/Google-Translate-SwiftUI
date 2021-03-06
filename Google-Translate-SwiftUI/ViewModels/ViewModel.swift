//
//  ViewModel.swift
//  Google-Translate-Clone
//
//  Created by SCG on 5/29/21.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var languages = [Language]()     // Language list (array)
    
    @Published var input: String = ""           // Text entered by user to translate
    @Published var translation: String = ""     // Translation of input
    @Published var sourceLang: String = "en"    // Language of input
    @Published var targetLang: String = "fr"    // Language of translation

    let apiKey = "API-KEY-HERE"
    
//MARK: - Language List API Call
    func getLanguages(completion:@escaping (ListResults) -> ()) {
        
        guard let url = URL(string: "https://google-translate1.p.rapidapi.com/language/translate/v2/languages?target=en&rapidapi-key=\(apiKey)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard data != nil else {
                print("TASK ERROR 1: \(String(describing: error))")
                return
            }
            
            do {
                let results = try JSONDecoder().decode(ListResults.self, from: data!)
                
                DispatchQueue.main.async {
                    self.languages = results.data.languages
                    completion(results)
                }
            } catch {
                print("RESULTS ERROR 1: \(error)")
            }
        }
        task.resume()
    }

//MARK: - Translation API Call
    func translate(for input: String, for sourceLang: String, for targetLang: String, completion:@escaping (TranslationResults) -> ()) {

        self.input = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print("Translating from \(sourceLang) to \(targetLang)")
        guard let url = URL(string: "https://google-translate20.p.rapidapi.com/translate?text=\(input)&sl=\(sourceLang)&tl=\(targetLang)&rapidapi-key=\(apiKey)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard data != nil else {
                print("TASK ERROR 2: \(String(describing: error))")
                return
            }
            
            do {
                let results = try JSONDecoder().decode(TranslationResults.self, from: data!)
                print("TRANSLATION: \(results.data.translation)")
                
                DispatchQueue.main.async {
                    self.translation = results.data.translation
                    completion(results)
                }
            } catch {
                print("RESULTS ERROR 2: \(error)")
            }
        }
        task.resume()
    }
}
