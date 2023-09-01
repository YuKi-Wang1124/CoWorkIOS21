//
//  MarketProvider.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/13.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import Foundation

typealias PromotionHanlder = (Result<[PromotedProducts]>) -> Void
typealias ProductsResponseWithPaging = (Result<STSuccessParser<[Product]>>) -> Void

class MarketProvider {

    let decoder = JSONDecoder()

    private enum ProductType {
        case men(Int)
        case women(Int)
        case accessories(Int)
    }

    // MARK: - Public method
    func fetchHots(completion: @escaping PromotionHanlder) {
        HTTPClient.shared.request(STMarketRequest.hots, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let products = try self.decoder.decode(
                        STSuccessParser<[PromotedProducts]>.self,
                        from: data
                    )
                    DispatchQueue.main.async {
                        completion(Result.success(products.data))
                    }
                } catch {
                    completion(Result.failure(error))
                }
            case .failure(let error):
                completion(Result.failure(error))
            }
        })
    }

    func fetchProductForMen(paging: Int, completion: @escaping ProductsResponseWithPaging) {
        fetchProducts(request: STMarketRequest.men(paging: paging), completion: completion)
    }

    func fetchProductForWomen(paging: Int, completion: @escaping ProductsResponseWithPaging) {
        fetchProducts(request: STMarketRequest.women(paging: paging), completion: completion)
    }

    func fetchProductForAccessories(paging: Int, completion: @escaping ProductsResponseWithPaging) {
        fetchProducts(request: STMarketRequest.accessories(paging: paging), completion: completion)
    }

    // MARK: - Private method
    private func fetchProducts(request: STMarketRequest, completion: @escaping ProductsResponseWithPaging) {
        HTTPClient.shared.request(request, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                do {
                    let response = try self.decoder.decode(STSuccessParser<[Product]>.self, from: data)
                    DispatchQueue.main.async {
                        completion(Result.success(response))
                    }
                } catch {
                    completion(Result.failure(error))
                }
            case .failure(let error):
                completion(Result.failure(error))
            }
        })
    }
}
