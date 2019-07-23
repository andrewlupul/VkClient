//
//  FriendTableViewCell.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import UIKit
import SnapKit


struct FriendCellModel {
    let name: String
    let imageUrl: String?
}


final class FriendTableViewCell: UITableViewCell {
	private let avatarImageView = UIImageView()
	private let nameLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImageView.image = nil
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    func setup() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.clipsToBounds = true
        
        addSubview(avatarImageView)
        addSubview(nameLabel)
        
        avatarImageView.snp.makeConstraints {
            $0.height.width.equalTo(40)
            $0.top.bottom.left.equalToSuperview().inset(4)
            $0.right.equalTo(nameLabel.snp.left).inset(-4)
        }
        
        nameLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(4)
            $0.centerY.equalTo(avatarImageView.snp.centerY)
        }
    }

	func configureWith(model: FriendCellModel) {
		nameLabel.text = model.name

		guard let avatarURL = model.imageUrl else {
			return
		}

		avatarImageView.downloaded(from: avatarURL)
	}
}
