//
//  KeyBindPreferences.swift
//  sable
//
//  Created by jueon on 2021/01/12.
//  Copyright © 2021 jueon. All rights reserved.
//

struct KeybindPreferences: Codable {
    let left: Int
    let right: Int
    let up: Int
    let down: Int
    let u: Int
    let i: Int
    let k: Int
    let j: Int
    let downRight: Int
    let rightUp: Int
    let upLeft: Int
    let leftDown: Int
    let upRight: Int
    let rightDown: Int
    let downLeft: Int
    let leftUp: Int
    let characters: String?

    enum CodingKeys: String, CodingKey {
        case left, right, up, down, u, i, k, j
        case downRight = "down_right"
        case rightUp = "right_up"
        case upLeft = "up_left"
        case leftDown = "left_down"
        case upRight = "up_right"
        case rightDown = "right_down"
        case downLeft = "down_left"
        case leftUp = "left_up"
        case characters
    }
}
