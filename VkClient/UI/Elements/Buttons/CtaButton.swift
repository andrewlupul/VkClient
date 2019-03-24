//
//  CtaButton.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import UIKit


class CtaButton: Button {
	override var intrinsicContentSize: CGSize {
		var size = sizeThatFits(UIView.layoutFittingCompressedSize)
		size.height = 40

		return size
	}

	override func commonInit() {
		backgroundColor = UIColor.white
		layer.cornerRadius = 12
		titleLabel?.font = UIFont(name: "Helvetica", size: 20)
		setTitleColor(UIColor.black, for: .normal)
	}
}
