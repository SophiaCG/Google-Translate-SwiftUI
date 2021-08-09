//
//  MainView.swift
//  Google-Translate-SwiftUI
//
//  Created by SCG on 8/8/21.
//

import Foundation
import SwiftUI

struct MainView: View {
    
    var body: some View {
        
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            StarView()
                .tabItem {
                    Label("Saved", systemImage: "star.fill")
                }
        }
    }
}
