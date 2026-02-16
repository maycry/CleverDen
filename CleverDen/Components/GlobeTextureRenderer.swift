//
//  GlobeTextureRenderer.swift
//  CleverDen
//

import UIKit

class GlobeTextureRenderer {
    
    static let shared = GlobeTextureRenderer()
    
    static let textureWidth = 2048
    static let textureHeight = 1024
    
    private var baseTexture: UIImage?
    private var cache: [String: UIImage] = [:]
    
    private init() {}
    
    /// Call from background thread on app launch to pre-render the base texture.
    func warmUp() {
        _ = getBaseTexture()
    }
    
    /// Get or render the base texture (all countries gray, no highlight).
    private func getBaseTexture() -> UIImage {
        if let base = baseTexture { return base }
        
        let w = CGFloat(Self.textureWidth)
        let h = CGFloat(Self.textureHeight)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: w, height: h))
        
        let image = renderer.image { ctx in
            let gc = ctx.cgContext
            
            // Water
            UIColor(red: 0.85, green: 0.90, blue: 0.95, alpha: 1.0).setFill()
            gc.fill(CGRect(x: 0, y: 0, width: w, height: h))
            
            // All countries in gray
            UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.0).setFill()
            UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1.0).setStroke()
            
            for (_, country) in GeoJSONStore.shared.countries {
                for ring in country.rings {
                    guard ring.count > 2 else { continue }
                    let path = Self.makePath(ring: ring, width: w, height: h)
                    path.fill()
                    path.lineWidth = 0.5
                    path.stroke()
                }
            }
        }
        
        baseTexture = image
        return image
    }
    
    /// Render texture with a highlighted country. Uses cached base + overlay.
    func renderTexture(highlightCountry: String?) -> UIImage {
        guard let name = highlightCountry else { return getBaseTexture() }
        if let cached = cache[name] { return cached }
        
        let base = getBaseTexture()
        let w = CGFloat(Self.textureWidth)
        let h = CGFloat(Self.textureHeight)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: w, height: h))
        
        let image = renderer.image { ctx in
            // Draw base
            base.draw(at: .zero)
            
            // Draw highlight on top
            guard let country = GeoJSONStore.shared.countries[name] else { return }
            
            UIColor(red: 1.0, green: 0.35, blue: 0.21, alpha: 0.5).setFill()
            UIColor(red: 1.0, green: 0.35, blue: 0.21, alpha: 1.0).setStroke()
            
            for ring in country.rings {
                guard ring.count > 2 else { continue }
                let path = Self.makePath(ring: ring, width: w, height: h)
                path.fill()
                path.lineWidth = 3.0
                path.stroke()
            }
        }
        
        cache[name] = image
        return image
    }
    
    private static func makePath(ring: [(Double, Double)], width: CGFloat, height: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        for (i, point) in ring.enumerated() {
            let x = CGFloat((point.0 + 180.0) / 360.0) * width
            let y = CGFloat((90.0 - point.1) / 180.0) * height
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.close()
        return path
    }
}
