//
//  ViewController.swift
//  Apply
//
//  Created by QianTuFD on 2017/3/28.
//  Copyright © 2017年 fandy. All rights reserved.
//

import UIKit



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNav()
        
    }
    
    
    func setupNav() {
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: FONT_36PX]
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bj"), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    

    @IBAction func 我要申请(_ sender: UIButton) {
        
        // 自己填写的
        
//        let aapp = MyselfApplyViewController()
//        navigationController?.pushViewController(aapp, animated: true)
        AuthorizationManager.configure { (configuration) in
            configuration.title = "哈哈哈"
            configuration.message = "hahahahaha"
            configuration.presentingViewController = self
        }.authorizedContacts {
            let aapp = MyselfApplyViewController()
            self.navigationController?.pushViewController(aapp, animated: true)
        }
    }

    @IBAction func 帮人申请(_ sender: UIButton) {
        // 带有默认值转
//        let aapp = NextViewController()
//        navigationController?.pushViewController(aapp, animated: true)
    }
}

