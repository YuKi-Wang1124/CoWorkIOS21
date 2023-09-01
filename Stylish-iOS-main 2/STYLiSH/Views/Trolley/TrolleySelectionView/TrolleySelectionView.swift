//
//  TrolleySelectionView.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/2/28.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit

class TrolleySelectionView: UIView {

    @IBOutlet weak var contentView: UIView!

    @IBOutlet weak var addBtn: UIButton!

    @IBOutlet weak var substractBtn: UIButton!

    @IBOutlet weak var inputField: UITextField! {
        didSet {
            inputField.keyboardType = .numberPad
            inputField.delegate = self
        }
    }

    var valueChangeHandler: ((Int) -> Void)?

    private var maxNumber: Int? {
        didSet {
            checkData()
        }
    }

    private var inputViews: [UIControl] {
        return [addBtn, substractBtn, inputField]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initView()
    }

    private func initView() {
        backgroundColor = .white

        Bundle.main.loadNibNamed(
            String(describing: TrolleySelectionView.self),
            owner: self,
            options: nil
        )

        stickSubView(contentView)
    }

    @IBAction func addAmount(_ sender: UIButton) {
        guard let text = inputField.text, let amount = Int(text) else { return }
        inputField.text = String(amount + 1)
        checkData()
    }

    @IBAction func subtractAmount(_ sender: UIButton) {
        guard let text = inputField.text, let amount = Int(text) else { return }
        inputField.text = String(amount - 1)
        checkData()
    }

    func isEnable(_ flag: Bool, maxNumber: Int?, amount: Int = 1) {
        if flag {
            inputViews.forEach { item in
                enable(item: item)
            }
            inputField.text = String(amount)
        } else {
            inputViews.forEach { item in
                disable(item: item)
            }
            inputField.text = ""
            return
        }
        self.maxNumber = maxNumber
    }

    func checkData() {
        guard let maxNumber = maxNumber else { return }
        if maxNumber < 1 {
            disable(item: addBtn)
            disable(item: substractBtn)
            inputField.text = ""
            disable(item: inputField)
            return
        }
        if maxNumber == 1 {
            disable(item: addBtn)
            disable(item: substractBtn)
            inputField.text = "1"
            disable(item: inputField)
            return
        }
        guard
            let text = inputField.text,
            let input = Int(text),
            input <= maxNumber,
            input >= 1
        else {
            inputField.text = String(maxNumber)
            disable(item: addBtn)
            enable(item: substractBtn)
            return
        }

        valueChangeHandler?(input)

        if input == maxNumber {
            disable(item: addBtn)
            enable(item: substractBtn)
            return
        }
        if input == 1 {
            enable(item: addBtn)
            disable(item: substractBtn)
            return
        }
        enable(item: addBtn)
        enable(item: substractBtn)
    }

    private func disable(item: UIControl) {
        item.layer.borderColor = UIColor.B1?.withAlphaComponent(0.4).cgColor
        item.tintColor = .B1?.withAlphaComponent(0.4)
        item.isEnabled = false
    }

    private func enable(item: UIControl) {
        item.layer.borderColor = UIColor.B1?.cgColor
        item.tintColor = .B1
        item.isEnabled = true
    }
}

// MARK: - UITextFieldDelegate
extension TrolleySelectionView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkData()
    }
}
