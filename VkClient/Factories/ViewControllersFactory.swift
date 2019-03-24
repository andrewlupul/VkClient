//
//  ViewControllersFactory.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import Foundation
import Swinject


protocol ViewControllersFactory {
	func signIn() -> SignInViewController
	func friendList() -> FriendListViewController
}


struct ViewControllersFactoryImpl: ViewControllersFactory {
	let resolver: Resolver

	func signIn() -> SignInViewController {
		return resolver.resolve(SignInViewController.self)!
	}

	func friendList() -> FriendListViewController {
		return resolver.resolve(FriendListViewController.self)!
	}
}
