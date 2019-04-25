//
//  Settings.swift
//  FinalProject
//
//  Created by Jacob Grant on 4/22/19.
//  Copyright © 2019 Jacob Grant. All rights reserved.
//

import Foundation
import SpriteKit

enum ZPositions {
    static let backGround : CGFloat = 0
    static let rocket : CGFloat = 1
    static let asteroid : CGFloat = 2.1
    static let alien : CGFloat = 2.2
    static let label : CGFloat = 1
    static let laser : CGFloat = 2
}

enum PhysicsSettings {
    static let none : UInt32 = 0x0
    static let object : UInt32 = 0x1
    static let rocket : UInt32 = 0x1 << 1
    static let laser : UInt32 = 0x1 << 2
    static let alienLaser : UInt32 = 0x1 << 3
}

enum SpawnDifficultySettings {
    static let easy : TimeInterval = 1.5
    static let medium : TimeInterval = 1
    static let hard : TimeInterval = 0.6
}
