//
//  ViewModel.swift
//  Google-Translate-Clone
//
//  Created by SCG on 5/29/21.
//

import Foundation

class apiCall: ObservableObject {
    
    @Published var languages = [Language]()
    let apiKey = "API-KEY-HERE"
    
    func getResults(completion:@escaping (Data) -> ()) {
        
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
                print("RESULTS: \(results.data.languages[0].name)")
                
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
}
