//
//  AppDelegate.swift
//  VkClient
//
//  Created by lupuls on 23/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import UIKit
import Swinject
import VK_ios_sdk


@UIApplicationMain
class AppDelegate: UIResponder {
	var resolver: Resolver {
		return UIApplication.assembler.resolver.resolve(Assembler.self)!.resolver
	}

	var interaction: Interaction {
		return resolver.resolve(Interaction.self)!
	}

	var window: UIWindow?
}

extension AppDelegate: UIApplicationDelegate {
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		VKSdk.initialize(withAppId: "6458414")
		interaction.start()

		return true
	}

	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		VKSdk.processOpen(url, fromApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String)
		return true
	}
}
