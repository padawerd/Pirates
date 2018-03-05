//
//  ButtonNode.swift
//  Pong
//
//  Created by david padawer on 3/3/18.
//  Copyright © 2018 DPad Studios. All rights reserved.
//

import Foundation
import SpriteKit

class ButtonNode : SKShapeNode {
    var onClick : (() -> Void)?

    init(text: String) {
        super.init()

        self.path = CGPath(rect: CGRect(x: 0, y: 0, width: 200, height: 100), transform: nil)
        let label = SKLabelNode(fontNamed: "BaskervilleOldFace")
        label.text = text
        label.fontColor = .white
        label.horizontalAlignmentMode = .center
        label.verticalAlignmentMode = .center
        label.position = CGPoint(x: 100, y: 50)
        self.addChild(label)
        self.fillColor = .blue
        self.strokeColor = .blue
        self.isUserInteractionEnabled = true
    }

    override func mouseUp(with event: NSEvent) {
        self.onClick?()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
