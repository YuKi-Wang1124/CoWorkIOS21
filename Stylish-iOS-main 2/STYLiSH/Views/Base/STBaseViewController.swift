//
//  STHideNavigationBarController.swift
//  STYLiSH
//
//  Created by WU CHIH WEI on 2019/3/3.
//  Copyright © 2019 AppWorks School. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class STBaseViewController: UIViewController {

    static var identifier: String {
        return String(describing: self)
    }
    
    var isHideNavigationBar: Bool {
        return false
    }

    var isEnableResignOnTouchOutside: Bool {
        return true
    }

    var isEnableIQKeyboard: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if isHideNavigationBar {
            navigationItem.hidesBackButton = true
        }
        navigationController?.navigationBar.barTintColor = .white.withAlphaComponent(0.9)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.backIndicatorImage = .asset(.Icons_24px_Back02)
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = .asset(.Icons_24px_Back02)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(true, animated: true)
        }
        
        IQKeyboardManager.shared.enable = isEnableIQKeyboard
        IQKeyboardManager.shared.shouldResignOnTouchOutside = isEnableResignOnTouchOutside
        
        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isHideNavigationBar {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }

        IQKeyboardManager.shared.enable = !isEnableIQKeyboard
        IQKeyboardManager.shared.shouldResignOnTouchOutside = !isEnableResignOnTouchOutside
    }

    @IBAction func popBack(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func backToRoot(_ sender: Any) {
        backToRoot(completion: nil)
    }
    
}

extension UIViewController {
    
    func backToRoot(completion: (() -> Void)? = nil) {
        if presentingViewController != nil {
            let superVC = presentingViewController
            dismiss(animated: false, completion: nil)
            superVC?.backToRoot(completion: completion)
            return
        }

        if let tabbarVC = self as? UITabBarController {
            tabbarVC.selectedViewController?.backToRoot(completion: completion)
            return
        }
        
        if let navigateVC = self as? UINavigationController {
            navigateVC.popToRootViewController(animated: false)
        }
        
        completion?()
    }
}
