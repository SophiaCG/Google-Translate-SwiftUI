//
//  StarView.swift
//  Google-Translate-SwiftUI
//
//  Created by SCG on 8/8/21.
//

import Foundation
import SwiftUI

struct StarView: View {
    var body: some View {
        
        VStack {

//MARK: - Header
            ZStack {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.075, alignment: .top)
                    .foregroundColor(Color(UIColor.systemGray5))
                HStack {
                    Text("Saved")
                        .foregroundColor(.black)
                        .bold()
                        .padding(20)
                    Spacer()
                }
            }
            Spacer()
        }
    }
}
