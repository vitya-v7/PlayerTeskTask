//
//  AlertHelper.swift
//  PlayerTestTask
//
//  Created by Admin on 06.12.2022.
//

import Foundation
import UIKit

class AlertHelper {
    
    func showSimpleAlert(inViewController viewController: UIViewController,
                         withTitle title: String,
                         message: String,
                         confirmBlock: (() -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                confirmBlock?()
            }
            
            alert.addAction(okAction)
            viewController.present(alert, animated: true)
        }
    }
    
    func showDeleteAlert(inViewController viewController: UIViewController,
                         title: String,
                         message: String,
                         actionBlock: (() -> Void)?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            
            let deleteAction = UIAlertAction(title: "Delete",
                                             style: .destructive) { _ in
                actionBlock?()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel",
                                             style: .default)
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            viewController.present(alert, animated: true)
        }
    }
    
    func showModalAlert(inViewController viewController: UIViewController,
                        withTitle title: String,
                        text: String,
                        needTextField: Bool,
                        defaultValueForTextField: String = "",
                        needCancelButton: Bool,
                        acceptButtonString: String = "OK",
                        cancelButtonString: String = "Cancel",
                        confirmBlock: ((String?) -> Void)?,
                        cancelBlock: (() -> Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title,
                                                    message: text,
                                                    preferredStyle: .alert)
            let okAction = UIAlertAction(title: acceptButtonString,
                                         style: .default) { _ in
                confirmBlock?(alertController.textFields?.first?.text)
            }
            
            if needCancelButton {
                let cancelAction = UIAlertAction(title: cancelButtonString,
                                                 style: .default) { _ in
                    if let cancelBlock = cancelBlock {
                        cancelBlock()
                    } else {
                        alertController.dismiss(animated: true)
                    }
                }
                alertController.addAction(cancelAction)
            }
            
            if needTextField {
                alertController.addTextField { textField in
                    textField.placeholder = defaultValueForTextField
                    textField.text = defaultValueForTextField
                    textField.clearButtonMode = .always
                    textField.borderStyle = .none
                    textField.returnKeyType = .done
                }
            }
            
            alertController.addAction(okAction)
            viewController.present(alertController,
                                   animated: true)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                if let textField = alertController.textFields?.first {
                    textField.becomeFirstResponder()
                    textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument,
                                                                      to: textField.endOfDocument)
                }
            }
        }
    }
    
}
