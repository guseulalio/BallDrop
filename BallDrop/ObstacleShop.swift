//
//  ObstacleShop.swift
//  Badoque
//
//  Created by Gustavo E M Cabral on 29/12/19.
//  Copyright © 2019 Gustavo Eulalio. All rights reserved.
//

import Foundation
import SpriteKit

class ObstacleShop
{
	static func getObstacle(datasource: ObstacleDataSource) -> ObstacleShop
	{
		return ObstacleShop()
	}
	
	func getObstacle(forLevel: Int) -> Obstacle
	{
		return PiscesObstacle(withSize: CGSize(width: 50, height: 50))
	}
}

protocol ObstacleDataSource
{
	func picture(_ sender: Obstacle, forType type: Int) -> UIImage?
	func spriteNode(_ sender: Obstacle, forType type: Int) -> SKSpriteNode?
	func innerPictureScale(_ sender: Obstacle, forType type: Int) -> CGFloat
	func color(_ sender: Obstacle, forType type: Int) -> UIColor
	func maxHits(_ sender: Obstacle, forType type: Int) -> Int
	func reactionToCollision(_ sender: Obstacle, forType type: Int) -> () -> Void
	func reactionToDestruction(_ sender: Obstacle, forType type: Int) -> () -> Void
}

extension ObstacleDataSource
{
	func picture(_ sender: Obstacle, forType type: Int) -> UIImage?
	{
		UIImage(named: "plain-circle")
	}
	
	func spriteNode(_ sender: Obstacle, forType type: Int) -> SKSpriteNode?
	{
		nil
	}
	
	func innerPictureScale(_ sender: Obstacle, forType type: Int) -> CGFloat
	{
		1.0
	}
	
	func color(_ sender: Obstacle, forType type: Int) -> UIColor
	{
		.white
	}
	
	func maxHits(_ sender: Obstacle, forType type: Int) -> Int
	{
		1
	}
	
	func reactionToCollision(_ sender: Obstacle, forType type: Int) -> () -> Void
	{
		{
		}

	}
	
	func reactionToDestruction(_ sender: Obstacle, forType type: Int) -> () -> Void
	{
		{
		}
	}
}


class SillyObstacleDataSource: ObstacleDataSource
{
	let typeColors = [#colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1), #colorLiteral(red: 0, green: 0.9914394021, blue: 1, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1), #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)]
	
	func picture(_ sender: Obstacle, forType type: Int) -> UIImage?
	{
		if type == 3 {
			return UIImage(named: "circling-fish")
		}
		return nil
	}
	
	func spriteNode(_ sender: Obstacle, forType type: Int) -> SKSpriteNode?
	{
		switch type {
		case 1: return SKSpriteNode(imageNamed: "volleyball-ball")
		case 2: return SKSpriteNode(imageNamed: "circle")
		case 4: return SKSpriteNode(imageNamed: "gear")
		case 5: return SKSpriteNode(imageNamed: "cycle")
		case 6: return SKSpriteNode(imageNamed: "stone-sphere")
		default: return nil
		}
	}
	
	func innerPictureScale(_ sender: Obstacle, forType type: Int) -> CGFloat
	{
		0.7
	}
	
	func color(_ sender: Obstacle, forType type: Int) -> UIColor
	{
		typeColors[type]
	}
	
	func maxHits(_ sender: Obstacle, forType type: Int) -> Int
	{
		type
	}
	
	func reactionToCollision(_ sender: Obstacle, forType type: Int) -> () -> Void
	{
		{
			if sender.collidee?.name?.hasPrefix("projectile") ?? false
			{
				let spin = SKAction.rotate(byAngle: .pi, duration: 0.5)
				sender.run(spin)
				
				if let fireParticles = SKEmitterNode(fileNamed: "ObstacleCollision")
				{
					if let contact = sender.contact
					{
						fireParticles.position = contact.contactPoint
						fireParticles.zPosition = sender.zPosition - 0.1
						sender.parent!.addChild(fireParticles)
					}
				}
			}
		}
	}
	
	func reactionToDestruction(_ sender: Obstacle, forType type: Int) -> () -> Void
	{
		{
			if let fireParticles = SKEmitterNode(fileNamed: "BallVanishing")
			{
				fireParticles.position = sender.position
				sender.parent!.addChild(fireParticles)
			}
		}
	}
}
