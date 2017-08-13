//
//  ViewController.swift
//  test_producthunt
//
//  Created by Admin on 10.08.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

let access_token = "591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"

struct Product {
    var name: String?
    var description: String?
    var upvotes: String?
    var url: URL?
    var screenshot_url: String?
    var thumbnail: UIImage?
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var productsTable: UITableView!
    @IBOutlet weak var menuTitle: UIBarButtonItem!
    @IBOutlet weak var categoryTable: UITableView!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var categories_list = ["Tech"]
    var product_list = [Product]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView.tag == 202 {
            return product_list.count
        } else {
            return categories_list.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 202 {
            let cell = Bundle.main.loadNibNamed("TableViewCellProduct", owner: self, options: nil)?.first as! TableViewCellProduct
            let product = product_list[indexPath.section]
            cell.name?.text = product.name
            cell.descript?.text = product.description
            cell.upvotes?.text = product.upvotes
            cell.thumbnail?.image = product.thumbnail
            cell.layer.borderWidth = 2.0
            cell.layer.borderColor = UIColor.gray.cgColor
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) 
            cell.textLabel?.text = categories_list[indexPath.section]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.tag == 201 {
            menuTitle.title = categories_list[indexPath.section]
            getProductsTo(category: categories_list[indexPath.section], withAnimation: true)
            UIView.animate(withDuration: 0.5, animations: {
                self.categoryTable.center.y -= self.view.bounds.height
            })
        } else {
            performSegue(withIdentifier: "showDetail", sender: tableView.cellForRow(at: indexPath))
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.tag == 202 {
            return 160.0 //product cell height
        } else {
            return 30.0 //category cell height
        }
    }
    
    
    @IBAction func showCategories(_ sender: AnyObject) {
        if self.categoryTable.center.y < 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.categoryTable.center.y += self.view.bounds.height
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.categoryTable.center.y -= self.view.bounds.height
            })
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            switch identifier {
                case "showDetail":
                    let productDetailVC = segue.destination as! ProductDetailViewController
                    let indexPath = self.productsTable.indexPath(for: sender as! UITableViewCell)
                    productDetailVC.product = self.product_list[(indexPath?.section)!]
                default: break
            }
        }
        
    }
    
    func getProductsTo(category: String, withAnimation: Bool) {
        if withAnimation {
            loading.startAnimating()
        }
        //productsTable.reloadData()
        let parameters: Parameters = ["access_token": access_token]
        Alamofire.request("https://api.producthunt.com/v1/categories/" + category.lowercased() + "/posts", parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                self.product_list.removeAll()
                let json = JSON(data: response.data!)
                for (_, val) in json["posts"] {
                    let url = URL(string: val["thumbnail"]["image_url"].string!)
                    let data = try? Data(contentsOf: url!)
                    var img = UIImage(data: data!)
                    img = UIImage(cgImage: (img?.cgImage)!, scale: (img?.size.width)! / 112.0, orientation: (img?.imageOrientation)!)
                    let screen_url = val["screenshot_url"]["300px"].string!
                    let data_name = val["name"].string!
                    let data_description = val["tagline"].string!
                    let data_upvotes = String(val["votes_count"].int!)
                    let data_url = URL(string: val["redirect_url"].string!)
                    let product_data = Product(name: data_name, description: data_description, upvotes: data_upvotes, url: data_url, screenshot_url: screen_url, thumbnail: img)
                    self.product_list.append(product_data)
                }
            }
            self.productsTable.reloadData()
            if withAnimation {
                self.loading.stopAnimating()
            }
            self.productsTable.refreshControl?.endRefreshing()
        }
    }
    
    func refreshProductData(_ sender: Any) {
        getProductsTo(category: menuTitle.title!, withAnimation: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshProductData(_:)), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Loading topics ...")
        productsTable.refreshControl = refreshControl
        
        productsTable.delegate = self
        productsTable.dataSource = self
        categoryTable.delegate = self
        categoryTable.dataSource = self
        
        categoryTable.center.y -= self.view.bounds.height
        
        let parameters: Parameters = ["access_token": access_token]
        Alamofire.request("https://api.producthunt.com/v1/categories", parameters: parameters).responseJSON { response in
            if response.result.isSuccess {
                let json = JSON(data: response.data!)
                self.categories_list.removeAll()
                for (_, val) in json["categories"] {
                    self.categories_list.append(val["name"].string!)
                }
                
                self.categoryTable.reloadData()
            }
        }
        
        getProductsTo(category: "Tech", withAnimation: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

