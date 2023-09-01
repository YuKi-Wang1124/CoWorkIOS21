//
//  StorageManager.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/6.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import CoreData

typealias LSOrderResults = (Result<[LSOrder]>) -> Void
typealias LSOrderResult = (Result<LSOrder>) -> Void

@objc class StorageManager: NSObject {

    private enum Entity: String, CaseIterable {
        case color = "LSColor"
        case order = "LSOrder"
        case product = "LSProduct"
        case variant = "LSVariant"
    }

    private struct Order {
        static let createTime = "createTime"
    }

    static let shared = StorageManager()

    private override init() {
        print(" Core data file path: \(NSPersistentContainer.defaultDirectoryURL())")
    }

    lazy var persistanceContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "STYLiSH")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                 fatalError("Unresolved error \(error)")
            }
        })
        return container
    }()

    var viewContext: NSManagedObjectContext {
        return persistanceContainer.viewContext
    }
    
    @objc dynamic var orders: [LSOrder] = []

    func fetchOrders(completion: LSOrderResults = { _ in }) {
        let request = NSFetchRequest<LSOrder>(entityName: Entity.order.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: Order.createTime, ascending: true)]
        do {
            let orders = try viewContext.fetch(request)
            self.orders = orders
            completion(Result.success(orders))
        } catch {
            completion(Result.failure(error))
        }
    }

    func saveOrder(
        color: Color,
        size: String,
        amount: Int,
        product: Product,
        completion: (Result<Void>) -> Void) {
            let lsProduct = LSProduct(context: viewContext)
            lsProduct.mapping(product)
            
            let lsColor = LSColor(context: viewContext)
            lsColor.mapping(color)
            
            let order = LSOrder(context: viewContext)
            order.amount = amount.int64()
            order.selectedColor = lsColor
            order.seletedSize = size
            order.product = lsProduct
            order.createTime = Int(Date().timeIntervalSince1970).int64()
            
            save(completion: completion)
        }

    func deleteOrder(_ order: LSOrder, completion: (Result<Void>) -> Void) {
        viewContext.delete(order)
        save(completion: completion)
    }

    func deleteAllProduct(completion: (Result<Void>) -> Void) {
        for item in Entity.allCases {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: item.rawValue)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try viewContext.execute(deleteRequest)
                fetchOrders()
            } catch {
                completion(Result.failure(error))
                return
            }
        }
        completion(Result.success(()))
    }
    
    func save(completion: (Result<Void>) -> Void = { _ in  }) {
        do {
            try viewContext.save()
            fetchOrders(completion: { result in
                switch result {
                case .success: completion(Result.success(()))
                case .failure(let error): completion(Result.failure(error))
                }
            })
        } catch {
            completion(Result.failure(error))
        }
    }
}

// MARK: - Data Operation
private extension LSProduct {

    func mapping(_ object: Product) {
        detail = object.description
        id = object.id.int64()
        images = object.images
        mainImage = object.mainImage
        note = object.note
        place = object.note
        price = object.price.int64()
        sizes = object.sizes
        story = object.story
        texture = object.texture
        title = object.title
        wash = object.wash
        colors = NSSet(array:
            object.colors.map { color in
                let lsColor = LSColor(context: StorageManager.shared.viewContext)
                lsColor.mapping(color)
                return lsColor
            }
        )
        variants = NSSet(array:
            object.variants.map { variant in
                let lsVariant = LSVariant(context: StorageManager.shared.viewContext)
                lsVariant.mapping(variant)
                return lsVariant
            }
        )
    }
}

private extension LSColor {

    func mapping(_ object: Color) {
        code = object.code
        name = object.name
    }
}

private extension LSVariant {

    func mapping(_ object: Variant) {
        colorCode = object.colorCode
        size = object.size
        stocks = object.stock.int64()
    }
}
