//
//  FriendListViewController.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


protocol FriendListViewControllerBindings {
	func isRefreshing() -> Driver<Bool>
	func friends() -> BehaviorRelay<[Friend]>

	func refreshInput() -> Binder<Void>
	func error() -> Signal<Error>
}


class FriendListViewController: BaseViewController {
	@IBOutlet weak var tableView: UITableView!

	var bindings: FriendListViewControllerBindings?

	let disposeBag = DisposeBag()
	let refreshControl = UIRefreshControl()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		setup()
	}

	func setup() {
		navigationItem.title = "Friends"

		if #available(iOS 10.0, *) {
			tableView.refreshControl = refreshControl
		} else {
			tableView.addSubview(refreshControl)
		}

		tableView.contentInset.bottom = 10
		tableView.register(UINib(nibName: "FriendTableViewCell", bundle: nil), forCellReuseIdentifier: "FriendTableViewCell")
	}

	func configureWith(bindings: FriendListViewControllerBindings) {
		self.bindings = bindings

		bindings.friends()
			.bind(to: tableView.rx.items(cellIdentifier: "FriendTableViewCell", cellType: FriendTableViewCell.self)) { (row, element, cell) in
				cell.configureWith(friend: element)
			}.disposed(by: disposeBag)
		bindings.isRefreshing()
			.drive(refreshControl.rx.isRefreshing)
			.disposed(by: disposeBag)
		bindings.error()
			.emit(to: self.rx.error)
			.disposed(by: disposeBag)

		refreshControl.rx.controlEvent(.valueChanged)
			.asSignal()
			.emit(to: bindings.refreshInput())
			.disposed(by: disposeBag)
	}

	func presentErrorAlert(error: Error) {
		let alert = UIAlertController(title: "Error",
									  message: error.localizedDescription,
									  preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "Ok",
									  style: UIAlertAction.Style.default,
									  handler: nil))

		present(alert, animated: true, completion: nil)
	}
}


extension Reactive where Base: FriendListViewController {
	var error: Binder<Error> {
		return Binder(base, binding: { vc, error in
			vc.presentErrorAlert(error: error)
		})
	}
}
