//
//  UIApplication.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import Foundation
import Swinject


extension UIApplication {
	static let assembler = Assembler([MainAssembly()])
}
