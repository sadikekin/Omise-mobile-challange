//
//  CharityListVC.swift
//  Omise-mobil-challange
//
//  Created by Sadik Ekin Ozbay on 13.02.2018.
//  Copyright © 2018 Sadik Ekin Ozbay. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CharityListVC: BaseVC, UITableViewDelegate, UITableViewDataSource{
    var tableView: UITableView = {
        let tView = UITableView()
        tView.register(CharityTableViewCell.self, forCellReuseIdentifier: "cell")
        tView.rowHeight = CGFloat(76.0)
        return tView
    }()
    
    var charity = [Charity]()

    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Which charity would you like to donate?"
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = UIFont(name: "Futura", size: 30.0)
        return label
    }()
    
    override func fetchData() {
        tableView.delegate = self
        tableView.dataSource = self
        
        Alamofire.request(baseURL+"charities").responseJSON { response in
            if let json = response.result.value {
                let jsonKSwift = JSON(json)
                let jsonSwiftData = jsonKSwift["data"]
                var i = 0
                // While data is not null append values to charity array that will be used for tableview
                while(jsonSwiftData[i] != JSON.null){
                    let tempCharity = Charity(id: jsonSwiftData[i]["id"].stringValue, name: jsonSwiftData[i]["name"].stringValue, imageURL: jsonSwiftData[i]["logo_url"].stringValue)
                    self.charity.append(tempCharity)
                    i += 1
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = .white
    }
    
    override func setupAnchors() {
        _ = nameLabel.anchor(self.view.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 12, leftConstant: 6, bottomConstant: 0, rightConstant: 6, widthConstant: 0, heightConstant: 128)
        _ = tableView.anchor(nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 6, bottomConstant: 0, rightConstant: 6, widthConstant: 0, heightConstant: self.view.frame.height*3/4)
    }
    
    override func setupViews() {
        self.view.addSubview(nameLabel)
        self.view.addSubview(tableView)
        tableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return charity.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CharityTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "cell") as! CharityTableViewCell
        //Assigning values to custom cell
        cell.nameLabel.text = "\(charity[indexPath.row].name)"
        let url = URL(string: charity[indexPath.row].imageURL)
        let data = try? Data(contentsOf: url!)
        cell.LogoView.image = UIImage(data: data!)
        
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 0.1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let donationVC = DonationVC()
        donationVC.charity = charity[indexPath.item]
        self.present(donationVC, animated: true, completion: nil)
    }

}
