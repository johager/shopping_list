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
    var itemsNotPurchased: [Item] { return pItemsNotPurchased }
    var itemsPurchased: [Item] { return pItemsPurchased }
    
    var shouldShowWelcome: Bool { return pShouldShowWelcome }
    
    // source of truth
    private var items = [Item]() {
        didSet {
            updateItemsPurchased()
        }
    }
    
    private var pItemsNotPurchased = [Item]()
    private var pItemsPurchased = [Item]()
    
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
    
    private func sort(_ items: inout [Item]) {
        items.sort { ($0.name, $0.id) < ($1.name, $1.id) }
    }
    
    private func updateItemsPurchased() {
        pItemsNotPurchased = items.filter { !$0.purchased }
        pItemsPurchased = items.filter { $0.purchased }
        sort(&pItemsNotPurchased)
        sort(&pItemsPurchased)
    }
    
    // MARK: - CRUD
    
    func createItem(named name: String, withAmount amount: String) {
        items.append(Item(id: nextId, name: name, amount: amount))
        nextId += 1
        sort(&pItemsNotPurchased)
        saveToPersistentStore()
    }
    
    func togglePurchased(forItemInfo itemInfo: ItemInfo) {
        
        if itemInfo.purchased {
            pItemsPurchased[itemInfo.index].togglePurchased()
        } else {
            pItemsNotPurchased[itemInfo.index].togglePurchased()
        }
        updateItemsPurchased()
        saveToPersistentStore()
    }
    
    func deleteItem(atItemInfo itemInfo: ItemInfo) {
        
        let index: Int?
        if itemInfo.purchased {
            index = items.firstIndex(of: pItemsPurchased[itemInfo.index])
            pItemsPurchased.remove(at: itemInfo.index)
        } else {
            index = items.firstIndex(of: pItemsNotPurchased[itemInfo.index])
            pItemsNotPurchased.remove(at: itemInfo.index)
        }
        
        guard let index = index else { return }
        
        items.remove(at: index)
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
