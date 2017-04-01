//
//  SKMultilineLabelNode.swift
//  Magnetic
//
//  Created by Lasha Efremidze on 3/31/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import SpriteKit

open class SKMultilineLabelNode: SKNode {
    
    open var text: String? { didSet { update() } }
    
    open var fontName: String? { didSet { update() } }
    open var fontSize: CGFloat = 32 { didSet { update() } }
    open var fontColor: UIColor? { didSet { update() } }
    
    open var verticalAlignmentMode: SKLabelVerticalAlignmentMode = .baseline { didSet { update() } }
    open var horizontalAlignmentMode: SKLabelHorizontalAlignmentMode = .center { didSet { update() } }
    
    open var separator: String? { didSet { update() } }
    
    private var labels: [SKLabelNode] {
        return children as? [SKLabelNode] ?? [SKLabelNode]()
    }
    
    public convenience init(text: String?, separator: String?) {
        self.init()
        
        self.text = text
        self.separator = separator
    }
    
    func update() {
        self.removeAllChildren()
        
        guard let text = text else { return }
        
        var sizingLabel: SKLabelNode!
        
        if let separator = separator {
            
        }
        let words = text.components(separatedBy: separator)
        print(words)
        for word in words {
            let label = labels.last ?? makeLabel()
            sizingLabel = label.copy() as! SKLabelNode
            sizingLabel.append(word)
            if sizingLabel.frame.width > self.frame.width {
                let index = self.children.count
                label.position = CGPoint(x: 0, y: (CGFloat(index) * -fontSize))
                self.addChild(label)
            } else {
                label.append(word)
            }
        }
    }
    
    private func makeLabel() -> SKLabelNode {
        let label = SKLabelNode(fontNamed: fontName)
        label.fontSize = fontSize
        label.fontColor = fontColor
        label.verticalAlignmentMode = verticalAlignmentMode
        label.horizontalAlignmentMode = horizontalAlignmentMode
        return label
    }
    
}

private extension SKLabelNode {
    
    func append(_ text: String) {
        self.text = (self.text != nil ? " " : "") + text
    }
    
}
