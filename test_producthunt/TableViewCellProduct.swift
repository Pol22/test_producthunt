//
//  TableViewCellProduct.swift
//  test_producthunt
//
//  Created by Admin on 11.08.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class TableViewCellProduct: UITableViewCell {
    


    @IBOutlet var descript: UILabel?
    @IBOutlet var name: UILabel?
    @IBOutlet var thumbnail: UIImageView?
    @IBOutlet var upvotes: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
