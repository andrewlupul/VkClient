//
//  Assembly.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import UIKit
import Swinject


struct MainAssembly: Assembly {
	func assemble(container: Container) {
		container.register(Assembler.self) { _ in
			return UIApplication.assembler
		}

		container.register(UIWindow.self) { (_, root: UIViewController) in
			let window = UIWindow(frame: UIScreen.main.bounds)
			window.rootViewController = root
			
			return window
		}

		container.register(UINavigationController.self) { _ in
			return UINavigationController()
		}

		container.register(Interaction.self) { r in
			return r.resolve(InteractionImpl.self)!
		}

		container.register(InteractionImpl.self) { r in
			let navigationController = r.resolve(UINavigationController.self)!
			let window = r.resolve(UIWindow.self, argument: navigationController as UIViewController)!
			let factory = r.resolve(ViewControllersFactory.self)!
			let service = r.resolve(VkService.self)!

			return InteractionImpl(window: window,
								   navigationController: navigationController,
								   factory: factory,
								   vkService: service)
		}.inObjectScope(.container)

		container.register(ViewControllersFactory.self) { r in
			let assembler = r.resolve(Assembler.self)!

			return ViewControllersFactoryImpl(resolver: assembler.resolver)
		}

		container.register(VkService.self) { _ in
			return VkServiceImpl()
		}

		container.register(SignInViewModel.self) { r in
			let service = r.resolve(VkService.self)!

			return SignInViewModelImpl(vkService: service)
		}

		container.register(SignInViewController.self) { r in
			let vc = SignInViewController()
			let viewModel = r.resolve(SignInViewModel.self)!

			vc.lazyLoadBlock = { [weak vc] in
				vc?.configureWith(bindings: viewModel.bindings())
			}

			return vc
		}

		container.register(FriendListViewModel.self) { r in
			let service = r.resolve(VkService.self)!

			return FriendListViewModelImpl(vkService: service)
		}

		container.register(FriendListViewController.self) { r in
			let vc = FriendListViewController()
			let viewModel = r.resolve(FriendListViewModel.self)!
//			vc.configureWith(bindings: viewModel.bindings())

			vc.lazyLoadBlock = { [weak vc] in
				vc?.configureWith(bindings: viewModel.bindings())
			}

			return vc
		}
	}
}
