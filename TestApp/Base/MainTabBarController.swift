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
  case category
  case found
  case cart
  case mine
  
  var desciption: String {
    switch self {
    case .home:
      return "首页"
    case .category:
      return "分类"
    case .found:
      return "发现"
    case .cart:
      return "购物车"
    case .mine:
      return "我的"
    }
  }
    
  var tabBarImage: UIImage? {
    switch self {
    case .home:
      return UIImage(systemName: "house")
    case .category:
      return UIImage(systemName: "square.grid.3x3")
    case .found:
      return UIImage(systemName: "safari")
    case .cart:
      return UIImage(systemName: "cart")
    case .mine:
      return UIImage(systemName: "person")
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
    let category = viewControllerFactory(type: .category)
    let found = viewControllerFactory(type: .found)
    let cart = viewControllerFactory(type: .cart)
    let mine = viewControllerFactory(type: .mine)

    viewControllers = [home, category, found, cart, mine]
    setMainTabBarItemAttributes(bgColor: UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1))
  }
  
  private func viewControllerFactory(type: MainTabBarItem) -> UIViewController {
    var vc: UIViewController
    switch type {
    case .home:
      vc = UINavigationController(rootViewController: HomeViewController(tabBarType: .home))
    case .category:
      vc = UINavigationController(rootViewController: CategoryViewController(tabBarType: .category))
    case .found:
      vc = UINavigationController(rootViewController: FoundViewController(tabBarType: .found))
    case .cart:
      vc = UINavigationController(rootViewController: CartViewController(tabBarType: .cart))
    case .mine:
      vc = UINavigationController(rootViewController: MineViewController(tabBarType: .mine))
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
