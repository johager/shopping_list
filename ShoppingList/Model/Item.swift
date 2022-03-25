//
//  Item.swift
//  ShoppingList
//
//  Created by James Hager on 3/25/22.
//

import Foundation

class Item: Codable {
    
    let id: Int
    let name: String
    var amount: String
    var purchased: Bool
    
    init(id: Int, name: String, amount: String, purchased: Bool = false) {
        self.id = id
        self.name = name
        self.amount = amount
        self.purchased = purchased
    }
    
    func setPurchased(to purchased: Bool) {
        self.purchased = purchased
    }
    
    func togglePurchased() {
        purchased = !purchased
    }
}

extension Item: Equatable {
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id
    }
}
