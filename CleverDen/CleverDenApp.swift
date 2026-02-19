//
//  CleverDenApp.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/24/26.
//

import SwiftUI

@main
struct CleverDenApp: App {
    
    init() {
        // Pre-warm globe data on background thread
        DispatchQueue.global(qos: .utility).async {
            _ = GeoJSONStore.shared
            GlobeTextureRenderer.shared.warmUp()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                CoursesListView()
            }
        }
    }
}
