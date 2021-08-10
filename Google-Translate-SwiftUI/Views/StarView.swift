//
//  StarView.swift
//  Google-Translate-SwiftUI
//
//  Created by SCG on 8/8/21.
//

import Foundation
import SwiftUI

struct StarView: View {
    
    @Environment(\.managedObjectContext) private var context
    var savedTranslations: FetchedResults<SavedTranslations>
    
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
     
//MARK: - List of starred (saved) translations
            ScrollView {
                ForEach(savedTranslations, id: \.self) { savedItem in
                    if savedItem.star {
                        HStack {
                            VStack {
                                Text("\(savedItem.input!)")
                                    .bold()
                                    .foregroundColor(.black)
                                    .font(.system(size: 17))
                                    .padding(.leading, 23)
                                Text("\(savedItem.translation!)")
                                    .bold()
                                    .foregroundColor(Color(UIColor.systemGray))
                                    .font(.system(size: 13))
                                    .padding(.leading, 25)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                savedItem.star.toggle()
                                star(savedItem: savedItem, starStatus: savedItem.star)
                                
                            }, label: {
                                Image(systemName: savedItem.star ? "star.fill" : "star")
                                    .font(.system(size: 17))
                                    .foregroundColor(savedItem.star ? .yellow : .black)
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
        }
        .background(Color(UIColor.systemGray6).opacity(20))
    }
    
    func star(savedItem: SavedTranslations, starStatus: Bool) {
        withAnimation {
            print("Starring \(savedItem.input!)")
            
            savedItem.star = starStatus
            
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
