//
//  Magnetic.swift
//  Magnetic
//
//  Created by Lasha Efremidze on 3/8/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import SpriteKit

public enum MagneticState {
    case normal, moving, editing
}

open class Magnetic: SKScene {
    
    public lazy var magneticField: SKFieldNode = { [unowned self] in
        let field = SKFieldNode.radialGravityField()
        field.region = SKRegion(radius: 2000)
        field.minimumRadius = 2000
        field.strength = 500
        self.addChild(field)
        return field
    }()
    
    open var allowsMultipleSelection: Bool = true
    open var allowsEditing: Bool = false
    
    public internal(set) var state: MagneticState = .normal
    
    open var selectedChildren: [Node] {
        return children.flatMap { $0 as? Node }.filter { $0.selected }
    }
    
    override open func didMove(to view: SKView) {
        super.didMove(to: view)
        
        self.backgroundColor = .white
        self.scaleMode = .aspectFill
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: { () -> CGRect in
            var frame = self.frame
            frame.size.width = CGFloat(magneticField.minimumRadius)
            frame.origin.x -= frame.size.width / 2
            return frame
        }())
        magneticField.position = CGPoint(x: size.width / 2, y: size.height / 2)
    }
    
    override open func addChild(_ node: SKNode) {
        var x = CGFloat.random(0, -node.frame.width) // left
        if children.count % 2 == 0 {
            x = CGFloat.random(frame.width, frame.width + node.frame.width) // right
        }
        let y = CGFloat.random(node.frame.height, frame.height - node.frame.height)
        node.position = CGPoint(x: x, y: y)
        super.addChild(node)
    }
    
//    override open func removeAllChildren() {
//        let currentPhysicsSpeed = physicsWorld.speed
//        physicsWorld.speed = 0
//        let sortedNodes = floatingNodes.sorted { (node: SIFloatingNode, nextNode: SIFloatingNode) -> Bool in
//            let distance = node.position.distance(from: magneticField.position)
//            let nextDistance = nextNode.position.distance(from: magneticField.position)
//            return distance < nextDistance && node.state != .selected
//        }
//        var actions: [SKAction] = []
//        
//        for node in sortedNodes {
//            node.physicsBody = nil
//            let action = actionForFloatingNode(node)
//            actions.append(action)
//        }
//        run(SKAction.sequence(actions)) { [weak self] in
//            self?.physicsWorld.speed = currentPhysicsSpeed
//        }
//        super.removeAllChildren()
//    }
    
    override open func atPoint(_ p: CGPoint) -> SKNode {
        var node = super.atPoint(p)
        while true {
            if node is Node {
                return node
            } else if let parent = node.parent {
                node = parent
            } else {
                break
            }
        }
        return node
    }
    
}

extension Magnetic {
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if state == .editing { return }
        
        if let touch = touches.first {
            let location = touch.location(in: self)
            let previous = touch.previousLocation(in: self)
            
            if location.length() == 0 { return }
            
            state = .moving
            
            let x = location.x - previous.x
            let y = location.y - previous.y
            
            for node in children {
                let distance = node.position.distance(from: location)
                let acceleration: CGFloat = 3 * pow(distance, 1/2)
                let direction = CGVector(dx: x * acceleration, dy: y * acceleration)
                node.physicsBody?.applyForce(direction)
            }
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if state != .moving, let point = touches.first?.location(in: self), let node = atPoint(point) as? Node {
            if node.selected {
                node.selected = false
            } else {
                if !allowsMultipleSelection {
                    selectedChildren.first?.selected = false
                }
                node.selected = true
            }
        }
        state = .normal
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        state = .normal
    }
    
}
