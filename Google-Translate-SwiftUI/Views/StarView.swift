//
//  StarView.swift
//  Google-Translate-SwiftUI
//
//  Created by SCG on 8/8/21.
//

import Foundation
import SwiftUI

struct StarView: View {
    
    @Binding var starTapped: Bool
    var mockData: [String: String] = ["Hello":"Bonjour", "I don't understand":"Je ne comprends pas", "No":"Non"]
    
    var body: some View {
        
        VStack {

//MARK: - Header
            ZStack {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.075, alignment: .top)
                    .foregroundColor(Color(UIColor.systemGray6))
                    .border(Color.gray, width: 0.3)

                HStack {
                    Text("Saved")
                        .foregroundColor(.black)
                        .bold()
                        .padding(20)
                        .font(.system(size: 22))
                    Spacer()
                }
            }
            
            let keys = mockData.map{$0.key}
            let values = mockData.map{$0.value}

            ScrollView {
                ForEach(keys.indices, id: \.self) { index in
                    HStack {
                        VStack {
                            Text(keys[index])
                                .bold()
                                .foregroundColor(.black)
                                .font(.system(size: 17))
                                .padding(.leading, 23)
                            Text(values[index])
                                .bold()
                                .foregroundColor(Color(UIColor.systemGray))
                                .font(.system(size: 13))
                                .padding(.leading, 25)
                        }
                        
                        Spacer()

                        Button(action: {
                            print("Translation Starred")
                            starTapped.toggle()
                        }, label: {
                            Image(systemName: starTapped ? "star.fill" : "star")
                                .font(.system(size: 17))
                                .foregroundColor(starTapped ? .yellow : .black)
                                .padding(.trailing, 15)
                        })
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.08, alignment: .center)
                    .background(Color.white)
                    .border(Color.gray, width: 0.3)
                    .padding(3)
                    .shadow(radius: 0.05)

                }
            }
        }
        .background(Color(UIColor.systemGray6).opacity(20))
    }
}
