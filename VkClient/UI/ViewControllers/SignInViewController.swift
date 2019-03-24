//
//  SignInViewController.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import VK_ios_sdk


protocol SignInViewControllerBindings {
	func successSignIn() -> Signal<Void>
	func signInButtonTapped() -> Binder<Void>
}


class SignInViewController: BaseViewController, FlowController {
	enum Event {
		case signIn
	}

	@IBOutlet weak var signInButton: CtaButton!

	var bindings: SignInViewControllerBindings?
	var onComplete: ((Event) -> ())?

	let disposeBag = DisposeBag()

	override func viewDidLoad() {
		super.viewDidLoad()

		setup()
	}

	private func setup() {
		VKSdk.instance().uiDelegate = self
		signInButton.setTitle("Sign In", for: .normal)
	}

	func configureWith(bindings: SignInViewControllerBindings) {
		self.bindings = bindings

		bindings.successSignIn()
			.emit(onNext: { [weak self] in
				self?.complete(.signIn)
			}).disposed(by: disposeBag)

		signInButton.rx.tap
			.asSignal()
			.emit(to: bindings.signInButtonTapped())
			.disposed(by: disposeBag)
	}
}


extension SignInViewController: VKSdkUIDelegate {
	func vkSdkShouldPresent(_ controller: UIViewController!) {
		self.present(controller, animated: true, completion: nil)
	}

	func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {}
}
