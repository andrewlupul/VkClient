//
//  FriendListResponse.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import Foundation


struct FriendListResponse: Codable {
	let items: [Friend]

	enum CodingKeys: String, CodingKey {
		case items
	}
}
