//
//  GameScene.swift
//  Badoque
//
//  Created by Gustavo E M Cabral on 19/12/19.
//  Copyright © 2019 Gustavo Eulalio. All rights reserved.
//

import SpriteKit

extension CGSize {
	static func * (_ size: CGSize, _ factor: CGFloat) -> CGSize {
		return CGSize(width: size.width * factor, height: size.height * factor)
	}
}

class GameScene: SKScene, SKPhysicsContactDelegate, CollidableDelegate
{
	private var ballInField = false

	let livesCounter = LivesCounter()
	
	var arrow: SKShapeNode?
	var ballSide: CGFloat = 0
	let bgColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
	
	func getFrame() -> CGRect {
		return frame
	}

    override func didMove(to view: SKView)
	{
		ballSide = self.frame.size.width / 12
		physicsWorld.gravity = CGVector(dx: 0, dy: -5)
		
		/// # Background
		let background = SKSpriteNode(color: bgColor, size: self.frame.size)
		background.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height / 2)
		background.blendMode = .replace
		background.zPosition = -10
		addChild(background)
		
		/// ## Walls
		let wallColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		let topWall = SKSpriteNode(color: wallColor, size: CGSize(width: frame.width, height: frame.height * 0.125))
		topWall.position = CGPoint(x: frame.midX, y: frame.height-topWall.frame.height/2)
		topWall.zPosition = 1
		let bottomWall = SKSpriteNode(color: wallColor, size: CGSize(width: frame.width, height: frame.height * 0.125))
		bottomWall.position = CGPoint(x: frame.midX, y: bottomWall.frame.height/2)
		bottomWall.zPosition = 1
		let leftWall = SKSpriteNode(color: wallColor, size: CGSize(width: frame.width * 0.05, height: frame.height))
		leftWall.position = CGPoint(x: leftWall.frame.width/2, y: frame.midY)
		leftWall.zPosition = 1
		let rightWall = SKSpriteNode(color: wallColor, size: CGSize(width: frame.width * 0.05, height: frame.height))
		rightWall.position = CGPoint(x: frame.width - leftWall.frame.width/2, y: frame.midY)
		rightWall.zPosition = 1
		addChild(topWall)
		addChild(bottomWall)
		addChild(leftWall)
		addChild(rightWall)
		
		livesCounter.position = CGPoint(x: livesCounter.frame.width, y: frame.height - livesCounter.frame.height)
		livesCounter.zPosition = 2
		addChild(livesCounter)
		
		
		/** Invisible wall that destroys the balls
			This block is intended to work as a collision point to the balls behind the bottom wall.
			Because, if the ball colides with the bottom wall, it will disappear while
			still being fully within user view and the explosion doesn't look very good.
			So this block is located a few points below the bottom wall to allow the balls
			to sink behind it before exploding. This looks better.
		**/
		let collisionBlock = bottomWall.copy() as! SKSpriteNode
		collisionBlock.position = CGPoint(x: collisionBlock.position.x, y: collisionBlock.position.y - ballSide / 2)
		collisionBlock.zPosition = 0.5
		collisionBlock.name = "collisionBlock"
		collisionBlock.physicsBody = SKPhysicsBody(rectangleOf: bottomWall.frame.size)
		collisionBlock.physicsBody?.isDynamic = false
		addChild(collisionBlock)

		// # Game area
		let box = SKSpriteNode(color: .white, size: CGSize(width: frame.width * 0.9, height: frame.height * 0.75 + ballSide))
		box.position = CGPoint(x: frame.midX, y: frame.midY - ballSide / 2)
		box.alpha = 0
		box.zPosition = 1
		box.name = "gameBox"
		addChild(box)
		
		physicsBody = SKPhysicsBody(edgeLoopFrom: box.frame)
		print("Physics frame = \(physicsBody!.accessibilityFrame))")
		physicsBody!.restitution = 0.5
		physicsWorld.contactDelegate = self
		
