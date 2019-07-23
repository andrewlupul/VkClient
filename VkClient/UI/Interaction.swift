//
//  Interaction.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import UIKit


protocol Interaction {
	func start()
}


final class InteractionImpl {
	private let window: UIWindow
	private let navigationController: UINavigationController
	private let factory: ViewControllersFactory
	private let vkService: VkService

	init(window: UIWindow,
		 navigationController: UINavigationController,
		 factory: ViewControllersFactory,
		 vkService: VkService)
	{
		self.window = window
		self.navigationController = navigationController
		self.factory = factory
		self.vkService = vkService

		window.makeKeyAndVisible()
	}
}


extension InteractionImpl: Interaction {
	func start() {
		vkService.checkAuth(hasSession: { [weak self] in
			self?.runFriendList()
		}, noSession: { [weak self] in
			self?.runSignIn()
		})
	}
}


extension InteractionImpl {
	private func runSignIn() {
		let vc = factory.signIn()

		vc.onComplete = { [weak self] in
			switch $0 {
			case .signIn:
				self?.runFriendList()
			}
		}
		
		navigationController.setViewControllers([vc], animated: true)
		navigationController.setNavigationBarHidden(true, animated: true)
	}

	private func runFriendList() {
		let vc = factory.friendList()

		navigationController.setViewControllers([vc], animated: true)
		navigationController.setNavigationBarHidden(false, animated: true)
	}
}
