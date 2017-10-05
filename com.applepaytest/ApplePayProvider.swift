//
//  ApplePayProvider.swift
//  MyFamily
//
//  Created by Arbi Derhartunian on 5/25/17.
//
//

import UIKit
import PassKit



enum shippingtype {
    case Delivered
    case Electronic
    
}



protocol LZProduct {
    var name: String { get set }
    var price: NSDecimalNumber { get set }
}

protocol ApplePayDelegate:class{
    func applePayPurchaseSuccessful()
    func applePayPurchaseFailed()
    
}

protocol ApplePayPresenter{
    
    func presentApplePayPopup(applePayViewController:UIViewController)
    
}


struct LZPhysicalProduct: LZProduct {
    var name: String
    var price: NSDecimalNumber
    var requiredAddressField: PKAddressField = [PKAddressField.all]
    var shippingCosts: NSDecimalNumber
    var shippingLabel: String
    var tax:NSDecimalNumber
}



enum Merchant {
    case vantive
    case paypal
    
    var supportedPaymentNetworks: [PKPaymentNetwork] {
        switch self {
        default:
            return [.visa, .masterCard, .amex, .privateLabel]
        }
    }
    
    var identifier: String {
        switch self {
        default:
            return "merchant.com.applepaytest1"
        }
    }
    
    var capabilities: [PKMerchantCapability] {
        switch self {
        default:
            return [.capability3DS]
        }
    }
}



struct CustomerData{
    
    var firstName:String
    var lastName:String
    var addressLine1:String
    var addressLine2:String
    var city:String
    var state:String
    var countryCode:String
    var currencyCode:String
    var phoneNumber:String
    
}



class ApplePayProvider: NSObject {
 

    public  var merchantType:Merchant
    public  weak var applePayDelegate:ApplePayDelegate?
            var token:PKPaymentToken?
    
    public func getAllAvailableProducts()->[LZPhysicalProduct]{
    
        let product = LZPhysicalProduct(name: "test", price: 2.0, requiredAddressField: [PKAddressField.all], shippingCosts: 3.0, shippingLabel: "shipping", tax: 2.0)
        let products : [LZPhysicalProduct] = [product]
        
        return products
    }
    
   init(merchantType:Merchant) {
        
        self.merchantType = merchantType
        super.init()
    }
    
    
    func purchase(presenter: ApplePayPresenter, product: LZPhysicalProduct, customer: CustomerData)
    {
        
        let paymentRequest =  PKPaymentRequest()
        
            paymentRequest.merchantIdentifier = merchantType.identifier
            paymentRequest.supportedNetworks = merchantType.supportedPaymentNetworks
            if let capability = merchantType.capabilities.first{
                paymentRequest.merchantCapabilities = capability
            }
            paymentRequest.countryCode = customer.countryCode
            paymentRequest.currencyCode = customer.currencyCode
            paymentRequest.paymentSummaryItems = [
                PKPaymentSummaryItem(label: product.name , amount: product.price),
                PKPaymentSummaryItem(label: product.shippingLabel, amount: product.shippingCosts),
                PKPaymentSummaryItem(label: product.name, amount: (product.shippingCosts.adding(product.price)))
            ]
            paymentRequest.requiredShippingAddressFields = product.requiredAddressField
        
            let applePayController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            applePayController.delegate = self
            presenter.presentApplePayPopup(applePayViewController: applePayController)
    
    }
    

}

extension ApplePayProvider: PKPaymentAuthorizationViewControllerDelegate{

    
   
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
    
            completion(PKPaymentAuthorizationStatus.success)
            token = payment.token
            applePayDelegate?.applePayPurchaseSuccessful()
//        Your native iOS application sends the PKPaymentToken to our secure server via an HTTPS POST (see Vantiv Mobile API for Apple Pay HTTPS POST Components) and eProtect returns a PayPage Registration ID.
//        Your native iOS application forwards the transaction data along with the eProtect Registration ID to your order processing server, as it would with any eProtect transaction.
        
    
    }
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        
        //I have to make the token instance variable to catch the failed
        guard self.token != nil else{
            applePayDelegate?.applePayPurchaseFailed()
            return
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        completion(PKPaymentAuthorizationStatus.success, [PKPaymentSummaryItem()])
    }
    
    
}


extension UIViewController: ApplePayPresenter
{
    
    func presentApplePayPopup(applePayViewController: UIViewController) {
        
        present(applePayViewController, animated: true, completion: nil)
    }
    
}


