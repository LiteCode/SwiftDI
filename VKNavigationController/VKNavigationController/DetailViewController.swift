//
//  DetailViewController.swift
//  VKNavigationController
//
//  Created by v.a.prusakov on 08/07/2019.
//  Copyright © 2019 Vladislav Prusakov. All rights reserved.
//

import UIKit

class DetailViewController: CommonViewController {
    
    override var navigationBarTintColor: UIColor {
        return .white
    }
    
    override var navigationBarStyle: UIBarStyle {
        return .black
    }
//
//    open override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onClose() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        } else {
            self.dismiss(animated: true)
        }
    }


}

