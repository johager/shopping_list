//
//  ItemController.swift
//  ShoppingList
//
//  Created by James Hager on 3/25/22.
//

import Foundation

class ItemController {
    
    // MARK: - Properties
    
    // access to truth
    var itemsNotPurchased = [Item]()  // section 0
    var itemsPurchased = [Item]()  // section 1
    
    // source of truth
    private var items = [Item]() {
        didSet {
            updateItemsPurchased()
        }
    }
    
    private var nextId = 0
    
    private var persistentStoreURL: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let storeURL = urls[0].appendingPathComponent("Items.json")
        return storeURL
    }
    
    // MARK: - Init
    
    init() {
        loadFromPersistentStore()
        let itemWithMaxId = items.max { $0.id < $1.id}
        guard let itemWithMaxId = itemWithMaxId else { return }
        nextId = itemWithMaxId.id + 1
    }
    
    // MARK: - Misc Methods
    
    private func sort() {
        itemsNotPurchased.sort(by: { $0.name < $1.name })
        itemsPurchased.sort(by: { $0.name < $1.name })
    }
    
    private func updateItemsPurchased() {
        itemsNotPurchased = items.filter { !$0.purchased }
        itemsPurchased = items.filter { $0.purchased }
        sort()
    }
    
    // MARK: - CRUD
    
    func createItem(named name: String, withAmount amount: String) {
        items.append(Item(id: nextId, name: name, amount: amount))
        nextId += 1
        sort()
        saveToPersistentStore()
    }
    
    func togglePurchased(forItemAtIndexPath indexPath: IndexPath) {
        // section 0 is not purchased
        // section 1 is purchased
        
        if indexPath.section == 0 {
            itemsNotPurchased[indexPath.row].togglePurchased()
        } else {
            itemsPurchased[indexPath.row].togglePurchased()
        }
        updateItemsPurchased()
        saveToPersistentStore()
    }
    
    func deleteItem(atIndexPath indexPath: IndexPath) {
        // section 0 is not purchased
        // section 1 is purchased
        
        let index: Int?
        if indexPath.section == 0 {
            index = items.firstIndex(of: itemsNotPurchased[indexPath.row])
        } else {
            index = items.firstIndex(of: itemsPurchased[indexPath.row])
        }
        
        guard let index = index else { return }
        
        items.remove(at: index)
        updateItemsPurchased()
        saveToPersistentStore()
    }
    
    // MARK: - Persist
    
    private func saveToPersistentStore() {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: persistentStoreURL)
        } catch {
            print("saveToPersistentStore error: \(error)")
            print(error.localizedDescription)
        }
    }
    
    private func loadFromPersistentStore() {
        do {
            let data = try Data(contentsOf: persistentStoreURL)
            items = try JSONDecoder().decode([Item].self, from: data)
        } catch {
            print("loadFromPersistentStore error: \(error)")
            print(error.localizedDescription)
        }
    }
}
