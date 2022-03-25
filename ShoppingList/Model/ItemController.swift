//
//  ItemController.swift
//  ShoppingList
//
//  Created by James Hager on 3/25/22.
//

import Foundation

class ItemController {
    
    // MARK: - Properties
    
    var items = [Item]()
    
    private var persistentStoreURL: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let storeURL = urls[0].appendingPathComponent("Items.json")
        return storeURL
    }
    
    // MARK: - Init
    
    init() {
        loadFromPersistentStore()
    }
    
    // MARK: - CRUD
    
    func createItem(named name: String) {
        items.append(Item(name: name))
        saveToPersistentStore()
    }
    
    func togglePurchased(forItemAtIndex index: Int) {
        items[index].togglePurchased()
        saveToPersistentStore()
    }
    
    func deleteItem(atIndex index: Int) {
        items.remove(at: index)
        saveToPersistentStore()
    }
    
    // MARK: - Persist
    
    func saveToPersistentStore() {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: persistentStoreURL)
        } catch {
            print("saveToPersistentStore error: \(error)")
            print(error.localizedDescription)
        }
    }
    
    func loadFromPersistentStore() {
        do {
            let data = try Data(contentsOf: persistentStoreURL)
            items = try JSONDecoder().decode([Item].self, from: data)
        } catch {
            print("loadFromPersistentStore error: \(error)")
            print(error.localizedDescription)
        }
    }
}
