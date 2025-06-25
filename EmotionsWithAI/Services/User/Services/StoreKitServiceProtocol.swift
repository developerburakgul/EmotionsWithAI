//
//  StoreKitServiceProtocol.swift
//  EmotionsWithAI
//
//  Created by Burak Gül on 24.06.2025.
//


import StoreKit

@MainActor
public protocol StoreKitServiceProtocol {
    var isPremium: Bool { get }
    func purchasePremium() async throws
}

class StoreKitService: StoreKitServiceProtocol {
    private let productID = "com.emotionswithai.premium" // App Store Connect'te tanımlı ürün ID'si
    private var purchasedProductIDs: Set<String> = []
    
    var isPremium: Bool {
        purchasedProductIDs.contains(productID)
    }
    
    init() {
        // Satın alma durumunu kontrol et

    }
    
    func purchasePremium() async throws {
        let products = try await Product.products(for: [productID])
        guard let product = products.first else {
            throw StoreKitError.productNotFound
        }
        
        let result = try await product.purchase()
        switch result {
        case .success(.verified(let transaction)):
            purchasedProductIDs.insert(productID)
            await transaction.finish()
        case .success(.unverified(_, let error)):
            throw error
        case .userCancelled:
            throw StoreKitError.userCancelled
        case .pending:
            throw StoreKitError.purchasePending
        @unknown default:
            throw StoreKitError.unknown
        }
    }
    
//    private func loadPurchasedProducts() async {
//        for await result in Transaction.currentEntitlements {
//            if case .verified(let transaction) = result, transaction.productID == productID, !transaction.isRevoked {
//                purchasedProductIDs.insert(transaction.productID)
//            }
//        }
//    }
}

enum StoreKitError: Error {
    case productNotFound
    case userCancelled
    case purchasePending
    case unknown
}
