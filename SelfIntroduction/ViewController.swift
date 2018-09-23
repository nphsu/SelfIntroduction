//
//  ViewController.swift
//  SelfIntroduction
//
//  Created by 小池駿平 on 2018/09/22.
//  Copyright © 2018 小池駿平. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
        let configuration = ARImageTrackingConfiguration()
        
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 1
            print("Images...")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        if let imageAnchor = anchor as? ARImageAnchor {
            
            let flushPlaneNode = createFlushPlaneNode(imageAnchor: imageAnchor)
            let clearCoverNode = createClearCoverNode(imageAnchor: imageAnchor)
            let nameTextNode = createNameTextNode(x: CGFloat(flushPlaneNode.position.x), y: CGFloat(flushPlaneNode.position.y), z: CGFloat(flushPlaneNode.position.z))
            let imageProfileNode = createImageProfileNode(x: CGFloat(flushPlaneNode.position.x), y: CGFloat(flushPlaneNode.position.y), z: CGFloat(flushPlaneNode.position.z))
//            let textButtonNode = createTextButton()
     
            // Pockemon
            let pickachuNode = createPickachuNode()
            let venusaurNode = createVenusaurNode()
            let charizardNode = createCharizardNode()
            let blastoiseNode = createBlastoiseNode()
            let laplasNode = createLaprasNode()
            let snorlaxNode = createSnorlaxNode()
            
            node.addChildNode(flushPlaneNode)
            node.addChildNode(clearCoverNode)
            node.addChildNode(nameTextNode)
            node.addChildNode(imageProfileNode)
//            node.addChildNode(textButtonNode)
            
            // Pokemon
            let pokemonArray = [pickachuNode, venusaurNode, charizardNode, blastoiseNode, laplasNode, snorlaxNode]
//            self.lineUpAndShowPokemon(rootNode: node, nodes: pokemonArray)
            
            // Action
            let fadeout = SCNAction.fadeOut(duration: 0.25)
            let fadein = SCNAction.fadeIn(duration: 0.25)
            flushPlaneNode.runAction(
                SCNAction.sequence([
                    fadeout,
                    fadein,
                    fadeout,
                    fadein
                ]),
                completionHandler: {
                    self.fadeOut(node: flushPlaneNode)
                    self.moveRight(node: nameTextNode)
                    self.moveRight(node: imageProfileNode)
                    self.lineUpAndShowPokemon(rootNode: node, nodes: pokemonArray)
            })
            

//            self.moveRight(node: textButtonNode)
//            self.moveUnder(node: snorlaxNode)
        }
        print("recognized!")
        return node
    }
    
    
    func createFlushPlaneNode(imageAnchor: ARImageAnchor) -> SCNNode {
        let flushPlane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        flushPlane.firstMaterial?.diffuse.contents = UIColor(red: 0, green: 0, blue: 1, alpha: 0.9)
        let flushPlaneNode = SCNNode(geometry: flushPlane)
        flushPlaneNode.name = "FlushPlaneNode"
        flushPlaneNode.eulerAngles.x = -.pi / 2
        return flushPlaneNode
    }
    
    func createClearCoverNode(imageAnchor: ARImageAnchor) -> SCNNode {
        let clearCover = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
        clearCover.firstMaterial?.diffuse.contents = UIColor(red: 0, green: 1, blue: 0, alpha: 0.1)
        let clearCoverNode = SCNNode(geometry: clearCover)
        clearCoverNode.eulerAngles.x = -.pi / 2
        clearCoverNode.renderingOrder = 10
        return clearCoverNode
    }
    
    func createNameTextNode(x: CGFloat, y: CGFloat, z: CGFloat) -> SCNNode {
        let textGeo = SCNText(string: "shunp", extrusionDepth: 0.0)
        textGeo.font = UIFont(name: "DamascusMedium", size: 0.3)
        textGeo.firstMaterial?.diffuse.contents = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        let textNode = SCNNode(geometry: textGeo)
        textNode.eulerAngles.x = -.pi / 2
        textNode.position = SCNVector3(x, y-0.05, z+0.03) // z: more large, more down
        textNode.scale = SCNVector3(0.05, 0.05, 0.05)
        textNode.renderingOrder = 20
        return textNode
    }
    
    func createImageProfileNode(x: CGFloat, y: CGFloat, z: CGFloat) -> SCNNode {
        let imageProfile = SCNPlane(width: 0.02, height: 0.02)
        imageProfile.firstMaterial?.diffuse.contents = #imageLiteral(resourceName: "shunp_profile.png")
        let imageProfileNode = SCNNode(geometry: imageProfile)
        imageProfileNode.eulerAngles.x = -.pi / 2
        imageProfileNode.position = SCNVector3(x, y-0.05, z) // y:more small, more depth
        imageProfileNode.renderingOrder = 20
        return imageProfileNode
    }
    
    func createPickachuNode() -> SCNNode {
        guard let pickachuScene = SCNScene(named: "art.scnassets/Pikachu.scn") else { return SCNNode() }
        guard let pickachuNode = pickachuScene.rootNode.childNodes.first else { return SCNNode() }
        pickachuNode.eulerAngles.x = .pi / 2
        pickachuNode.eulerAngles.y = -.pi
        pickachuNode.eulerAngles.z = -.pi / 2
        pickachuNode.renderingOrder = 20
        return pickachuNode
    }
    
    func createVenusaurNode() -> SCNNode {
        guard let venusaurScene = SCNScene(named: "art.scnassets/Venusaur.scn") else { return SCNNode() }
        guard let venusaurNode = venusaurScene.rootNode.childNodes.first else { return SCNNode() }
        venusaurNode.eulerAngles.x = .pi / 2
        venusaurNode.eulerAngles.y = -.pi
        venusaurNode.eulerAngles.z = -.pi / 2
        venusaurNode.renderingOrder = 20
        return venusaurNode
    }
    
    func createCharizardNode() -> SCNNode {
        guard let charizardScene = SCNScene(named: "art.scnassets/Charizard.scn") else { return SCNNode() }
        guard let charizardNode = charizardScene.rootNode.childNodes.first else { return SCNNode() }
        charizardNode.eulerAngles.x = .pi / 2
        charizardNode.eulerAngles.y = -.pi
        charizardNode.eulerAngles.z = -.pi / 2
        charizardNode.renderingOrder = 20
        return charizardNode
    }
    
    func createBlastoiseNode() -> SCNNode {
        guard let blastoiseScene = SCNScene(named: "art.scnassets/Blastoise.scn") else { return SCNNode() }
        guard let blastoiseNode = blastoiseScene.rootNode.childNodes.first else { return SCNNode() }
        blastoiseNode.eulerAngles.x = .pi / 2
        blastoiseNode.eulerAngles.y = -.pi
        blastoiseNode.eulerAngles.z = -.pi / 2
        blastoiseNode.renderingOrder = 20
        return blastoiseNode
    }
    
    func createLaprasNode() -> SCNNode {
        guard let lapLasScene = SCNScene(named: "art.scnassets/Lapras.scn") else { return SCNNode() }
        guard let lapLasNode = lapLasScene.rootNode.childNodes.first else { return SCNNode() }
        lapLasNode.eulerAngles.x = .pi / 2
        lapLasNode.eulerAngles.y = -.pi
        lapLasNode.eulerAngles.z = -.pi / 2
        lapLasNode.renderingOrder = 20
        return lapLasNode
    }
    
    func createSnorlaxNode() -> SCNNode {
        guard let snorlaxScene = SCNScene(named: "art.scnassets/Snorlax.scn") else { return SCNNode() }
        guard let snorlaxNode = snorlaxScene.rootNode.childNodes.first else { return SCNNode() }
        snorlaxNode.eulerAngles.x = .pi / 2
        snorlaxNode.eulerAngles.y = -.pi
        snorlaxNode.eulerAngles.z = -.pi / 2
        snorlaxNode.renderingOrder = 20
        return snorlaxNode
    }
    
    func createTextButton() -> SCNNode {
        let skScene = SKScene(size: CGSize(width: 200, height: 200))
        skScene.backgroundColor = UIColor.clear
        
        let rectangle = SKShapeNode(rect: CGRect(x: 0, y: 0, width: 200, height: 200), cornerRadius: 10)
        rectangle.fillColor = #colorLiteral(red: 0.807843148708344, green: 0.0274509806185961, blue: 0.333333343267441, alpha: 1.0)
        rectangle.strokeColor = #colorLiteral(red: 0.439215689897537, green: 0.0117647061124444, blue: 0.192156866192818, alpha: 1.0)
        rectangle.lineWidth = 5
        rectangle.alpha = 0.4
        let labelNode = SKLabelNode(text: "Hello World")
        labelNode.fontSize = 20
        labelNode.fontName = "San Fransisco"
        labelNode.position = CGPoint(x:100,y:100)
        skScene.addChild(rectangle)
        skScene.addChild(labelNode)
        
        let plane = SCNPlane(width: 20, height: 20)
        let material = SCNMaterial()
        material.isDoubleSided = true
        material.diffuse.contents = skScene
        plane.materials = [material]
        let node = SCNNode(geometry: plane)
        node.eulerAngles.z = -.pi / 2
        node.eulerAngles.y = -.pi / 2
        return node
    }
    
    func moveRight(node: SCNNode) {
        let action = SCNAction.moveBy(x: 0.06, y: 0, z: 0, duration: 1)
        node.runAction(action)
    }
    
    func moveUnder(node: SCNNode) {
        let action = SCNAction.moveBy(x: 0, y: 0, z: 0.05, duration: 1)
        node.runAction(action)
    }
    
    func rotate(node: SCNNode) {
        let rotation = SCNAction.rotateBy(x: 0, y: 0, z: CGFloat(360.degreesToRadians), duration: 15)
        let foreverRotation = SCNAction.repeatForever(rotation)
        node.runAction(foreverRotation)
    }
    
    func fadeOut(node: SCNNode) {
        let action = SCNAction.fadeOut(duration: 0.1)
        node.runAction(action)
    }
    
    func lineUpAndShowPokemon(rootNode: SCNNode, nodes: [SCNNode]) {
        guard var basePosition = nodes.first?.position else { return }
        basePosition.x = basePosition.x - 0.05
        basePosition.y = basePosition.y - 0.05
        for node in nodes {
            node.position = SCNVector3(x: basePosition.x+0.025, y: basePosition.y, z: basePosition.z)
            rootNode.addChildNode(node)
            self.rotate(node: node)
            self.moveUnder(node: node)
            basePosition = node.position
        }
    }
}
extension Int {
    var degreesToRadians: Double {
        return Double(self) * .pi/180
    }
}
