//
//  MineViewModel.swift
//  TestApp
//
//  Created by wangxu on 2024/7/10.
//

import Foundation

/*
    本身是想尝试一些复杂页面搭建 写着写着发现UITableView倒是能解决绝大多数的界面搭建
    大概分为两个结构
    1. SectionModel 里面带着reuseIdentifier/高度/cellModels等信息
    2. CellModel 里面也带着reuseIdentifier/高度/等需要的数据
    不管什么界面结构都可以一个Sections就一个row 
        用sectionModel.reuseIdentifier找到需要的那一个cell
        而这个row的数据是[cellModels] 用这个cellModels来在上一步的cell中进一步搭建UITableView / UICollectionView
 
    只想到这里 没实践
 */

class MixCell4TableView: UITableViewCell {
    var sectionModel: Section = .init()
    var tableView: UITableView = .init(frame: .zero, style: .plain)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.masksToBounds = true
        selectionStyle = .none
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.register(MixSubCell.self, forCellReuseIdentifier: NSStringFromClass(MixSubCell.self))
        tableView.layer.cornerRadius = 10
        tableView.layer.masksToBounds = true
        addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(model: Section) {
        self.sectionModel = model
        self.tableView.reloadData()
    }
}

extension MixCell4TableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        sectionModel.items[indexPath.row].height
    }
}

extension MixCell4TableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sectionModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sectionModel.items[indexPath.row]
        let cell = MixSubCell(style: .value1, reuseIdentifier: NSStringFromClass(MixSubCell.self))
        cell.backgroundColor = .clear
        cell.configureCell(model: model)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
}

class MixSubCell: UITableViewCell {
    private var cellModel: CellModel = .init()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.textAlignment = .center
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
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(12)
            make.centerY.height.equalToSuperview()
        }
    }
    
    func configureCell(model: CellModel) {
        self.cellModel = model
        titleLabel.text = model.title
    }
}

class Section: NSObject {
    var items: [CellModel] = []
    var height: CGFloat = 0
    
    func appendItems(_ items: [CellModel]) {
        self.items.append(contentsOf: items)
    }
}

class CellModel: NSObject {
    var height: CGFloat = 0
    var title: String = ""
}

final class MixViewModel: NSObject {
    private var sections: [Section] = []
    
    func appendSections(_ sections: [Section]) {
        self.sections.append(contentsOf: sections)
    }
    
    func removeAllSections() {
        sections.removeAll()
    }
}

extension MixViewModel: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        sections[indexPath.section].height
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = sections[indexPath.section]
        let cell = MixCell4TableView(style: .default, reuseIdentifier: NSStringFromClass(MixCell4TableView.self))
        cell.configureCell(model: model)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .clear
        return footer
    }
}
