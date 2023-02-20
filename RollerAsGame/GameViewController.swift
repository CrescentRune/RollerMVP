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

    let planeTransparency = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a new scene
        let scene = SCNScene()
        
        
        // Create a floor
        // TODO: implement actual felt texture for floor
        let floor = SCNNode()
        floor.name = "Floor"
        floor.geometry = SCNFloor()
        floor.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        floor.physicsBody?.friction = 0.5
        floor.position = SCNVector3(x: 0, y: 0, z: 0)
        if let material = floor.geometry?.firstMaterial {
            material.diffuse.contents = UIColor.systemMint
        }
        scene.rootNode.addChildNode(floor)
        
        
        // Create a light
        // TODO: get the positioning right on the light
        let lightNode = SCNNode()
        lightNode.name = "Light"
        lightNode.light = SCNLight()
        lightNode.light?.type = .omni
        
        lightNode.light?.intensity = 1500
        lightNode.position = SCNVector3(x: 0, y: 10, z: 0)
        
        lightNode.light?.color = UIColor.white
        scene.rootNode.addChildNode(lightNode)
        
        // Create a dynamic box
        let dynamicNode = SCNNode()
        dynamicNode.name = "Box"
        dynamicNode.geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        dynamicNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        dynamicNode.position = SCNVector3(x: 0, y: 0.1, z: 0)
        if let material = dynamicNode.geometry?.firstMaterial {
            material.diffuse.contents = UIColor.systemTeal
        }
        scene.rootNode.addChildNode(dynamicNode)
        
        
        // Removed because I don't want to mess with custom camera right now
//        let camera = SCNNode()
//        camera.camera = SCNCamera()
//        
//        scene.rootNode.addChildNode(camera)
        
        
        let gravity = SCNVector3(0, -30, 0)
        scene.physicsWorld.gravity = gravity;
        
        // Planar angle for a plane in the YZ space (no X depth)
        let flatX = SCNVector3(0, 0, 0)
        
        // Planar angle for a plane in the XZ space (no Y depth)
//        let flatY = SCNVector3(Float.pi/2, 0, 0)
                               
        // Planar angle for a plane in the XY space (no Z depth)
        let flatZ = SCNVector3(0, Float.pi/2, 0)
        
         
        // Add the +X boundary plane
        let planePosX = SCNNode()
        planePosX.name = "+X boundary"
        planePosX.geometry = SCNPlane(width: 20, height: 20)
        planePosX.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        planePosX.position = SCNVector3(5, 0, 0)
        planePosX.eulerAngles = flatZ
        if let material = planePosX.geometry?.firstMaterial {
            material.transparency = planeTransparency
            material.diffuse.contents = UIColor.yellow
        }
        scene.rootNode.addChildNode(planePosX)
    
        
        // Add the -X boundary plane
        let planeNegX = SCNNode()
        planeNegX.name = "-X boundary"
        planeNegX.geometry = SCNPlane(width: 20, height: 20)
        planeNegX.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        planeNegX.position = SCNVector3(-5, 0, 0)
        planeNegX.eulerAngles = flatZ
        if let material = planeNegX.geometry?.firstMaterial {
            material.transparency = planeTransparency
            material.diffuse.contents = UIColor.green
        }
        scene.rootNode.addChildNode(planeNegX)
        
        // Add the +Z boundary plane
        let planePosZ = SCNNode()
        planePosZ.name = "+Z boundary"
        planePosZ.geometry = SCNPlane(width: 20, height: 20)
        planePosZ.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        planePosZ.position = SCNVector3(0, 0, 5)
        planePosZ.eulerAngles = flatX
        if let material = planePosZ.geometry?.firstMaterial {
            material.transparency = planeTransparency
            material.diffuse.contents = UIColor.blue
        }
        scene.rootNode.addChildNode(planePosZ)
        
        // Add the -Z boundary plane
        let planeNegZ = SCNNode()
        planeNegZ.name = "-Z boundary"
        planeNegZ.geometry = SCNPlane(width: 20, height: 20)
        planeNegZ.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        planeNegZ.position = SCNVector3(0, 0, -5)
        planeNegZ.eulerAngles = flatX
        if let material = planeNegZ.geometry?.firstMaterial {
            material.transparency = planeTransparency
            material.diffuse.contents = UIColor.red
        }
        scene.rootNode.addChildNode(planeNegZ)
        
        
        // Create tge vuew and register the scene we created to it
        let view = SCNView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        view.scene = scene
        view.allowsCameraControl = true
        view.showsStatistics = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        view.addGestureRecognizer(tap)
        
        self.view = view
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
            if let result = hitResults.first(where: {$0.node.name == "Box"}) {
//                print(result.node.parent!.physicsBody!)
//                rollDie(result.node.parent!)
//                rollDie(result.node)
//                let force = SCNVector3(x: 2, y: 0.1, z: 2)
                
                //TODO: This needs to be amended such that x and z exceed a certain threshold together, but can be 0
                result.node.eulerAngles = SCNVector3(x: Float.random(in: 0...(Float.pi/2)), y: Float.random(in: 0...(Float.pi/2)), z: Float.random(in: 0...(Float.pi/2)))
                
                //Experiment with random x and z
                result.node.position = SCNVector3(x: 0, y: 2, z: Float.random(in: -3.5...3.5))
                
                let dirX = Float(Int.random(in: 0...1) == 0 ? -1 : 1)
//                let dirY = Float(Int.random(in: 0...1) == 0 ? -1 : 1)
                let dirZ = Float(Int.random(in: 0...1) == 0 ? -1 : 1)
                
                let force = SCNVector3(x: Float.random(in: 6...12) * dirX, y: Float.random(in: 6...12), z: Float.random(in: 6...12) * dirZ)

                result.node.physicsBody?.applyForce(force, at: SCNVector3(x: 0.05, y: 0.05, z: 0.05), asImpulse: true)
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
