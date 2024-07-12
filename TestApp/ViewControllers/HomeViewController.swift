//
//  File.swift
//  TestApp
//
//  Created by wangxu on 2024/1/12.
//

import Foundation
import UIKit
import IGListKit
import SnapKit

/// 无论结局如何 我都 100% 投入

fileprivate class HomeCellDataSource {
    var title: String = ""
    var selectedBlock: (() -> Void)?
}

fileprivate class HomeCell: UITableViewCell {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
    }
    
    func configureCell(dataSource: HomeCellDataSource) {
        titleLabel.text = dataSource.title
    }
}

final class HomeViewController: BaseViewController {
    private var tableView: UITableView = .init(frame: .zero, style: .plain)
    
    private var dataSource: [HomeCellDataSource] = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = .zero
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeCell.self, forCellReuseIdentifier: NSStringFromClass(HomeCell.self))
        tableView.backgroundColor = .clear
        hidesBottomBarWhenPushed = true
        setupDataSource()
    }
    
    private func setupDataSource() {
        let dataSource1 = HomeCellDataSource()
        dataSource1.title = "复杂页面搭建尝试"
        dataSource1.selectedBlock = { [weak self] in
            guard let self else { return }
            let vc = MixViewController()
            vc.title = "复杂页面搭建尝试"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        dataSource.append(dataSource1)
        
        let dataSource2 = HomeCellDataSource()
        dataSource2.title = "手写板尝试"
        dataSource2.selectedBlock = { [weak self] in
            guard let self else { return }
            let vc = HandWritingViewController()
            vc.title = "手写板尝试"
            self.navigationController?.pushViewController(vc, animated: true)
        }
        dataSource.append(dataSource2)
        
        tableView.reloadData()
    }
  
    override func setupUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }
    }
  
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
  
    override func setupNavigationBar() {
        super.setupNavigationBar()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource[indexPath.row]
        let cell = HomeCell(style: .default, reuseIdentifier: NSStringFromClass(HomeCell.self))
        cell.configureCell(dataSource: model)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataSource[indexPath.row]
        model.selectedBlock?()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
 
