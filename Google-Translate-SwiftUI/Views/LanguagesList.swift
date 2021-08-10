//
//  LanguagesList.swift
//  Google-Translate-SwiftUI
//
//  Created by SCG on 8/9/21.
//

import Foundation
import SwiftUI

struct LanguagesList: View {
    
    @State var names: [String] = []
    @State var codes: [String] = []
    @Binding var viewedLanguages: ViewedLanguages
    @Binding var isPresented: Bool

    var body: some View {
        
        VStack {
            ZStack {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.075, alignment: .top)
                    .foregroundColor(Color(UIColor.systemGray6))
                HStack {
                    Text("Translate from")
                        .foregroundColor(.black)
                        .bold()
                        .padding(20)
                        .font(.system(size: 22))
                    Spacer()
                    Button(action: {
                        self.isPresented = false
                    }, label: {
                        Image(systemName: "multiply")
                            .font(.system(size: 24))
                            .foregroundColor(.black)
                            .padding(.all, 15)
                    })
                }
            }

            ScrollView {
                ForEach(names.indices, id: \.self) { index in
                    HStack {
                        Button(action: {
                            print("Translating from: \(names[index])")
                            if viewedLanguages.selection == 1 {
                                viewedLanguages.firstName = names[index]
                                viewedLanguages.firstCode = codes[index]
                                
                            } else if viewedLanguages.selection == 2 {
                                viewedLanguages.secondName = names[index]
                                viewedLanguages.secondCode = codes[index]
                            }
                            self.isPresented = false
                        }, label: {
                            Text(names[index])
                                .bold()
                                .foregroundColor(.black)
                                .padding(.leading, 30)
                            Spacer()
                        })
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.07, alignment: .center)
                        .border(Color.gray, width: 0.23)
                        
                    }
                    
                } .onAppear() {
                    ViewModel().getLanguages { (results) in
                        for result in results.data.languages {
                            names.append(result.name)
                            codes.append(result.language)
                        }
                    }
                }
            }
        }
    }
}
