//
//  CollectionViewManager.swift
//  TestApp
//
//  Created by wangxu on 2024/7/8.
//

import Foundation

public class CollectionViewManager: NSObject {
    var collectionView: UICollectionView
    var layout: UICollectionViewFlowLayout = .init()
    
    var sections: [CollectionViewSection] = []
    
    public init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
        configure()
    }
    
    public init(direction: UICollectionView.ScrollDirection) {
        layout.scrollDirection = direction
        collectionView = .init(frame: .zero, collectionViewLayout: layout)
        super.init()
        configure()
    }
    
    private func configure() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    public func append(sections: [CollectionViewSection]) {
        self.sections.append(contentsOf: sections)
    }
    
    public func register(_ cellClass: AnyClass, modelClass: AnyClass) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: NSStringFromClass(modelClass))
    }
    
    public func reloadData() {
        collectionView.reloadData()
    }
    
    public func reloadItems(at indexPath: [IndexPath]) {
        collectionView.reloadItems(at: indexPath)
    }
    
    public func removeAll() {
        sections.removeAll()
        sections = []
    }
}

extension CollectionViewManager: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = sections[indexPath.section].items[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: model.reuseIdentifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configureCell(model: model, indexPath: indexPath)
        return cell
    }
}

extension CollectionViewManager: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
}

extension CollectionViewManager: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        sections[section].minimumLineSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        sections[section].minimumInteritemSpacing
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        sections[section].inset
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        sections[indexPath.section].items[indexPath.row].size
    }
}

public class CollectionViewSection {
    var items: [CollectionViewItem] = []
    open var minimumLineSpacing: CGFloat = 0
    open var minimumInteritemSpacing: CGFloat = 0
    open var inset: UIEdgeInsets = .zero
    
    public func append(items: [CollectionViewItem]) {
        self.items.append(contentsOf: items)
    }
    
    public func removeAll() {
        items.removeAll()
    }
}

public class CollectionViewItem {
    var reuseIdentifier: String
    var size: CGSize = .zero
    
    weak var sectionModel: CollectionViewSection?
    
    public init() {
        reuseIdentifier = NSStringFromClass(Self.self)
    }
}
