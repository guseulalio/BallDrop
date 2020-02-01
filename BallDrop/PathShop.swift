//
//  PathShop.swift
//  Badoque
//
//  Created by Gustavo E M Cabral on 21/12/19.
//  Copyright © 2019 Gustavo Eulalio. All rights reserved.
//

import Foundation
import SpriteKit

func makeArrowPath(ofSize size: CGSize) -> CGPath {
	let path = UIBezierPath()
	let w = size.width
	let h = size.height
	let half = w / 2
	//let arrowWidth = w
	
	path.move(to: CGPoint(x: half, y:h))
	path.addLine(to: CGPoint(x: half, y:h))
	path.move(to: CGPoint(x: half, y:h/2))
	path.addLine(to: CGPoint(x: half, y:half))
	path.move(to: CGPoint(x: half - w/2, y:w))
	path.addLine(to: CGPoint(x: half, y:0))
	path.addLine(to: CGPoint(x: half + w/2, y:w))
	
	return path.cgPath
}

func makeBoxPath(ofSize size: CGSize, ceilingAndFloor ceiling: CGFloat, andSides sides: CGFloat) -> CGPath {
	let path = UIBezierPath()
	
	let width = size.width
	let height = size.height
	
	path.move(to: CGPoint(x: 0, y: 0))
	path.addLine(to: CGPoint(x: 0, y: height))
	path.addLine(to: CGPoint(x: width, y: height))
	path.addLine(to: CGPoint(x: width, y: 0))
	path.close()
	
	path.move(to: CGPoint(x: sides, y: ceiling))
	path.addLine(to: CGPoint(x: sides, y: height - ceiling))
	path.addLine(to: CGPoint(x: width - sides, y: height - ceiling))
	path.addLine(to: CGPoint(x: width - sides, y: ceiling))
	path.close()
	
	return path.cgPath
}
