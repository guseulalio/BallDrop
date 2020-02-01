//
//  Obstacles.swift
//  Badoque
//
//  Created by Gustavo E M Cabral on 25/12/19.
//  Copyright © 2019 Gustavo Eulalio. All rights reserved.
//

import Foundation
import SpriteKit

class Obstacle: Collidable
{
	let stageColors = [#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)]
	var innerSprite: SKSpriteNode?
	
	var maxHits  = 1 {
		didSet {
			hitsLeft = maxHits - 1
		}
	}
	var hitsLeft = 0 {
		didSet {
			if hitsLeft >= 0{
				color = stageColors[hitsLeft]
				colorBlendFactor = 0.5
				if let innerSprite = innerSprite {
					innerSprite.color = stageColors[hitsLeft]
					innerSprite.colorBlendFactor = 0.5
				}
			}
		}
	}
	
	convenience init(withSize size: CGSize)
	{
		self.init(withImageNamed: "circle", size: size)
	}
	
	init(withImageNamed imageName: String, size: CGSize)
	{
		super.init(texture: SKTexture(image: UIImage(named: imageName)!), color: .white, size: size)
		
		physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2.0)
		physicsBody!.contactTestBitMask = 0xFFFFFFFF
		physicsBody!.restitution = 0.6
		physicsBody!.isDynamic = false
	}
	
	init(withCircleAroundImageNamed imageName: String, size: CGSize)
	{
		super.init(texture: SKTexture(image: UIImage(named: "circle")!), color: .white, size: size)

		innerSprite = SKSpriteNode(imageNamed: imageName)
		innerSprite!.position = CGPoint(x: 0, y: 0)
		innerSprite!.size = size * 0.7
		innerSprite!.name = "innerImmage"
		addChild(innerSprite!)
		
		physicsBody = SKPhysicsBody(circleOfRadius: size.width / 2.0)
		physicsBody!.contactTestBitMask = 0xFFFFFFFF
		physicsBody!.restitution = 0.6
		physicsBody!.isDynamic = false
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
	}
	
	func performCollisionEffect(with collidee: SKNode, on contact: SKPhysicsContact? = nil) {
		print("[Obstacle] performCollisionEffect")
	}
	
	override func reactToCollision()
	{
		if hitsLeft == 0 {
			initiateSelfDestruction()
		} else {
			guard let collidee = collidee else { return }
			performCollisionEffect(with: collidee, on: contact)
			hitsLeft -= 1
			
			super.reactToCollision()
		}
	}
	
	
	@objc override func initiateSelfDestruction()
	{
		self.removeFromParent()
	}
}


class PiscesObstacle: Obstacle
{
	init(withSize size: CGSize)
	{
		super.init(withCircleAroundImageNamed: "circling-fish", size: size)
		maxHits = 3
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func performCollisionEffect(with collidee: SKNode, on contact: SKPhysicsContact? = nil) {
		if collidee.name?.hasPrefix("projectile") ?? false
		{
			for  child in self.children {
				if child.name == "innerImmage" {
					let shrink = SKAction.scale(by: 0.8, duration: 0.5)
					child.run(shrink)
				}
			}
			let spin = SKAction.rotate(byAngle: .pi, duration: 0.5)
			run(spin)
			
			if let fireParticles = SKEmitterNode(fileNamed: "ObstacleCollision")
			{
				if let contact = contact {
					fireParticles.position = contact.contactPoint
					fireParticles.zPosition = collidee.zPosition - 0.1
					parent!.addChild(fireParticles)
				}
			}
		}
	}
}

class GearObstacle: Obstacle {
	init(withSize size: CGSize)
	{
		super.init(withImageNamed: "gear", size: size)
		maxHits = 2
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func performCollisionEffect(with collidee: SKNode, on contact: SKPhysicsContact? = nil) {
		if collidee.name?.hasPrefix("projectile") ?? false
		{
			for  child in self.children {
				if child.name == "innerImmage" {
					let shrink = SKAction.scale(by: 0.8, duration: 0.5)
					child.run(shrink)
				}
			}
			let spin = SKAction.rotate(byAngle: .pi, duration: 0.5)
			run(spin)
			
			if let fireParticles = SKEmitterNode(fileNamed: "ObstacleCollision")
			{
				if let contact = contact {
					fireParticles.position = contact.contactPoint
					fireParticles.zPosition = collidee.zPosition - 0.1
					parent!.addChild(fireParticles)
				}
			}
		}
	}
}

class CycleObstacle: Obstacle {
	init(withSize size: CGSize)
	{
		super.init(withImageNamed: "cycle", size: size)
		maxHits = 4
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func performCollisionEffect(with collidee: SKNode, on contact: SKPhysicsContact? = nil) {
		if collidee.name?.hasPrefix("projectile") ?? false
		{
			let spin = SKAction.rotate(byAngle: .pi, duration: 0.5)
			run(spin)
			
			if let fireParticles = SKEmitterNode(fileNamed: "ObstacleCollision")
			{
				if let contact = contact {
					fireParticles.position = contact.contactPoint
					fireParticles.zPosition = collidee.zPosition - 0.1
					parent!.addChild(fireParticles)
				}
			}
		}
	}
}

class StoneSphereObstacle: Obstacle {
	init(withSize size: CGSize)
	{
		super.init(withImageNamed: "stone-sphere", size: size)
		maxHits = 5
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func performCollisionEffect(with collidee: SKNode, on contact: SKPhysicsContact? = nil) {
		if collidee.name?.hasPrefix("projectile") ?? false
		{
			let spin = SKAction.rotate(byAngle: .pi, duration: 0.5)
			run(spin)
			
			if let fireParticles = SKEmitterNode(fileNamed: "ObstacleCollision")
			{
				if let contact = contact {
					fireParticles.position = contact.contactPoint
					fireParticles.zPosition = collidee.zPosition - 0.1
					parent!.addChild(fireParticles)
				}
			}
		}
	}
}


class VolleyballBallObstacle: Obstacle {
	init(withSize size: CGSize)
	{
		super.init(withImageNamed: "volleyball-ball", size: size)
		maxHits = 6
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		fatalError("init(coder:) has not been implemented")
	}
	
	override func performCollisionEffect(with collidee: SKNode, on contact: SKPhysicsContact? = nil) {
		if collidee.name?.hasPrefix("projectile") ?? false
		{
			let spin = SKAction.rotate(byAngle: .pi, duration: 0.5)
			run(spin)
			
			if let fireParticles = SKEmitterNode(fileNamed: "ObstacleCollision")
			{
				if let contact = contact {
					fireParticles.position = contact.contactPoint
					fireParticles.zPosition = collidee.zPosition - 0.1
					parent!.addChild(fireParticles)
				}
			}
		}
	}
	
	override func initiateSelfDestruction() {
		//		if let fireParticles = SKEmitterNode(fileNamed: "orangeExplosion")
		//		{
		//			fireParticles.position = self.position
		//			fireParticles.zPosition = self.zPosition - 0.1
		//			parent!.addChild(fireParticles)
		//		}
		//		if let fireParticles = SKEmitterNode(fileNamed: "orangeSliceExplosion")
		//		{
		//			fireParticles.position = self.position
		//			fireParticles.zPosition = self.zPosition - 0.1
		//			parent!.addChild(fireParticles)
		//		}
		super.initiateSelfDestruction()
	}
}
