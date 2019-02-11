//
//  MLBookShelfController.swift
//  SwiftDemo
//
//  Created by Chivalrous on 2019/1/22.
//  Copyright © 2019 ML. All rights reserved.
//

import UIKit

class MLBookShelfController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }
    
    private lazy var collectView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize = CGSize.init(width: (ML_MAX_WIDTH - 50) / 2, height: (ML_MAX_WIDTH - 50) / 2 + 15)
        let collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
}

extension MLBookShelfController {
    
    //MARK: -- configView
    private func configView() {
        view.addSubview(collectView)
        collectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

//MARK: -- delegate
extension MLBookShelfController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        cell.backgroundColor = .orange
        return cell
    }
}
