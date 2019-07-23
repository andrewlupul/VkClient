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
	func friends() -> BehaviorRelay<[FriendCellModel]>

	func refreshInput() -> Binder<Void>
	func error() -> Signal<Error>
}


final class FriendListViewController: BaseViewController {
	@IBOutlet weak var tableView: UITableView!

	var bindings: FriendListViewControllerBindings?

	private let disposeBag = DisposeBag()
	private let refreshControl = UIRefreshControl()
	
	override func viewDidLoad() {
		super.viewDidLoad()

		setup()
	}

	private func setup() {
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

        disposeBag.insert([
            bindings.friends()
                .bind(to: tableView.rx.items(cellIdentifier: "FriendTableViewCell",
                                             cellType: FriendTableViewCell.self))
                { (row, element, cell) in
                    cell.configureWith(model: element)
                },
            bindings.isRefreshing()
                .drive(refreshControl.rx.isRefreshing),
            bindings.error()
                .emit(to: self.rx.error),
            
            refreshControl.rx.controlEvent(.valueChanged)
                .asSignal()
                .emit(to: bindings.refreshInput())
        ])
		
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
