//
//  SKMultilineLabelNode.swift
//  Magnetic
//
//  Created by Lasha Efremidze on 3/31/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import SpriteKit

//open class SKMultilineLabelNode: SKNode {
//    
//    open var text: String? { didSet { update() } }
//    
//    open var fontName: String? { didSet { update() } }
//    open var fontSize: CGFloat = 32 { didSet { update() } }
//    open var fontColor: UIColor? { didSet { update() } }
//    
//    open var verticalAlignmentMode: SKLabelVerticalAlignmentMode = .baseline { didSet { update() } }
//    open var horizontalAlignmentMode: SKLabelHorizontalAlignmentMode = .center { didSet { update() } }
//    
//    open var separator: String? { didSet { update() } }
//    
//    public convenience init(text: String?, separator: String?) {
//        self.init()
//        
//        self.text = text
//        self.separator = separator
//    }
//
//    func update() {
//        self.removeAllChildren()
//        
//        guard let text = text else { return }
//        
//        var sizingLabel: SKLabelNode!
//        
//        var labels = [SKLabelNode]()
//        var index = 0
//        
//        let words = separator.map { text.components(separatedBy: $0) } ?? text.characters.map { String($0) }
//        for word in words {
//            print(word)
//            let label: SKLabelNode = {
//                if labels.count <= index {
//                    let label = makeLabel()
//                    labels.append(label)
//                    self.addChild(label)
//                }
//                return labels[index]
//            }()
//            sizingLabel = label.copy() as! SKLabelNode
//            sizingLabel.append(word)
////            if sizingLabel.frame.width > self.frame.width {
//            if sizingLabel.frame.width > 40 {
//                index += 1
//                print("\n")
//            } else {
//                label.append(word)
//            }
//        }
//        
//        print(labels)
//    }
//    
//    private func makeLabel() -> SKLabelNode {
//        let label = SKLabelNode(fontNamed: fontName)
//        label.fontSize = fontSize
//        label.fontColor = fontColor
//        label.verticalAlignmentMode = verticalAlignmentMode
//        label.horizontalAlignmentMode = horizontalAlignmentMode
//        return label
//    }
//    
//}
//
//private extension SKLabelNode {
//    
//    func append(_ text: String) {
//        var str = (self.text ?? "")
//        if text.characters.count > 1 {
//            str += " "
//        }
//        self.text = str + text
//    }
//    
//}

open class SKMultilineLabelNode: SKNode {
    //props
    var labelWidth:Int {didSet {update()}}
    var labelHeight:Int = 0
    var text:String? {didSet {update()}}
    var fontName:String {didSet {update()}}
    var fontSize:CGFloat {didSet {update()}}
    var pos:CGPoint {didSet {update()}}
    var fontColor:UIColor {didSet {update()}}
    var leading:Int {didSet {update()}}
    var alignment:SKLabelHorizontalAlignmentMode {didSet {update()}}
    var dontUpdate = false
    var shouldShowBorder:Bool = false {didSet {update()}}
    //display objects
    var rect:SKShapeNode?
    var labels:[SKLabelNode] = []
    
    public init(text:String, labelWidth:Int, pos:CGPoint, fontName:String="ChalkboardSE-Regular",fontSize:CGFloat=10,fontColor:UIColor=UIColor.white,leading:Int? = nil, alignment:SKLabelHorizontalAlignmentMode = .center, shouldShowBorder:Bool = false)
    {
        self.text = text
        self.labelWidth = labelWidth
        self.pos = pos
        self.fontName = fontName
        self.fontSize = fontSize
        self.fontColor = fontColor
        self.leading = leading ?? Int(fontSize)
        self.shouldShowBorder = shouldShowBorder
        self.alignment = alignment
        
        super.init()
        
        self.update()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //if you want to change properties without updating the text field,
    //  set dontUpdate to false and call the update method manually.
    func update() {
        guard let text = text else {
            return
        }
        
        if (dontUpdate) {return}
        if (labels.count>0) {
            for label in labels {
                label.removeFromParent()
            }
            labels = []
        }
        let separators = NSCharacterSet.whitespacesAndNewlines
        let words = (text as NSString).components(separatedBy: separators)
        var finalLine = false
        var wordCount = -1
        var lineCount = 0
        while (!finalLine) {
            lineCount+=1
            var lineLength = CGFloat(0)
            var lineString = ""
            var lineStringBeforeAddingWord = ""
            
            // creation of the SKLabelNode itself
            let label = SKLabelNode(fontNamed: fontName)
            // name each label node so you can animate it if u wish
            label.name = "line\(lineCount)"
            label.horizontalAlignmentMode = alignment
            label.fontSize = fontSize
            label.fontColor = fontColor
            
            while lineLength < CGFloat(labelWidth)
            {
                wordCount+=1
                if wordCount > words.count-1
                {
                    //label.text = "\(lineString) \(words[wordCount])"
                    finalLine = true
                    break
                }
                else
                {
                    lineStringBeforeAddingWord = lineString
                    lineString = "\(lineString) \(words[wordCount])"
                    label.text = lineString
                    lineLength = label.frame.width
                }
            }
            if lineLength > 0 {
                wordCount-=1
                if (!finalLine) {
                    lineString = lineStringBeforeAddingWord
                }
                label.text = lineString
                var linePos = pos
                if (alignment == .left) {
                    linePos.x -= CGFloat(labelWidth / 2)
                } else if (alignment == .right) {
                    linePos.x += CGFloat(labelWidth / 2)
                }
                linePos.y += CGFloat(-leading * lineCount)
                label.position = CGPoint(x:linePos.x , y:linePos.y )
                self.addChild(label)
                labels.append(label)
            }
            
        }
        labelHeight = lineCount * leading
        showBorder()
    }
    func showBorder() {
        if (!shouldShowBorder) {return}
        if let rect = self.rect {
            self.removeChildren(in: [rect])
        }
        self.rect = SKShapeNode(rectOf: CGSize(width: labelWidth, height: labelHeight))
        if let rect = self.rect {
            rect.strokeColor = UIColor.white
            rect.lineWidth = 1
            rect.position = CGPoint(x: pos.x, y: pos.y - (CGFloat(labelHeight) / 2.0))
            self.addChild(rect)
        }
        
    }
}
