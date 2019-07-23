//
//  VkService.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import Foundation
import VK_ios_sdk


typealias callBack = () -> Void


protocol VkService {
	func getFriends(sucсess: @escaping ([Friend]) -> Void,
                    failure: @escaping (Error?) -> Void)
    
	func login(loginSuccess: @escaping callBack,
               loginFailure: @escaping callBack)
    
	func checkAuth(hasSession: @escaping callBack,
                   noSession: @escaping callBack)
}


final class VkServiceImpl: NSObject, VkService {
	private var loginSuccess: (callBack)?
	private var loginFailure: (callBack)?

	func login(loginSuccess: @escaping callBack,
               loginFailure: @escaping callBack) {
		VKSdk.instance().register(self)
		VKSdk.authorize(["friends", "photos"])
		self.loginSuccess = loginSuccess
		self.loginFailure = loginFailure
	}

	func getFriends(sucсess: @escaping ([Friend]) -> Void,
                    failure: @escaping (Error?) -> Void) {
		VKApi.friends().get(["counts": 500, "fields": "photo_100"]).execute(resultBlock: { (response) in
			guard let json = response?.json as? [String: Any] else { return failure(nil)}
			guard let data = try? JSONSerialization.data(withJSONObject: json, options: []) else {
				return failure(nil)
			}

			let friendList: FriendListResponse = try! JSONDecoder().decode(FriendListResponse.self, from: data)

			sucсess(friendList.items)

		}, errorBlock: { (error) in
			if let error = error {
				failure(error)
			}
		})
	}

	func checkAuth(hasSession: @escaping callBack,
                   noSession: @escaping callBack) {
		VKSdk.wakeUpSession(["friends", "photos"]) { (vkAuthState, error) in
			if vkAuthState == VKAuthorizationState.authorized {
				hasSession()
			} else {
				noSession()
			}
		}
	}
}


extension VkServiceImpl: VKSdkDelegate {
	func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
		loginSuccess?()
	}

	func vkSdkUserAuthorizationFailed() {
		loginFailure?()
	}
}
