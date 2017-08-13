//
//  ProductDetailViewController.swift
//  test_producthunt
//
//  Created by Admin on 12.08.17.
//  Copyright © 2017 Admin. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    var product: Product?
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var upvotes: UILabel!
    @IBOutlet weak var descript: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = product?.name
        let url = URL(string: (product?.screenshot_url)!)
        let data = try? Data(contentsOf: url!)
        var img = UIImage(data: data!)
        img = UIImage(cgImage: (img?.cgImage)!, scale: (img?.size.width)! / 414.0, orientation: (img?.imageOrientation)!)
        image.image = img
        upvotes.text = product?.upvotes
        descript.text = product?.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openUrl(_ sender: AnyObject) {
        UIApplication.shared.open((product?.url)!, options: [:], completionHandler: nil)
    }

}
