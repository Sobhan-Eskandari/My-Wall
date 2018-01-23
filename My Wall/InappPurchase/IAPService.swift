//
//  IAPService.swift
//  My Wall
//
//  Created by Sobhan Eskandari on 1/21/18.
//  Copyright © 2018 Sobhan Eskandari. All rights reserved.
//

import Foundation
import StoreKit
import SVProgressHUD

class IAPService: NSObject {
    
    private override init() {}
    static let shared = IAPService()
    
    var products = [SKProduct]()
    let paymentQueue = SKPaymentQueue.default()
    
    func getProducts() {
        let products:Set = [IAPProduct.ForeverPlan.rawValue,
                            IAPProduct.MonthlyPlan.rawValue,
                            IAPProduct.SixMonthsPlan.rawValue,
                            IAPProduct.YearlyPlan.rawValue]
    
        let request = SKProductsRequest(productIdentifiers: products)
        request.delegate = self
        request.start()
        paymentQueue.add(self)
    }
    
    func purchase(product: IAPProduct) {
        guard let productToPurchase = products.filter({ $0.productIdentifier == product.rawValue }).first else { return }
        let payment = SKPayment(product: productToPurchase)
        paymentQueue.add(payment)
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
    }
    
    func restorePurchases() {
        print("restore purchases")
        paymentQueue.restoreCompletedTransactions()
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
    }
}

extension IAPService: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        products = response.products
        for product in response.products {
            print(product.localizedTitle)
        }
    }
}

extension IAPService: SKPaymentTransactionObserver{
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            print(transaction.transactionState.status(), transaction.payment.productIdentifier)
            switch transaction.transactionState{
            case .purchasing : break
            case .purchased :
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: "InappPurchaseBought")
                print("purchased successful")
                queue.finishTransaction(transaction)
                SVProgressHUD.dismiss()
            case.restored:
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: "InappPurchaseBought")
                print("restored successful")
                queue.finishTransaction(transaction)
                SVProgressHUD.dismiss()
                SVProgressHUD.showSuccess(withStatus: "Purchase restored successfully")
               
            default:
                SVProgressHUD.dismiss()
                queue.finishTransaction(transaction)
            }
        }
    }
}


extension SKPaymentTransactionState {
    func status() -> String {
        switch self {
        case .deferred: return "deferred"
        case .failed: return "failed"
        case .purchased: return "purchased"
        case .purchasing: return "purchasing"
        case .restored: return "restored"
        }
    }
}
