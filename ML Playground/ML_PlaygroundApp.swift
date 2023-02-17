//
//  ML_PlaygroundApp.swift
//  ML Playground
//
//  Created by Brandon Knox on 2/16/23.
//

import SwiftUI

@main
struct ML_PlaygroundApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
