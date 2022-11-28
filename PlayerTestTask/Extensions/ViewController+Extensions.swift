//
//  ViewController+Extensions.swift
//  PlayerTestTask
//
//  Created by Admin on 28.11.2022.
//

import UIKit

extension UIViewController {
    func addNavBarImage(withTitle title: String) {
        guard let navController = navigationController else { return }
        let image = UIImage(named: title)
        let imageView = UIImageView(image: image)
        
        let width = navController.navigationBar.frame.size.width
        let height = navController.navigationBar.frame.size.height
        let bannerX = width / 2 - (image?.size.width ?? 0) / 2
        let bannerY = height / 2 - (image?.size.height ?? 0) / 2
        
        imageView.frame = CGRect(x: bannerX, y: bannerY,
                                 width: width / 1.9,
                                 height: height / 1.9)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
}
