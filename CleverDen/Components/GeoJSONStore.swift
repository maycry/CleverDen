//
//  GeoJSONStore.swift
//  CleverDen
//

import Foundation
import CoreLocation

struct CountryGeometry {
    let name: String
    let rings: [[(Double, Double)]] // (lon, lat) pairs
    
    var center: CLLocationCoordinate2D {
        var latSum = 0.0, lonSum = 0.0, count = 0.0
        for ring in rings {
            for (lon, lat) in ring {
                lonSum += lon
                latSum += lat
                count += 1
            }
        }
        guard count > 0 else { return CLLocationCoordinate2D() }
        return CLLocationCoordinate2D(latitude: latSum / count, longitude: lonSum / count)
    }
}

class GeoJSONStore {
    static let shared = GeoJSONStore()
    
    private(set) var countries: [String: CountryGeometry] = [:]
    
    private init() {
        load()
    }
    
    private func load() {
        guard let url = Bundle.main.url(forResource: "countries", withExtension: "geojson"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let features = json["features"] as? [[String: Any]] else { return }
        
        for feature in features {
            guard let props = feature["properties"] as? [String: Any],
                  let name = props["name"] as? String,
                  let geometry = feature["geometry"] as? [String: Any],
                  let type = geometry["type"] as? String,
                  let coordinates = geometry["coordinates"] as? [Any] else { continue }
            
            var rings: [[(Double, Double)]] = []
            
            if type == "Polygon", let polys = coordinates as? [[[Double]]] {
                for ring in polys {
                    rings.append(ring.map { ($0[0], $0[1]) })
                }
            } else if type == "MultiPolygon", let multi = coordinates as? [[[[Double]]]] {
                for polygon in multi {
                    for ring in polygon {
                        rings.append(ring.map { ($0[0], $0[1]) })
                    }
                }
            }
            
            countries[name] = CountryGeometry(name: name, rings: rings)
        }
    }
}
