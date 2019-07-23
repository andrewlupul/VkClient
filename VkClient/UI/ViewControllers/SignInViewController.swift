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


final class SignInViewController: BaseViewController, FlowController {
	enum Event {
		case signIn
	}

	private let signInButton = CtaButton()
    private let logoImageView = UIImageView(image: #imageLiteral(resourceName: "logo"))

    private let disposeBag = DisposeBag()
    
    var bindings: SignInViewControllerBindings?
    var onComplete: ((Event) -> ())?

    override func viewDidLoad() {
		super.viewDidLoad()

		setup()
	}
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(signInButton)
        view.addSubview(logoImageView)
        
        signInButton.snp.makeConstraints {
            $0.centerY.equalToSuperview().inset(100)
            $0.left.right.equalToSuperview().inset(24)
        }
        
        logoImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().inset(-100)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(100)
        }
    }

	private func setup() {
		VKSdk.instance().uiDelegate = self
		signInButton.setTitle("Sign In", for: .normal)
        view.backgroundColor = .background
	}

	func configureWith(bindings: SignInViewControllerBindings) {
		self.bindings = bindings

        disposeBag.insert([
            bindings.successSignIn()
                .emit(onNext: { [weak self] in
                    self?.complete(.signIn)
                }),
            
            signInButton.rx.tap
                .asSignal()
                .emit(to: bindings.signInButtonTapped())
        ])
	}
}


extension SignInViewController: VKSdkUIDelegate {
	func vkSdkShouldPresent(_ controller: UIViewController!) {
		self.present(controller, animated: true, completion: nil)
	}

	func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {}
}
