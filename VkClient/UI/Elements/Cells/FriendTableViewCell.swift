//
//  FriendTableViewCell.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import UIKit


class FriendTableViewCell: UITableViewCell {
	@IBOutlet weak var avatarImageView: UIImageView!
	@IBOutlet weak var nameLabel: UILabel!

	override func awakeFromNib() {
		super.awakeFromNib()

		avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
		avatarImageView.clipsToBounds = true
	}

	func configureWith(friend: Friend) {
		nameLabel.text = friend.fullName()

		guard let avatarURL = friend.avatar else {
			return
		}

		avatarImageView.downloaded(from: avatarURL)
	}
}
