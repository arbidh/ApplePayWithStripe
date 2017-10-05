//
//  BuyViewController.swift
//  com.applepaytest
//
//  Created by Arbi Derhartunian on 4/27/17.
//  Copyright © 2017 Arbi Derhartunian. All rights reserved.
//

import UIKit
import PassKit
import Stripe
import StoreKit


enum LAPTYPE {
    case Delivered
    case Electronic
    
}

class BuyViewController: UIViewController {


//    let supportedPaymentNetwork = [PKPaymentNetwork.visa,.masterCard,.amex, PKPaymentNetwork.privateLabel]
//    let applepaytestMerchantID = "merchant.com.applepaytest1"
//
   @IBOutlet weak var appTitle: UILabel!
    @IBOutlet weak var applepayButton: UIButton!
    @IBOutlet weak var price: UILabel!
        let applePayProvider = ApplePayProvider(merchantType: .vantive)
//    let priceline:NSDecimalNumber = 7.99
//    let productTitle:String = "LAP"
//    let lapType:LAPTYPE = .Delivered
    @IBAction func buyme(_ sender: Any) {
//        requestPayment()
        applePayProvider.applePayDelegate = self
        let product =  applePayProvider.getAllAvailableProducts().first
        let customerData = CustomerData(firstName: "testUser", lastName: "username", addressLine1: "", addressLine2: "", city: "", state: "", countryCode: "US", currencyCode: "USD", phoneNumber: "")
        if let product = product{
            applePayProvider.purchase(presenter: self, product: product, customer: customerData)
        }
//
   }
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        
//            STPPaymentConfiguration.shared().appleMerchantIdentifier = "merchant.com.applepaytest1"
//        applepayButton.isHidden = !PKPaymentAuthorizationViewController.canMakePayments(usingNetworks:supportedPaymentNetwork)
//        // Do any additional setup after loading the view.
    }
    
    func presentApplePayPopup(applePayViewController: UIViewController, request:PKPaymentRequest) {
        
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayController.delegate = applePayProvider
        self.present(applePayController, animated: true, completion: nil)
        
    }
    
    
//    
//    func requestPayment(){
//        
//        let paymentRequest =  PKPaymentRequest()
//        paymentRequest.merchantIdentifier = applepaytestMerchantID
//        paymentRequest.supportedNetworks = supportedPaymentNetwork
//        paymentRequest.merchantCapabilities = PKMerchantCapability.capability3DS
//        paymentRequest.countryCode = "US"
//        paymentRequest.currencyCode = "USD"
//        paymentRequest.paymentSummaryItems = [
//        PKPaymentSummaryItem(label: "LAP", amount: 7.99),
//        PKPaymentSummaryItem(label: "Shipping", amount: 2.99),
//        PKPaymentSummaryItem(label: productTitle, amount: priceline)
//        
//
//        ]
//        
//        switch lapType {
//        case .Delivered:
//            paymentRequest.requiredShippingAddressFields = [PKAddressField.postalAddress,PKAddressField.phone]
//        case .Electronic:
//            paymentRequest.requiredShippingAddressFields = PKAddressField.email
//            
//        }
//        
//        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
//        applePayController.delegate = self
//        self.present(applePayController, animated: true, completion: nil)
//        
//    }
//    
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension BuyViewController: ApplePayDelegate{
    
    
    func applePayPurchaseFailed() {
        
    }
    
    func applePayPurchaseSuccessful() {
        
    }
    
    
}

//extension BuyViewController: PKPaymentAuthorizationViewControllerDelegate{
//    
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
//        
//        //comment TODO:
//       // Your native iOS application sends the PKPaymentToken to our secure server via an HTTPS POST (see Vantiv Mobile API for Apple Pay HTTPS POST Components) and eProtect returns a PayPage Registration ID.
//        //Your native iOS application forwards the transaction data along with the eProtect Registration ID to your order processing server, as it would with any eProtect transaction.
//        
//           completion(PKPaymentAuthorizationStatus.success)
//        
//        
//    }
//    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
//        
//        controller.dismiss(animated: true, completion: nil)
//        
//        
//    }
//    
//    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
//        
//        completion(PKPaymentAuthorizationStatus.success, [PKPaymentSummaryItem()])
//    }
//
//    
//    
//}


