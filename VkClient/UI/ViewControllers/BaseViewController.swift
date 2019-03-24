//
//  BaseViewController.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import UIKit


typealias ViewControllerLazyLoadBlock = () -> ()


class BaseViewController: UIViewController {
	var lazyLoadBlock: ViewControllerLazyLoadBlock?

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		lazyLoadBlock?()
		lazyLoadBlock = nil
	}
}
