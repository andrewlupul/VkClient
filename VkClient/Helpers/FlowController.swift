//
//  FlowController.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import Foundation


protocol FlowController {
	associatedtype Event

	typealias FlowControllerCompletionBlock = (Event) -> ()

	var onComplete: FlowControllerCompletionBlock? { get set }
}

extension FlowController {
	func complete(_ event: Event) {
		if Thread.isMainThread {
			self.onComplete?(event)
			return
		}

		DispatchQueue.main.async { [self] in
			self.onComplete?(event)
		}
	}
}
