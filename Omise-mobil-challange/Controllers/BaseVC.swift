//
//  CharityListVC.swift
//  Omise-mobil-challange
//
//  Created by Sadik Ekin Ozbay on 13.02.2018.
//  Copyright © 2018 Sadik Ekin Ozbay. All rights reserved.
//

import UIKit

class BaseVC: UIViewController, UINavigationControllerDelegate  {
    
    let baseURL = "https://virtserver.swaggerhub.com/chakritw/tamboon-api/1.0.0/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.delegate = self
        self.hideKeyboardWhenTappedAround()
        fetchData()
        setupViews()
        setupAnchors()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    // It is responsible for creating the views
    func setupViews(){
        
        
    }
    
    // It is responsible for setting up the anchors
    func setupAnchors(){
        
        
    }
    
    //API works will be in this function
    func fetchData(){
        
        
        
    }


}

