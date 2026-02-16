//
//  GlobeTextureRenderer.swift
//  CleverDen
//

import UIKit

struct GlobeTextureRenderer {
    
    static let textureWidth = 2048
    static let textureHeight = 1024
    
    /// Render an equirectangular texture with all countries in gray and the highlighted country in orange.
    static func renderTexture(highlightCountry: String?) -> UIImage {
        let w = CGFloat(textureWidth)
        let h = CGFloat(textureHeight)
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: w, height: h))
        
        return renderer.image { ctx in
            let gc = ctx.cgContext
            
            // Water background — light blue-gray
            UIColor(red: 0.85, green: 0.90, blue: 0.95, alpha: 1.0).setFill()
            gc.fill(CGRect(x: 0, y: 0, width: w, height: h))
            
            let store = GeoJSONStore.shared
            
            // Draw all countries
            for (name, country) in store.countries {
                let isHighlighted = (name == highlightCountry)
                
                if isHighlighted {
                    // Orange fill
                    UIColor(red: 1.0, green: 0.35, blue: 0.21, alpha: 0.4).setFill()
                    UIColor(red: 1.0, green: 0.35, blue: 0.21, alpha: 1.0).setStroke()
                } else {
                    // Gray land
                    UIColor(red: 0.78, green: 0.78, blue: 0.78, alpha: 1.0).setFill()
                    UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1.0).setStroke()
                }
                
                for ring in country.rings {
                    guard ring.count > 2 else { continue }
                    
                    let path = UIBezierPath()
                    for (i, point) in ring.enumerated() {
                        let x = lonToX(point.0, width: w)
                        let y = latToY(point.1, height: h)
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                    path.close()
                    path.fill()
                    path.lineWidth = isHighlighted ? 3.0 : 0.5
                    path.stroke()
                }
            }
            
            // Redraw highlighted country on top so it's not covered
            if let highlightName = highlightCountry, let country = store.countries[highlightName] {
                UIColor(red: 1.0, green: 0.35, blue: 0.21, alpha: 0.5).setFill()
                UIColor(red: 1.0, green: 0.35, blue: 0.21, alpha: 1.0).setStroke()
                
                for ring in country.rings {
                    guard ring.count > 2 else { continue }
                    let path = UIBezierPath()
                    for (i, point) in ring.enumerated() {
                        let x = lonToX(point.0, width: w)
                        let y = latToY(point.1, height: h)
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                    path.close()
                    path.fill()
                    path.lineWidth = 3.0
                    path.stroke()
                }
            }
        }
    }
    
    // Equirectangular projection helpers
    private static func lonToX(_ lon: Double, width: CGFloat) -> CGFloat {
        return CGFloat((lon + 180.0) / 360.0) * width
    }
    
    private static func latToY(_ lat: Double, height: CGFloat) -> CGFloat {
        return CGFloat((90.0 - lat) / 180.0) * height
    }
}
