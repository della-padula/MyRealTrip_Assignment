//
//  ViewController.swift
//  NewsList_MRT
//
//  Created by TaeinKim on 2020/03/16.
//  Copyright © 2020 TaeinKim. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    @IBOutlet weak var imageNewspaper: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.imageNewspaper.image = UIImage(named: "newspaper")?.withAlignmentRectInsets(UIEdgeInsets(top: -5, left: -5, bottom: -5, right: -5))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            var navigationVC : UINavigationController?
            navigationVC = (UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "navVC") as! UINavigationController)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = navigationVC
        }
    }
    
}

