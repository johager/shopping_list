//
//  ListViewController.swift
//  ShoppingList
//
//  Created by James Hager on 3/25/22.
//

import UIKit

class ListViewController: UITableViewController {

    // MARK: - Properties
    
    private let itemController = ItemController()
    
    private var itemsNotPurchased: [Item] {  // section 0
        return itemController.itemsNotPurchased
    }
    
    private var itemsPurchased: [Item] {  // section 1
        return itemController.itemsPurchased
    }

    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        
        alertController.addTextField() { textField in
            textField.placeholder = "Enter item name..."
        }
        
        alertController.addTextField() { textField in
            textField.placeholder = "Enter amount..."
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let save = UIAlertAction(title: "Add", style: .default) { [weak alertController] _ in
            guard let textFields = alertController?.textFields,
                  textFields.count > 1,
                  let name = textFields[0].text,
                  !name.isEmpty,
                  let amount = textFields[1].text,
                  !amount.isEmpty
            else { return }
            self.itemController.createItem(named: name, withAmount: amount)
            self.tableView.reloadData()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(save)
        
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ListViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // section 0 is not purchased
        // section 1 is purchased
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return itemsNotPurchased.count
        } else {
            return itemsPurchased.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }
        if indexPath.section == 0 {
            cell.configure(for: itemsNotPurchased[indexPath.row], withDelegate: self)
        } else {
            cell.configure(for: itemsPurchased[indexPath.row], withDelegate: self)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            itemController.deleteItem(atIndexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UITableViewDelegate

extension ListViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Not purchased"
        } else {
            return "Purchased"
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemController.togglePurchased(forItemAtIndexPath: indexPath)
        tableView.reloadData()
    }
}

// MARK: - ItemTableViewCellDelegate

extension ListViewController: ItemTableViewCellDelegate {
    
    func togglePurchased(for cell: ItemTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        itemController.togglePurchased(forItemAtIndexPath: indexPath)
        tableView.reloadData()
    }
}
