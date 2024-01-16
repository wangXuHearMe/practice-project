//
//  BaseNavigationController.swift
//  TestApp
//
//  Created by wangxu on 2024/1/15.
//

import Foundation
import UIKit

public class BaseNavigationController: UINavigationController {
  public override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  public func pushViewController(_ viewController: UIViewController, animated: Bool, hiddenBottomBarWhenPushed: Bool = false) {
    viewController.hidesBottomBarWhenPushed = hiddenBottomBarWhenPushed
    pushViewController(viewController, animated: animated)
  }
}
