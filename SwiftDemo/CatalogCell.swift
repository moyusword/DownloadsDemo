//
//  CatalogCell.swift
//  SwiftDemo
//
//  Created by Chivalrous on 2019/1/22.
//  Copyright © 2019 ML. All rights reserved.
//

import UIKit

class CatalogCell: UITableViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    func initCatalog(title: String) {
        self.titleLbl.text = title
    }
}
