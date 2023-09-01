//
//  ProductPickerController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/4.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

private enum ProductPickerCellType {
    case color
    case size
    case amount

    var identifier: String {
        switch self {
        case .color: return String(describing: ColorSelectionCell.self)
        case .size: return String(describing: SizeSelectionCell.self)
        case .amount: return String(describing: AmountSelectionCell.self)
        }
    }
}

protocol ProductPickerControllerDelegate: AnyObject {
    func dismissPicker(_ controller: ProductPickerController)
    func valueChange(_ controller: ProductPickerController)
}

class ProductPickerController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }

    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!

    weak var delegate: ProductPickerControllerDelegate?

    private let datas: [ProductPickerCellType] = [.color, .size, .amount]

    var product: Product?

    var selectedColor: Color? {
        didSet {
            guard let index = datas.firstIndex(of: .size) else { return }
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            manipulaterCell(cell, type: .size)
            selectedSize = nil
            delegate?.valueChange(self)
        }
    }

    var selectedSize: String? {
        didSet {
            guard let index = datas.firstIndex(of: .amount) else { return }
            let indexPath = IndexPath(row: index, section: 0)
            guard let cell = tableView.cellForRow(at: indexPath) else { return }
            manipulaterCell(cell, type: .amount)
            delegate?.valueChange(self)
        }
    }

    var selectedAmount: Int? {
        guard let index = datas.firstIndex(of: .amount) else { return nil }
        let indexPath = IndexPath(row: index, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? AmountSelectionCell else { return nil }
        return cell.amount
    }

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    private func setupTableView() {
        tableView.register(
            SizeSelectionCell.self,
            forCellReuseIdentifier: ProductPickerCellType.size.identifier
        )

        tableView.register(
            ColorSelectionCell.self,
            forCellReuseIdentifier: ProductPickerCellType.color.identifier
        )

        tableView.lk_registerCellWithNib(
            identifier: String(describing: AmountSelectionCell.self),
            bundle: nil
        )
    }

    // MARK: - Action
    @IBAction func onDismiss(_ sender: UIButton) {
        delegate?.dismissPicker(self)
    }

    // MARK: - Cell Arrangement
    private func manipulaterCell(_ cell: UITableViewCell, type: ProductPickerCellType) {
        switch type {
        case .color:
            updateColorSelectionCell(cell)
        case .size:
            updateSizeSelectionCell(cell)
        case .amount:
            updateAmountSelectionCell(cell)
        }
    }
    
    private func updateColorSelectionCell(_ cell: UITableViewCell) {
        
        guard
            let colorCell = cell as? ColorSelectionCell,
            let product = product
        else {
            return
        }
        colorCell.colors = product.colors.map { $0.code }
        colorCell.touchHandler = { [weak self] indexPath in
            self?.selectedColor = self?.product?.colors[indexPath.row]
        }
    }
    
    private func updateSizeSelectionCell(_ cell: UITableViewCell) {
        guard
            let sizeCell = cell as? SizeSelectionCell,
            let product = product
        else {
            return
        }
        
        sizeCell.touchHandler = { [weak self] size in
            guard self?.selectedColor != nil else { return false }
            self?.selectedSize = size
            return true
        }
        sizeCell.sizes = product.sizes
        
        guard let selectedColor = selectedColor else { return }
        sizeCell.avalibleSizes = product.variants.compactMap { variant in
            if variant.colorCode == selectedColor.code {
                return variant.size
            }
            return nil
        }
    }
    
    private func updateAmountSelectionCell(_ cell: UITableViewCell) {
        guard let amountCell = cell as? AmountSelectionCell else { return }
        guard
            let product = product,
            let selectedColor = selectedColor,
            let selectedSize = selectedSize
        else {
            amountCell.layoutCell(variant: nil)
            return
        }
        let variant = product.variants.filter { item in
            if item.colorCode == selectedColor.code && item.size == selectedSize {
                return true
            }
            return false
        }
        amountCell.layoutCell(variant: variant.first)
    }
}

// MARK: - UITableViewDataSource
extension ProductPickerController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: datas[indexPath.row].identifier, for: indexPath)
        manipulaterCell(cell, type: datas[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ProductPickerController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 108.0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let product = product else { return headerView }
        titleLabel.text = product.title
        priceLabel.text = "NT$ \(product.price)"
        return headerView
    }
}
