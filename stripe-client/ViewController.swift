//
//  ViewController.swift
//  stripe-client
//
//  Created by Ian MacFarlane on 8/18/17.
//  Copyright © 2017 Ian MacFarlane. All rights reserved.
//

import UIKit
import Stripe
import Alamofire

class ViewController: UIViewController, STPPaymentCardTextFieldDelegate {

    @IBOutlet var payButton: UIButton!
    
    let paymentTextField = STPPaymentCardTextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // paymentTextField.frame = CGRect(15, 199, self.view.frame.width - 30, 44)
        paymentTextField.frame = CGRect(x: 15, y: 199, width: self.view.frame.width - 30, height: 44)
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
        self.payButton.isHidden = true
        
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        if textField.isValid {
            self.payButton.isHidden = false
        }
    }
    
    @IBAction func payButtonPressed(_ sender: Any) {
        
        let card = paymentTextField.cardParams
        
        STPAPIClient.shared().createToken(withCard: card) { (token, error) in
            if let error = error {
                print(error)
            } else if let token = token {
                print(token)
                self.chargeUsingToken(token: token)
            }
        }
    }
    
    func chargeUsingToken(token: STPToken) {
        let requestString = DeveloperParameters.StripeParameters.requestString
        let parameters = ["stripeToken": token.tokenId, "amount": "200", "currency": "usd", "description": "testRun"]
        
        Alamofire.request(requestString, method: .post, parameters: parameters).responseJSON { response in
            if let request = response.request {
                print(request)
            }
            
            if let response = response.response {
                print(response)
            }
            
            if let data = response.data {
                print(data)
            }
            
            print(response.result)
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }

}

