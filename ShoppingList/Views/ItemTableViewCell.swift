//
//  ItemTableViewCell.swift
//  ShoppingList
//
//  Created by James Hager on 3/25/22.
//

import UIKit

protocol ItemTableViewCellDelegate: AnyObject {
    func togglePurchased(for cell: ItemTableViewCell)
}

// MARK: -

class ItemTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet weak var purchasedButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    // MARK: - Properties
    
    weak var delegate: ItemTableViewCellDelegate?
    
    // MARK: - View Methods
    
    func configure(for item: Item, withDelegate delegate: ItemTableViewCellDelegate) {
        if item.purchased {
            purchasedButton?.setImage(UIImage(named: "purchased"), for: .normal)
        } else {
            purchasedButton?.setImage(UIImage(named: "notPurchased"), for: .normal)
        }
        nameLabel?.text = item.name
        amountLabel?.text = item.amount
        self.delegate = delegate
    }
    
    // MARK: - Actions

    @IBAction func purchasedButtonTapped(_ sender: Any) {
        delegate?.togglePurchased(for: self)
    }
}
