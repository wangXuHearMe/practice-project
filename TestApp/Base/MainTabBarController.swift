//
//  MainTabBarController.swift
//  TestApp
//
//  Created by wangxu on 2024/1/12.
//

import Foundation
import UIKit

public enum MainTabBarItem: String {
  case home
//  case category
//  case found
//  case cart
//  case mine
  
  var desciption: String {
    switch self {
    case .home:
      return "首页"
    }
  }
    
  var tabBarImage: UIImage? {
    switch self {
    case .home:
      return UIImage(systemName: "house")
    }
  }
}

final class MainTabBarController: UITabBarController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabBar()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    print(UIScreen.main.bounds.height)
  }
  
  private func setupTabBar() {
    view.backgroundColor = .white
    let home = viewControllerFactory(type: .home)

    viewControllers = [home/*, category, found, cart, mine*/]
    setMainTabBarItemAttributes(bgColor: UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1))
  }
  
  private func viewControllerFactory(type: MainTabBarItem) -> UIViewController {
    var vc: UIViewController
    switch type {
    case .home:
      vc = UINavigationController(rootViewController: HomeViewController(tabBarType: .home))
    }
    
    vc.tabBarItem.title = type.desciption
    vc.tabBarItem.image = type.tabBarImage
    
    return vc
  }
  
  private func setMainTabBarItemAttributes(fontName: String = "Courier",
                               fontSize: CGFloat = 14,
                               normalColor: UIColor = .gray,
                               selectedColor: UIColor = .red,
                               bgColor: UIColor = .white) {
    var attributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: fontName, size: fontSize)!]

    attributes[.foregroundColor] = normalColor
    UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)

    attributes[.foregroundColor] = selectedColor
    UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .selected)

    tabBar.tintColor = selectedColor
    tabBar.barTintColor = bgColor
  }
}
