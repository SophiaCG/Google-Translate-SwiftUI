//
//  ViewModel.swift
//  Google-Translate-Clone
//
//  Created by SCG on 5/29/21.
//

import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    
    @Published var languages = [Language]()

    @Published var input: String = "How are you?"
    @Published var sourceLang: String = "en"
    @Published var targetLang: String = "fr"
    @Published var translation: String = ""
        
    let apiKey = "API-KEY-HERE"
    
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
                print("LANGUAGES: \(results.data.languages[0].name)")
                
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

    func translate(for input: String, for sourceLang: String, for targetLang: String, completion:@escaping (TranslationResults) -> ()) {

        let newInput = input.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        print("\(input) -> \(newInput!)")
        print("Translating from \(sourceLang) to \(targetLang)")
        guard let url = URL(string: "https://google-translate20.p.rapidapi.com/translate?text=\(newInput!)&sl=\(sourceLang)&tl=\(targetLang)&rapidapi-key=\(apiKey)") else {
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
