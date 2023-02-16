//
//  GameViewController.swift
//  RollerAsGame
//
//  Created by Hank Krutulis on 2/12/23.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/Main.scn")!
        
        // create and add a camera to the scene
//        let cameraNode = SCNNode()
//        cameraNode.camera = SCNCamera()
//        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
//        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 1.5, y: 3, z: 0)
        scene.rootNode.addChildNode(lightNode)
        
//        let boundaryBox = SCNBox(width: 2, height: 2, length: 0.01, chamferRadius: 0)
//        boundaryBox.firstMaterial?.diffuse.contents = UIColor.clear
//        let boundaryNode = SCNNode(geometry: boundaryBox)
//        boundaryNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: boundaryBox))
//        boundaryNode.position = SCNVector3(x: 0, y: 0, z: 0)
        
        // create and add an ambient light to the scene
//        let ambientLightNode = SCNNode()
//        ambientLightNode.light = SCNLight()
//        ambientLightNode.light!.type = .ambient
//        ambientLightNode.light!.color = UIColor.darkGray
//        scene.rootNode.addChildNode(ambientLightNode)
        
        // retrieve the ship node

//        scene.rootNode.physicsField = SCNPhysicsField.linearGravity();
        
//        let die = scene.rootNode.childNode(withName: "Cube", recursively: true)!.parent!
//        die.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(node: die))
//        die.physicsBody?.isAffectedByGravity = true
        
        
        
        
        
        // animate the 3d object
//        ship.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 2, z: 0, duration: 1)))
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.black
        
        // add a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        scnView.addGestureRecognizer(tapGesture)
        
        let timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 60.0, repeats: true) { _ in
            scene.physicsWorld.updateCollisionPairs()
        }
    }
    
    @objc
    func handleTap(_ gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            print("Hits:")
            hitResults.forEach { result in
                print(result.node.name ?? "Oopsy")
            }
            // retrieved the first clicked object that is a cube
            if let result = hitResults.first(where: {$0.node.name == "Cube"}) {
//                print(result.node.parent!.physicsBody!)
                rollDie(result.node.parent!)
            }
            
            

        }
    }
    
    func rollDie(_ diceNode: SCNNode) {
        if let physicsBody = diceNode.physicsBody {
            print(physicsBody)
            print(physicsBody.type == .dynamic)
            let force = SCNVector3(x: Float.random(in: -2...2), y: Float.random(in: -2...2), z: Float.random(in: -2...2))
            physicsBody.applyForce(force, at: SCNVector3(x: 0.05, y: 0.05, z: 0.05), asImpulse: true)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

}
