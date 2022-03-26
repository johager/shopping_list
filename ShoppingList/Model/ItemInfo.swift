//
//  ItemInfo.swift
//  ShoppingList
//
//  Created by James Hager on 3/26/22.
//
//  Used to communicate information about the item from the ListViewController to the ItemController
//

import Foundation

class ItemInfo {
    let purchased: Bool
    let index: Int
    
    init(indexPath: IndexPath) {
        self.purchased = indexPath.section == 1
        self.index = indexPath.row
    }
}
