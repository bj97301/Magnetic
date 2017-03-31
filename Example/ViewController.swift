//
//  ViewController.swift
//  Example
//
//  Created by Lasha Efremidze on 3/8/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import SpriteKit
import Magnetic

class ViewController: UIViewController {
    
    @IBOutlet weak var magneticView: MagneticView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0..<20 {
            add(nil)
        }
    }
    
    @IBAction func add(_ sender: UIControl?) {
        let name = UIImage.names.randomItem()
        let color = UIColor.colors.randomItem()
        let node = Node(title: name.capitalized, image: UIImage(named: name), color: color, radius: 40)
        magneticView.magnetic.addChild(node)
    }
    
    @IBAction func reset(_ sender: UIControl?) {
        
    }
    
}
