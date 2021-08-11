//
//  MainView.swift
//  Google-Translate-SwiftUI
//
//  Created by SCG on 8/8/21.
//

import Foundation
import SwiftUI

struct MainView: View {
        
    // Core Data instances to pass to StarView
    @FetchRequest(entity: SavedTranslations.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \SavedTranslations.time, ascending: true)])
    var savedTranslations: FetchedResults<SavedTranslations>
    
    // ViewModel instance to pass to HomeView
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        
        TabView {
            HomeView(viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            StarView(savedTranslations: savedTranslations)
                .tabItem {
                    Label("Saved", systemImage: "star.fill")
                }
        }
    }
}
