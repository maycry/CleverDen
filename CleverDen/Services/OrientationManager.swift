//
//  OrientationManager.swift
//  CleverDen
//

import SwiftUI

@Observable
class OrientationManager {
    static let shared = OrientationManager()
    
    var isLandscapeLocked: Bool = false
    
    func lockLandscape() {
        isLandscapeLocked = true
        updateOrientation()
    }
    
    func lockPortrait() {
        isLandscapeLocked = false
        updateOrientation()
    }
    
    private func updateOrientation() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        let orientationMask: UIInterfaceOrientationMask = isLandscapeLocked ? .landscape : .portrait
        let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: orientationMask)
        
        windowScene.requestGeometryUpdate(geometryPreferences) { error in
            // Silently handle — orientation change is best-effort
        }
        
        // Also tell UIViewController to re-query
        if #available(iOS 16.0, *) {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
    }
}
