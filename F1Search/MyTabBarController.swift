//
//  MyTabBarController.swift
//  F1Search
//
//  Created by Константин Чернов on 26.01.2021.
//

import UIKit
class MyTabBarController: UITabBarController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var childForStatusBarStyle: UIViewController? {
        return nil
    }
}
