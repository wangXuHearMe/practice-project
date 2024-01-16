//
//  UIView + Touch.swift
//  TestApp
//
//  Created by wangxu on 2024/1/15.
//

import Foundation

public typealias TouchClosure = (UIView) -> Void

public extension NSObject {
  func setAssociated<T>(
    value: T,
    associatedKey: UnsafeRawPointer,
    policy: objc_AssociationPolicy = .OBJC_ASSOCIATION_RETAIN_NONATOMIC
  ) {
    objc_setAssociatedObject(self, associatedKey, value, policy)
  }

  func getAssociated<T>(associatedKey: UnsafeRawPointer) -> T? {
    let value = objc_getAssociatedObject(self, associatedKey) as? T
    return value
  }
}

extension UIView {
  private enum AssociatedKeys {
    static var touchKey = "touch_key"
    static var doubleTouchKey = "double_touch_key"
    static var longPressTouchKey = "long_press_touch_key"
  }

  @discardableResult
  public func setupTouch(cancelsTouchesInView: Bool = true, _ closure: @escaping TouchClosure) -> UITapGestureRecognizer {
    isUserInteractionEnabled = true
    let tap = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
    tap.cancelsTouchesInView = cancelsTouchesInView
    addGestureRecognizer(tap)
    setAssociated(
      value: closure,
      associatedKey: &AssociatedKeys.touchKey,
      policy: .OBJC_ASSOCIATION_COPY_NONATOMIC
    )
    return tap
  }

  @objc func onTap(sender: UITapGestureRecognizer) {
    if let touch: TouchClosure = getAssociated(associatedKey: &AssociatedKeys.touchKey) {
      touch(self)
    }
  }
}
