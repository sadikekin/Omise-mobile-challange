//
//  DonationVC.swift
//  Omise-mobil-challange
//
//  Created by Sadik Ekin Ozbay on 15.02.2018.
//  Copyright © 2018 Sadik Ekin Ozbay. All rights reserved.
//

import UIKit
import OmiseSDK
import Alamofire

class DonationVC: BaseVC, CreditCardFormDelegate{
    
    var charity: Charity!
    
    private let publicKey = "pkey_test_5ayztv3t3nxkzyu2cm7"
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = charity.name
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.numberOfLines = 3
        label.addShadow()
        label.font = UIFont(name: "Futura", size: 30.0)
        return label
    }()
    
    lazy var imageView : UIButton = {
        let view = UIButton()
        view.setImage(UIImage(named: "Close"), for: .normal)
        view.addShadow()
        view.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        return view
    }()
    
    lazy var payButton : UIButton = {
        let view = UIButton()
        view.backgroundColor =  UIColor(red: 150.0/255.0, green: 82.0/255.0, blue: 126.0/255.0, alpha: 1)
        view.addShadow()
        view.setTitle("Pay", for: .normal)
        view.titleLabel?.font = UIFont(name: "Futura", size: 24)
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(didTapCheckout), for: .touchUpInside)
        view.layer.cornerRadius = 4
        return view
    }()
    
    lazy var amountInput: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderWidth = 0.2
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 4
        view.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
        view.addShadow()
        view.keyboardType = .numberPad
        
        // Adding image to left side
        view.leftViewMode = UITextFieldViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        let image = UIImage(named: "Baht")
        imageView.image = image
        view.leftView = imageView
        return view
    }()
    
    
    override func setupViews() {
        self.view.addSubview(nameLabel)
        self.view.addSubview(imageView)
        self.view.addSubview(payButton)
        self.view.addSubview(amountInput)
    }
    
    override func setupAnchors() {
        _ = imageView.anchor(self.view.topAnchor, left: nil, bottom: nil, right: self.view.rightAnchor, topConstant: 36, leftConstant: 0, bottomConstant: 0, rightConstant: 24, widthConstant: 64, heightConstant: 64)
        _ = nameLabel.anchor(self.imageView.bottomAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 6, leftConstant: 6, bottomConstant: 0, rightConstant: 6, widthConstant: 0, heightConstant: 128)
        _ = payButton.anchor(nil, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 36, bottomConstant: self.view.frame.height/6, rightConstant: 36, widthConstant: 0, heightConstant: 72)
        _ = amountInput.anchor(nil, left: self.view.leftAnchor, bottom: self.payButton.bottomAnchor, right: self.view.rightAnchor, topConstant: 0, leftConstant: 36, bottomConstant: self.view.frame.height/5, rightConstant: 36, widthConstant: 0, heightConstant: 72)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.backgroundColor = .white
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @objc func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapCheckout() {
        if(amountInput.text == ""){
            let errorAlert = UIAlertController(title: "Error", message: "Donation amount can not be empty", preferredStyle: .alert)
            errorAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(errorAlert, animated: true, completion: nil)
        }else{
            let closeButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didTapCloseForm))
            
            let creditCardForm = CreditCardFormController.makeCreditCardForm(withPublicKey: publicKey)
            creditCardForm.delegate = self
            creditCardForm.navigationItem.rightBarButtonItem = closeButton
            
            let navigationController = UINavigationController(rootViewController: creditCardForm)
            present(navigationController, animated: true, completion: nil)
        }
    }
    
    @objc func didTapCloseForm() {
        presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func creditCardForm(_ controller: CreditCardFormController, didSucceedWithToken token: OmiseToken) {
        didTapCloseForm()
        
        let givenParamaters = [
            "name": token.card?.name ?? "",
            "token": token.tokenId ?? "",
            "amount": amountInput.text ?? ""
        ]
        
        Alamofire.request(baseURL+"donations", method:.post, parameters:givenParamaters).responseJSON { response in
            switch response.result {
            case .success:
                print(response)
                
            case .failure(let error):
                print(error)
            }
            
        }
        
        let successAlert = UIAlertController(title: "Succes", message: "Your donation is on the way", preferredStyle: .alert)
        successAlert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        present(successAlert, animated: true, completion: nil)
    }
    
    func creditCardForm(_ controller: CreditCardFormController, didFailWithError error: Error) {
        didTapCloseForm()
        print("error: \(error)")
        
        let alert = UIAlertController(title: "Error", message: "Something bad happened", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
    }

}
