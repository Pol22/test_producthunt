//
//  ProductsView.swift
//  test_producthunt
//
//  Created by Admin on 11.08.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ProductsView: UITableView {

    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        let cell = TableViewCellProduct()
        cell.Name.text = "123"
        cell.Description.text = "12523456789876543d4s5f67asdas3d4a56g789s0sg876as3a4f56"
        cell.Upvotes.text = "12342"
        // Configure the cell...
        
        return cell
    }
    
    
    override func numberOfRows(inSection section: Int) -> Int {
        return 1
    }

}
