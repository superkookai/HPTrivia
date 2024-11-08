//
//  Store.swift
//  HPTrivia
//
//  Created by Weerawut Chaiyasomboon on 7/11/2567 BE.
//

import Foundation
import StoreKit

enum BookStatus{
    case active, inactive, locked
}

//This class run on Main Thread
@MainActor
class Store: ObservableObject{
    @Published var books: [BookStatus] = [.active,.active,.inactive,.locked, .locked, .locked, .locked]
    @Published var products: [Product] = [] //Product in AppStore in HPConfig.storekit
    @Published var purchasedIDs = Set<String>()
    
    private var productIDs = ["hp4","hp5","hp6","hp7"]
    private var updates: Task<Void,Never>? = nil
    
    init(){
        updates = watchForUpdates()
    }
    
    func loadProducts() async{
        do{
            products = try await Product.products(for: productIDs).sorted(by: { p1, p2 in
                p1.displayName < p2.displayName
            })
        }catch{
            print("Could not fetch those products: \(error.localizedDescription)")
        }
    }
    
    func purchase(_ product: Product) async{
        do{
            let result = try await product.purchase()
            switch result {
            //Purchase successfully, but now we have to verify receipt
            case .success(let verificationResult):
                switch verificationResult {
                case .unverified(let signedType, let verificationError):
                    print("Error on \(signedType):\(verificationError)")
                case .verified(let signedType):
                    purchasedIDs.insert(signedType.productID)
                }
            //User cancelled or Parent disapproved child's purchase request
            case .userCancelled:
                break
            //Waiting for approval
            case .pending:
                break
            @unknown default:
                break
            }
        }catch{
            print("Could not purchase that product: \(error.localizedDescription)")
        }
    }
    
    private func checkPurchased() async{
        for product in products {
            guard let state = await product.currentEntitlement else { return }
            switch state {
            case .unverified(let signedType, let verificationError):
                print("Error on \(signedType):\(verificationError)")
            case .verified(let signedType):
                if signedType.revocationDate == nil{
                    purchasedIDs.insert(signedType.productID)
                }else{
                    purchasedIDs.remove(signedType.productID)
                }
            }
        }
    }
    
    private func watchForUpdates() -> Task<Void,Never>{
        Task(priority: .background) {
            for await _ in Transaction.updates{
                await checkPurchased()
            }
        }
    }
}
