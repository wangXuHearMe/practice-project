//
//  MineViewController.swift
//  TestApp
//
//  Created by wangxu on 2024/1/12.
//

import Foundation
import UIKit
import SnapKit
import IGListKit

final class MixViewController: ViewController {
    private var viewModel: MixViewModel = .init()
    
    private var tableView: UITableView = .init(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        view.backgroundColor = .lightGray
        tableView.separatorStyle = .none
        tableView.delegate = viewModel
        tableView.dataSource = viewModel
        tableView.register(MixCell4TableView.self, forCellReuseIdentifier: NSStringFromClass(MixCell4TableView.self))
    }
    
    private func setupData() {
        viewModel.removeAllSections()
        
        let section1: Section = .init()
        
        let model1 = CellModel()
        model1.height = 50
        model1.title = "iPhoto存储空间"
        let model2 = CellModel()
        model2.height = 50
        model2.title = "后台App刷新"
        section1.height = 100
        section1.appendItems([model1, model2])
        
        let section2: Section = .init()
        
        let model3 = CellModel()
        model3.height = 50
        model3.title = "日期与时间"
        
        let model4 = CellModel()
        model4.height = 50
        model4.title = "键盘"
        section2.appendItems([model3, model4])
        section2.height = 100
        viewModel.appendSections([section1, section2])
        
        tableView.reloadData()
    }

    private func setupUI() {
        view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.snp.makeConstraints { make in
            make.height.top.equalToSuperview().offset(40)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().offset(-16)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupData()
    }
}
