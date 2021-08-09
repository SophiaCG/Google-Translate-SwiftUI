//
//  Google_Translate_SwiftUIApp.swift
//  Google-Translate-SwiftUI
//
//  Created by SCG on 8/8/21.
//

import SwiftUI

@main
struct Google_Translate_SwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
