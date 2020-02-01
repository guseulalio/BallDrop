//
//  LivesCounter.swift
//  Badoque
//
//  Created by Gustavo E M Cabral on 27/12/19.
//  Copyright © 2019 Gustavo Eulalio. All rights reserved.
//

import Foundation
import SpriteKit

class LivesCounter: SKSpriteNode
{
	var lives = 5 {
		didSet {
			label.text = "\(lives)"
		}
	}
	let label = SKLabelNode(text: "5")
	
	init()
	{
		super.init(texture: SKTexture(imageNamed: "heart"), color: .red, size: CGSize(width: 50, height: 50))
		self.addChild(label)
		label.position = CGPoint(x: 0, y: -7)
		label.zPosition = 1
		label.color = .black
		label.colorBlendFactor = 1.0
		label.fontName = "AvenirNext-Heavy"
		label.fontSize = 25
		
		self.color = .red
		self.colorBlendFactor = 1.0
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
