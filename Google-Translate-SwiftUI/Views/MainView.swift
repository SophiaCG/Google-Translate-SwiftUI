//
//  MainView.swift
//  Google-Translate-SwiftUI
//
//  Created by SCG on 8/8/21.
//

import Foundation
import SwiftUI

struct MainView: View {
    
    @State var starTapped: Bool = false
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        
        TabView {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            StarView(starTapped: $starTapped)
                .tabItem {
                    Label("Saved", systemImage: "star.fill")
                }
        }
    }
}