		// Obstacles
		makeObstacles()
    }
	
	func makeObstacles() {
		for i in 0..<5
		{
			for j in 0 ..< 4
			{
				if (i % 2 == 0 && j % 2 != 0) || (i % 2 != 0 && j % 2 == 0) {
					let spacing = self.frame.size.width / 6
					let obstacle = getRandomObstacle()
					obstacle.position = CGPoint(x: CGFloat(i) * spacing + spacing, y: CGFloat(j) * spacing + spacing*2)
					obstacle.name = "obstacle \(Int.random(in: 1...10_000))"
					obstacle.zPosition = -0.1
					addChild(obstacle)
				}
			}
			
		}
	}
	
	func getRandomObstacle() -> Obstacle {
		switch Int.random(in: 1...5)
		{
		case 1: return PiscesObstacle(withSize: CGSize(width: ballSide, height: ballSide))
		case 2: return GearObstacle(withSize: CGSize(width: ballSide, height: ballSide))
		case 3: return CycleObstacle(withSize: CGSize(width: ballSide, height: ballSide))
		case 4: return StoneSphereObstacle(withSize: CGSize(width: ballSide, height: ballSide))
		default: return VolleyballBallObstacle(withSize: CGSize(width: ballSide, height: ballSide))
		}
	}
	
	// Touch down
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		guard !ballInField else { return }
		let arrowSize = CGSize(width: self.frame.size.width / 20, height: self.frame.size.height / 5)
		let path = makeArrowPath(ofSize: arrowSize)
		arrow = SKShapeNode(path: path, centered: true)
		arrow!.lineWidth = 5
		arrow!.strokeColor = .white
		arrow!.position = CGPoint(x: self.frame.size.width / 2, y: self.frame.size.height * 0.85)
		addChild(arrow!)
	}
	
	// Moving while toching down
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		guard !ballInField else { return }
		guard let touch = touches.first else { return }
		guard let arrow = self.arrow else { return }
		let touchLocation = touch.location(in: self)
		
		let angle = atan2(touchLocation.y - arrow.position.y , touchLocation.x - arrow.position.x)
		if angle < 0 || angle > CGFloat(Double.pi) {
			arrow.zRotation = angle + CGFloat(Double.pi / 2)
		}
	}
	
	// touch up
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		guard !ballInField else { return }
		guard let touch = touches.first else { return }
		guard let arrow = self.arrow else { return }
		let touchLocation = touch.location(in: self)
		
		let ball = Projectile(withSize: CGSize(width: ballSide, height: ballSide))
		ball.setDelegate(self)
		ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
		ball.physicsBody!.restitution = 0.6
		ball.physicsBody!.friction = 0
		ball.physicsBody!.contactTestBitMask = 0xFFFFFFFF
		ball.physicsBody!.usesPreciseCollisionDetection = true
		ball.name = "projectile \(Int.random(in: 1...10_000))"
		
		let angle = atan2(touchLocation.y - arrow.position.y , touchLocation.x - arrow.position.x)
		let dx = arrow.frame.width * cos(angle)
		let dy = arrow.frame.width * sin(angle)
		let x = arrow.position.x + dx
		let y = arrow.position.y + dy
		ball.position = CGPoint(x: x, y: y)

		addChild(ball)
		
		let move = SKAction.applyImpulse(CGVector(dx: dx * 2, dy: dy), duration: 2)
		let spin = SKAction.rotate(byAngle: Bool.random() ? -.pi : .pi, duration: 0.5)
		let spinForever = SKAction.repeatForever(spin)
		ball.run(spinForever, withKey: "spin")
		ball.run(move, withKey: "impulse")
		
		ballInField = true
		arrow.removeFromParent()
	}
	
	// Collisions
	func didBegin(_ contact: SKPhysicsContact)
	{
		guard let nodeA = contact.bodyA.node else { return }
		guard let nodeB = contact.bodyB.node else { return }
		
		if let nodeA = nodeA as? Collidable {
			nodeA.removeAction(forKey: "impulse")
			nodeA.removeAction(forKey: "spin")
			nodeA.setupCollision(with: nodeB, on: contact)
			nodeA.reactingToCollision = true
		}
		if let nodeB = nodeB as? Collidable {
			nodeB.removeAction(forKey: "impulse")
			nodeB.removeAction(forKey: "spin")
			nodeB.setupCollision(with: nodeA, on: contact)
			nodeB.reactingToCollision = true
		}
	}
	
	func didSelfDestruct(sender: Collidable) {
		ballInField = false
		livesCounter.lives -= 1
	}
}
