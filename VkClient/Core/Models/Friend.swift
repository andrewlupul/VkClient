//
//  Friend.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import Foundation


struct Friend: Codable {
	let firstName: String
	let lastName: String
	let avatarUrl: String?

	func fullName() -> String {
		return "\(firstName) \(lastName)"
	}

	enum CodingKeys: String, CodingKey {
		case firstName = "first_name"
		case lastName = "last_name"
		case avatarUrl = "photo_100"
	}
}
