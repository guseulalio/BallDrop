//
//  GameObjects.swift
//  Badoque
//
//  Created by Gustavo E M Cabral on 25/12/19.
//  Copyright © 2019 Gustavo Eulalio. All rights reserved.
//

import Foundation
import SpriteKit


class Collidable: SKSpriteNode
{
	static let collisionSound = SKAction.playSoundFileNamed("Introspectral - Percussive Elements-04.wav", waitForCompletion: true)
	private var collidableDelegate: CollidableDelegate
	
	var collidee: SKNode?
	var contact: SKPhysicsContact?
	private var reactionOngoing = false
	var reactingToCollision: Bool {
		get {
			return reactionOngoing
		}
		set {
			if newValue {
				collidableDelegate.willCollide(sender: self)
				reactionOngoing = true
				reactToCollision()
				collidableDelegate.didCollide(sender: self)
				reactionOngoing = false
			}
		}
	}
	
	private var destructionOngoing = (ongoing: false, alreadyHappened: false)
	var destructionInitiated: Bool {
		get {
			return destructionOngoing.ongoing
		}
		set {
			if !destructionOngoing.alreadyHappened {
				if newValue {
					collidableDelegate.willInitiateSelfDestruction(sender: self)
					destructionOngoing = (true, false)
					initiateSelfDestruction()
					collidableDelegate.didSelfDestruct(sender: self)
					destructionOngoing = (false, true)
				}
			} else {
				//destructionOngoing = (false, true)
				print("Collidable object cannot be destructed twice.")
			}
		}
	}
	
	// INITIALIZERS
	init(texture: SKTexture, color: UIColor, size: CGSize) {
		class DummyDelegate:CollidableDelegate {}
		self.collidableDelegate = DummyDelegate()
		super.init(texture: texture, color: color, size: size)
		
		let node = SKNode()
		self.run(
			SKAction.sequence(
				[SKAction.run(
					{
						let node = SKNode()
						node.isPaused=true
						node.run(Collidable.collisionSound)
						
				}),
				 SKAction.run(
					{
						node.removeFromParent()
				})]
		))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// METHODS
	func setDelegate(_ delegate: CollidableDelegate)
	{
		self.collidableDelegate = delegate
	}
	
	func setupCollision(with collidee: SKNode, on contact: SKPhysicsContact? = nil)
	{
		self.collidee = collidee
		self.contact = contact
	}
	
	func reactToCollision()
	{
	}

	@objc func initiateSelfDestruction()
	{
		self.removeFromParent()
	}
}


class Projectile: Collidable
{
	init(withSize size: CGSize)
	{
		super.init(texture: SKTexture(image: UIImage(named: "yin-yang")!), color: .white, size: size)
		let waitAWhile = SKAction.wait(forDuration: 5)
		self.run(waitAWhile) { [weak self] in
			self?.destructionInitiated = true
		}
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
	}
	
	override func reactToCollision()
	{
		guard let collidee = collidee else { return }
		if collidee.name == "collisionBlock"
		{
			//physicsBody?.isResting = false
			destructionInitiated = true
			//initiateSelfDestruction()
		} else {
			if let _ = collidee as? Obstacle {
				run(Self.collisionSound)
			}
		}
		
		super.reactToCollision()
	}

	@objc override func initiateSelfDestruction()
	{
		if let fireParticles = SKEmitterNode(fileNamed: "BallVanishing")
		{
			fireParticles.position = self.position
			parent!.addChild(fireParticles)
		}
		super.initiateSelfDestruction()
	}
}


/**
	CollidableDelegate protocol
*/

protocol CollidableDelegate
{
	func willCollide(sender: Collidable)
	func didCollide(sender: Collidable)
	func willInitiateSelfDestruction(sender: Collidable)
	func didSelfDestruct(sender: Collidable)
}

extension CollidableDelegate
{
	func willCollide(sender: Collidable) {}
	func didCollide(sender: Collidable) {}
	func willInitiateSelfDestruction(sender: Collidable) {}
	func didSelfDestruct(sender: Collidable) {}
}
