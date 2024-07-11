//
//  Cells.swift
//  TestApp
//
//  Created by wangxu on 2024/1/17.
//

import Foundation
import SnapKit
import IGListKit
import UIKit

public protocol CellType {
    associatedtype CellModel

    var cellmodel: CellModel? { get }
}

public extension CellType where Self: CollectionViewCell {
    var cellmodel: CellModel? {
        return _cellmodel as? CellModel
    }
}

public class CollectionViewCell: UICollectionViewCell {
    var _cellmodel: Any?
    var indexPath: IndexPath = .init(row: 0, section: 0)
    
    public func configureCell(model: Any, indexPath: IndexPath) {
        _cellmodel = model
        self.indexPath = indexPath
        configure()
    }
    
    public func configure() {}
}
