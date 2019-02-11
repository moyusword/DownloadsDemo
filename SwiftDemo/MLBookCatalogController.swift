//
//  MLBookCatalogController.swift
//  SwiftDemo
//
//  Created by Chivalrous on 2019/1/22.
//  Copyright © 2019 ML. All rights reserved.
//

import UIKit

class MLBookCatalogController: UIViewController {
    
    var htmlURL: String?
    var completion: ((_ htmlURL: String) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "目录"
        configView()
    }
    
    //MARK: -- lazy
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: .plain)
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "CatalogCell", bundle: nil), forCellReuseIdentifier: "CatalogCell")
        return tableView
    }()
}

extension MLBookCatalogController {
    
    //MARK: -- configView
    private func configView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        request()
    }
    
    //MARK: -- 获取目录
    private func request() {
        guard let htmlURLStr = htmlURL else { return }
        guard let url = URL.init(string: htmlURLStr) else {
            print("生成url失败")
            return
        }
        print("开始请求数据")
        do {
            let bookDict = NSMutableDictionary()
            let htmlData = try Data.init(contentsOf: url)
            let document = try ONOXMLDocument.htmlDocument(with: htmlData)
            //获取文章目录
            let catalogElement = document.firstChild(withXPath: "/html/body/div[6]")
            print(catalogElement?.attributes)
        } catch {
            print("内部错误")
        }
            
    }
}

//MARK: -- delegate
extension MLBookCatalogController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.estimatedRowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogCell") as! CatalogCell
        
        return cell
    }
}
