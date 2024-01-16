//
//  File.swift
//  TestApp
//
//  Created by wangxu on 2024/1/12.
//

import Foundation
import UIKit
import SnapKit

final class HomeViewController: BaseViewController {
  override func setupUI() {
    let xx = UIView()
    xx.backgroundColor = .green
    view.addSubview(xx)
    xx.snp.makeConstraints { make in
      make.center.equalToSuperview()
      make.size.equalTo(CGSize(width: 200, height: 200))
    }
    xx.setupTouch { [weak self] _ in
      self?.xx()
    }
  }
  
  override func setupNavigationBar() {
    super.setupNavigationBar()
    navigationController?.navigationBar.prefersLargeTitles = true
  }
  
  func xx() {
    navigationController?.pushViewController(ViewController(), animated: true)
  }
}
