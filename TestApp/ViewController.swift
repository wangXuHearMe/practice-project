//
//  ViewController.swift
//  TestApp
//
//  Created by wangxu on 2023/12/6.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  private func setupUI() {
    view.backgroundColor = .green
  }
}
