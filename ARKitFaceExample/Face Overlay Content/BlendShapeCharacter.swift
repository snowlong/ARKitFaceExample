/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A simple cartoon character animated using ARKit blend shapes.
*/

import Foundation
import SceneKit
import ARKit

/// - Tag: BlendShapeCharacter
class BlendShapeCharacter: NSObject, VirtualContentController {
    
    var contentNode: SCNNode?
    
    private var originalJawY: Float = 0
    
    private lazy var jawNode = contentNode!.childNode(withName: "jaw", recursively: true)!
    private lazy var eyeLeftNode = contentNode!.childNode(withName: "eyeLeft", recursively: true)!
    private lazy var eyeRightNode = contentNode!.childNode(withName: "eyeRight", recursively: true)!
    
//    private lazy var pm = contentNode!.childNode(withName: "_01_pm0039_00", recursively: true)!

    
    private lazy var jawHeight: Float = {
        let (min, max) = jawNode.boundingBox
        print(min, max)
        return max.y - min.y
//        return 10
    }()

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }
        contentNode = SCNReferenceNode(named: "faceOver")
        originalJawY = jawNode.position.y

        return contentNode
    }
    
    /// - Tag: BlendShapeAnimation
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor
            else { return }
        
        let blendShapes = faceAnchor.blendShapes
        guard let eyeBlinkLeft = blendShapes[.eyeBlinkLeft] as? Float,
            let eyeBlinkRight = blendShapes[.eyeBlinkRight] as? Float,
            let jawOpen = blendShapes[.jawOpen] as? Float
            else { return }
        eyeLeftNode.scale.z = 1 - eyeBlinkLeft - 10
        eyeRightNode.scale.z = 1 - eyeBlinkRight - 10
        jawNode.position.y = originalJawY - jawHeight * jawOpen - 40
        
    }
}
