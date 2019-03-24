//
//  Button.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import UIKit


class Button: UIButton {
	override init(frame: CGRect) {
		super.init(frame: frame)

		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)

		commonInit()
	}

	func commonInit() {
		
	}
}
