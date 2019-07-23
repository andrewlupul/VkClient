//
//  UIImage.swift
//  VkClient
//
//  Created by lupuls on 24/03/2019.
//  Copyright © 2019 lupuls. All rights reserved.
//

import UIKit


extension UIImageView {
	private func downloaded(from url: URL) {
		URLSession.shared.dataTask(with: url) { data, response, error in
			guard
				let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
				let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
				let data = data, error == nil,
				let image = UIImage(data: data)
            else {
                return
            }
			DispatchQueue.main.async() {
				self.image = image
			}
		}.resume()
	}

	public func downloaded(from link: String) {
		guard let url = URL(string: link) else {
            return
        }
        
		downloaded(from: url)
	}
}
