//
//  Item.swift
//  ShoppingList
//
//  Created by James Hager on 3/25/22.
//

import Foundation

class Item: Codable {
    
    let name: String
    var purchased: Bool
    
    init(name: String, purchased: Bool = false) {
        self.name = name
        self.purchased = purchased
    }
    
    func setPurchased(to purchased: Bool) {
        self.purchased = purchased
    }
    
    func togglePurchased() {
        purchased = !purchased
    }
}
