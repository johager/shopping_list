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
    var itemsNotPurchased: [Item] { return pItemsNotPurchased }  // section 0
    var itemsPurchased: [Item] { return pItemsPurchased }  // section 1
    
    var shouldShowWelcome: Bool { return pShouldShowWelcome }
    
    // source of truth
    private var items = [Item]() {
        didSet {
            updateItemsPurchased()
        }
    }
    
    private var pItemsNotPurchased = [Item]()  // section 0
    private var pItemsPurchased = [Item]()  // section 1
    
    private var pShouldShowWelcome = false
    
    private var nextId = 0 {
        didSet {
            UserDefaults.standard.set(nextId, forKey: nextIdKey)
        }
    }
    
    private let nextIdKey = "nextId"
    
    private var persistentStoreURL: URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let storeURL = urls[0].appendingPathComponent("Items.json")
        return storeURL
    }
    
    // MARK: - Init
    
    init() {
        loadFromPersistentStore()
        nextId = UserDefaults.standard.integer(forKey: nextIdKey)
        pShouldShowWelcome = nextId == 0
    }
    
    // MARK: - Misc Methods
    
    private func sort() {
        pItemsNotPurchased.sort { ($0.name, $0.id) < ($1.name, $1.id) }
        pItemsPurchased.sort { ($0.name, $0.id) < ($1.name, $1.id) }
    }
    
    private func updateItemsPurchased() {
        pItemsNotPurchased = items.filter { !$0.purchased }
        pItemsPurchased = items.filter { $0.purchased }
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
            pItemsNotPurchased[indexPath.row].togglePurchased()
        } else {
            pItemsPurchased[indexPath.row].togglePurchased()
        }
        updateItemsPurchased()
        saveToPersistentStore()
    }
    
    func deleteItem(atIndexPath indexPath: IndexPath) {
        // section 0 is not purchased
        // section 1 is purchased
        
        let index: Int?
        if indexPath.section == 0 {
            index = items.firstIndex(of: pItemsNotPurchased[indexPath.row])
        } else {
            index = items.firstIndex(of: pItemsPurchased[indexPath.row])
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
