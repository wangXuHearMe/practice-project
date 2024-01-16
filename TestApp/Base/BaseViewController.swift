//
//  BaseViewController.swift
//  TestApp
//
//  Created by wangxu on 2024/1/15.
//

import Foundation
import UIKit

public class BaseViewController: UIViewController {
  public let tabBarType: MainTabBarItem
  init(tabBarType: MainTabBarItem) {
    self.tabBarType = tabBarType
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupUI()
  }
  
  public func setupNavigationBar() {
    title = tabBarType.desciption
  }
  
  public func setupUI() {}
}
