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
    
    private var items: [Item] {
        return itemController.items
    }
    
    // MARK: - Actions
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        
        alertController.addTextField() { textField in
            textField.placeholder = "Enter item name..."
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        let save = UIAlertAction(title: "Add", style: .default) { [weak alertController] _ in
            guard let textFields = alertController?.textFields,
                  textFields.count > 0,
                  let name = textFields[0].text,
                  !name.isEmpty
            else { return }
            self.itemController.createItem(named: name)
            self.tableView.reloadData()
        }
        
        alertController.addAction(cancel)
        alertController.addAction(save)
        
        present(alertController, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension ListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as? ItemTableViewCell else { return UITableViewCell() }
        cell.configure(for: items[indexPath.row], withDelegate: self)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            itemController.deleteItem(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UITableViewDelegate

extension ListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemController.togglePurchased(forItemAtIndex: indexPath.row)
        tableView.reloadData()
    }
}

// MARK: - ItemTableViewCellDelegate

extension ListViewController: ItemTableViewCellDelegate {
    
    func togglePurchased(for cell: ItemTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        itemController.togglePurchased(forItemAtIndex: indexPath.row)
        tableView.reloadData()
    }
}
