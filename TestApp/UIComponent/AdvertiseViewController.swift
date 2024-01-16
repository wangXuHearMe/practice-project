//
//  AdvertiseViewController.swift
//  TestApp
//
//  Created by wangxu on 2024/1/15.
//

import Foundation
import UIKit

final class AdvertiseViewController: UIViewController {
  lazy var timer = DispatchSource.makeTimerSource(queue: .global())
  var seconds = 3
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    timeCutdown()
  }
  
  private func setupUI() {
    view.backgroundColor = .green
  }
  
  private func timeCutdown() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
      guard let self else { return }
      self.switchRootController()
    }
  }
  
  private func switchRootController() {
    let window = UIApplication.shared.windows.first!
      
    UIView.transition(with: window,
                      duration: 0.5,
                      options: .transitionCrossDissolve,
                      animations: {
                        let old = UIView.areAnimationsEnabled
                        UIView.setAnimationsEnabled(false)
                        window.rootViewController = MainTabBarController()
                        UIView.setAnimationsEnabled(old)

                      }, completion: { _ in
                        // Do Nothing
                      })
  }
}
