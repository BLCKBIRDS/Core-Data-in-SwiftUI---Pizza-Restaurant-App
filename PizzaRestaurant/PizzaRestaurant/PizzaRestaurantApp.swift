//
//  PizzaRestaurantApp.swift
//  PizzaRestaurant
//
//  Created by Andreas Schultz on 25.09.20.
//

import SwiftUI

@main
struct PizzaRestaurantApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
