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
	private let tableView = UITableView()

	var bindings: FriendListViewControllerBindings?

	private let disposeBag = DisposeBag()
	private let refreshControl = UIRefreshControl()
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeArea.top)
            $0.left.right.bottom.equalToSuperview()
        }
    }
	
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

		tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.register(FriendTableViewCell.self,
                           forCellReuseIdentifier: FriendTableViewCell.reusableIdentifier)
	}

	func configureWith(bindings: FriendListViewControllerBindings) {
		self.bindings = bindings

        disposeBag.insert([
            bindings.friends()
                .bind(to: tableView.rx.items(cellIdentifier: FriendTableViewCell.reusableIdentifier,
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
