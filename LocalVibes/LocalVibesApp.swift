//
//  LocalVibesApp.swift
//  LocalVibes
//
//  Created by Florian Peters on 11.10.23.
//

import SwiftUI
import Firebase



@main
struct LocalVibesApp: App {
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
