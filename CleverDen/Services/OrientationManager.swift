//
//  OrientationManager.swift
//  CleverDen
//

import SwiftUI

@Observable
class OrientationManager {
    static let shared = OrientationManager()
    
    var isLandscapeLocked: Bool = false
    
    func lockLandscape(completion: (() -> Void)? = nil) {
        isLandscapeLocked = true
        updateOrientation(completion: completion)
    }
    
    func lockPortrait(completion: (() -> Void)? = nil) {
        isLandscapeLocked = false
        updateOrientation(completion: completion)
    }
    
    private func updateOrientation(completion: (() -> Void)? = nil) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            completion?()
            return
        }
        
        let orientationMask: UIInterfaceOrientationMask = isLandscapeLocked ? .landscape : .portrait
        let geometryPreferences = UIWindowScene.GeometryPreferences.iOS(interfaceOrientations: orientationMask)
        
        windowScene.requestGeometryUpdate(geometryPreferences) { _ in }
        
        if #available(iOS 16.0, *) {
            UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
        }
        
        // Wait for rotation animation to finish before calling completion
        if let completion {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                completion()
            }
        }
    }
}
