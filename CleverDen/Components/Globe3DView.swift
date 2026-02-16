//
//  Globe3DView.swift
//  CleverDen
//

import SwiftUI
import SceneKit
import CoreLocation

struct Globe3DView: UIViewRepresentable {
    let countryName: String
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.backgroundColor = .clear
        sceneView.allowsCameraControl = false
        sceneView.autoenablesDefaultLighting = false
        sceneView.antialiasingMode = .multisampling4X
        
        let scene = SCNScene()
        sceneView.scene = scene
        
        // Globe sphere
        let sphere = SCNSphere(radius: 1.0)
        sphere.segmentCount = 96
        
        let material = SCNMaterial()
        material.diffuse.contents = GlobeTextureRenderer.renderTexture(highlightCountry: countryName)
        material.diffuse.wrapS = .repeat
        material.diffuse.wrapT = .clamp
        material.lightingModel = .lambert
        material.isDoubleSided = false
        sphere.materials = [material]
        
        let globeNode = SCNNode(geometry: sphere)
        scene.rootNode.addChildNode(globeNode)
        
        // Camera
        let cameraNode = SCNNode()
        let camera = SCNCamera()
        camera.fieldOfView = 35
        camera.zNear = 0.1
        camera.zFar = 100
        cameraNode.camera = camera
        
        // Position camera to look at the target country
        if let country = GeoJSONStore.shared.countries[countryName] {
            let center = country.center
            let (cx, cy, cz) = latLonToXYZ(lat: center.latitude, lon: center.longitude, radius: 3.2)
            cameraNode.position = SCNVector3(cx, cy, cz)
        } else {
            cameraNode.position = SCNVector3(0, 0, 3.2)
        }
        
        let constraint = SCNLookAtConstraint(target: globeNode)
        constraint.isGimbalLockEnabled = true
        cameraNode.constraints = [constraint]
        scene.rootNode.addChildNode(cameraNode)
        
        // Lighting
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        ambientLight.light?.intensity = 600
        ambientLight.light?.color = UIColor.white
        scene.rootNode.addChildNode(ambientLight)
        
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.intensity = 400
        directionalLight.light?.color = UIColor.white
        directionalLight.position = SCNVector3(5, 5, 5)
        directionalLight.look(at: SCNVector3Zero)
        scene.rootNode.addChildNode(directionalLight)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update texture and camera when country changes
        if let globe = uiView.scene?.rootNode.childNodes.first,
           let sphere = globe.geometry as? SCNSphere {
            sphere.materials.first?.diffuse.contents = GlobeTextureRenderer.renderTexture(highlightCountry: countryName)
        }
        
        if let country = GeoJSONStore.shared.countries[countryName],
           let cameraNode = uiView.scene?.rootNode.childNodes.first(where: { $0.camera != nil }) {
            let center = country.center
            let (cx, cy, cz) = latLonToXYZ(lat: center.latitude, lon: center.longitude, radius: 3.2)
            
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.8
            cameraNode.position = SCNVector3(cx, cy, cz)
            SCNTransaction.commit()
        }
    }
    
    /// Convert lat/lon to 3D position on sphere.
    /// SceneKit: Y is up, texture maps with longitude starting at +X going through +Z.
    private func latLonToXYZ(lat: Double, lon: Double, radius: Double) -> (Float, Float, Float) {
        let latRad = lat * .pi / 180.0
        let lonRad = -lon * .pi / 180.0  // negate for SceneKit coordinate system
        
        let x = radius * cos(latRad) * sin(lonRad)
        let y = radius * sin(latRad)
        let z = radius * cos(latRad) * cos(lonRad)
        
        return (Float(x), Float(y), Float(z))
    }
}
