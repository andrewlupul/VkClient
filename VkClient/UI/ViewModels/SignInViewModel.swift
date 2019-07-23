//
//  SignInViewModel.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import Foundation
import RxCocoa


protocol SignInViewModel {
	func bindings() -> SignInViewControllerBindings
}


final class SignInViewModelImpl {
	private let vkService: VkService

	private let signInCompleteRelay = PublishRelay<Void>()
	private let errorRelay = PublishRelay<Error>()

	init(vkService: VkService) {
		self.vkService = vkService
	}
}


extension SignInViewModelImpl: SignInViewModel {
	func bindings() -> SignInViewControllerBindings {
		return self
	}
}


extension SignInViewModelImpl: SignInViewControllerBindings {
	func signInButtonTapped() -> Binder<Void> {
		return Binder(self, binding: { viewModel, _ in
			viewModel.signIn()
		})
	}
	
	func successSignIn() -> Signal<Void> {
		return signInCompleteRelay.asSignal()
	}

	private func signIn() {
		vkService.login(loginSuccess: { [weak self] in
			self?.signInCompleteRelay.accept(())
		}, loginFailure: {
            // TODO:
        })
	}
}
