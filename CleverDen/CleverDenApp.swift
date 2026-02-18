//
//  CleverDenApp.swift
//  CleverDen
//
//  Created by Iurii Tanskyi on 1/24/26.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        OrientationManager.shared.isLandscapeLocked ? .landscape : .portrait
    }
}

@main
struct CleverDenApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
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
