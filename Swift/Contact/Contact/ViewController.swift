//
//  ViewController.swift
//  Contact
//
//  Created by QianTuFD on 2017/5/8.
//  Copyright © 2017年 fandy. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var contactsIndexTitles: ContactsIndexTitles = ([String](), [String: [PersonPhoneModel]]())
    
    var indexTitles: [String] {
        get {
            return contactsIndexTitles.0
        }
    }
    
    var contactsList: [String: [PersonPhoneModel]] {
        get {
            return contactsIndexTitles.1
        }
    }
    
    private let cellID = "cellID"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "人脉圈"
        // 请求数据更新UI
        
        // 模拟
        AuthorizationManager.config { (config) in
            config.title = "通讯录授权"
            config.message = "通讯录授权"
            config.presentingViewController = self
        }.authorizedContacts { (result) in
            switch result {
            case .success(let str):
                print(str)
                DispatchQueue.global().async {
                    let list = ContactsManager.getContactsList()
                    self.contactsIndexTitles = ContactsManager.format(contantsList: list)
                    // 添加加号
                    let add = "+"
                    self.contactsIndexTitles.0.insert(add, at: 0)
                    self.contactsIndexTitles.1[add] = [PersonPhoneModel(fullName: "添加手机联系人",
                                                                        phoneNumber: "",
                                                                        phoneLabel: "")]
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            case .failure(let e):
                print(e.description)
            }
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "同步联系人", style: .plain, target: self, action: #selector(syncContacts))
        

    }
    func syncContacts() {
        AuthorizationManager.config { (config) in
            config.title = "通讯录授权"
            config.message = "通讯录授权"
            config.presentingViewController = self
            }.authorizedContacts { (result) in
                switch result {
                case .success(let str):
                    print(str)
                    DispatchQueue.global().async {
                        let list = ContactsManager.getContactsList()
                        // 同步联系人到服务器 更新cell
                        
                        DispatchQueue.main.async {
                            // 返回数据处理更新数据
                            self.tableView.reloadData()
                        }
                    }
                case .failure(let e):
                    print(e.description)
                }
        }

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return contactsList.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let arr = contactsList[indexTitles[section]] else {
            return 0;
        }
        return arr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellID)
        }
        guard let arr = contactsList[indexTitles[indexPath.section]] else {
            return cell!;
        }
        
        if indexPath.section == 0 {
            cell?.accessoryType = .disclosureIndicator
        } else {
            cell?.accessoryType = .none
        }
        
        let personPhoneModel = arr[indexPath.row]
        
        cell?.textLabel?.text = personPhoneModel.fullName
        cell?.detailTextLabel?.text = personPhoneModel.phoneNumber
        cell?.imageView?.image = UIImage(named: "timg.jpeg")

        return cell!
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return indexTitles[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexTitles
    }

    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            /*
              找个地方做下处理 可以把通讯录直接传给下个控制器就可以不用一直读取和排序通讯录，提升性能
             */
            let addContactsViewController = AddContactsViewController()
            navigationController?.pushViewController(addContactsViewController, animated: true)
        }
    }
}

