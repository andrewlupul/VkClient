//
//  FriendListViewModel.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift


protocol FriendListViewModel {
	func bindings() -> FriendListViewControllerBindings
}


class FriendListViewModelImpl {
	let vkService: VkService

	let friendsRelay = BehaviorRelay<[Friend]>(value: [])
	let isRefreshingRelay = BehaviorRelay<Bool>(value: false)
	let isErrorRelay = PublishRelay<Error>()

	init(vkService: VkService) {
		self.vkService = vkService

		refresh()
	}

	func refresh() {
		isRefreshingRelay.accept(true)
		
		vkService.getFriends(sucсess: { [weak self] in
			self?.friendsRelay.accept($0)
			self?.isRefreshingRelay.accept(false)
		}, failure: { [weak self] in
			guard let error = $0 else {
				return
			}
			self?.isErrorRelay.accept(error)
			self?.isRefreshingRelay.accept(false)
		})
	}
}


extension FriendListViewModelImpl: FriendListViewModel {
	func bindings() -> FriendListViewControllerBindings {
		return self
	}
}


extension FriendListViewModelImpl: FriendListViewControllerBindings {
	func error() -> Signal<Error> {
		return isErrorRelay.asSignal()
	}

	func isRefreshing() -> Driver<Bool> {
		return isRefreshingRelay.asDriver()
	}

	func refreshInput() -> Binder<Void> {
		return Binder(self, binding: { viewModel, _ in
			viewModel.refresh()
		})
	}

	func friends() -> BehaviorRelay<[Friend]> {
		return friendsRelay
	}
}
