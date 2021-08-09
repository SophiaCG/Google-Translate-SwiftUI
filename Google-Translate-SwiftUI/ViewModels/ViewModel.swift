//
//  ViewModel.swift
//  Google-Translate-Clone
//
//  Created by SCG on 5/29/21.
//

import Foundation

class ViewModel: ObservableObject {
    
    @Published var languages = [Language]()
    @Published var translation = String()
    let apiKey = "API-KEY-HERE"
    
    func getLanguages(completion:@escaping (Data) -> ()) {
        
        guard let url = URL(string: "https://google-translate1.p.rapidapi.com/language/translate/v2/languages?target=en&rapidapi-key=\(apiKey)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard data != nil else {
                print("ERROR: \(String(describing: error))")
                return
            }
            
            do {
                let results = try JSONDecoder().decode(Data.self, from: data!)
                print("LANGUAGES: \(results.data.languages[0].name)")
                
                DispatchQueue.main.async {
                    self.languages = results.data.languages
                    completion(results)
                }
                
            } catch {
                print("ERROR: \(error)")
            }

        }
        task.resume()
    }

    func translate(completion:@escaping (TranslationResults) -> ()) {

        guard let url = URL(string: "https://google-translate20.p.rapidapi.com/translate?text=hello&tl=fr&rapidapi-key=\(apiKey)") else {
            print("Invalid URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard data != nil else {
                print("ERROR: \(String(describing: error))")
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
                print("ERROR: \(error)")
            }

        }
        task.resume()
    }
}
