//
//  RootPickerHelper.swift
//  PlayerTestTask
//
//  Created by Admin on 06.12.2022.
//

import Foundation
import MediaPlayer

class RootPickerHelper: NSObject {
    var isLogged: Bool?
    var alertHelper = AlertHelper()
    var exportSessionHelper = ExportSessionHelper()
    override init() {}
    
    internal func getRequestAccess(inViewController viewController: UIViewController,
                                   access: @escaping (Bool) -> Void) {}
    
    func requestDeniedWithText(_ text: String,
                               inViewController viewController: UIViewController) {
        self.alertHelper.showModalAlert(inViewController: viewController,
                                        withTitle: "Access denied",
                                        text: text,
                                        needTextField: false,
                                        needCancelButton: true,
                                        confirmBlock: { text in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(url,
                                      options: [:],
                                      completionHandler: nil)
        }, cancelBlock: nil)
    }
    
    func copyItemToTemporaryFolder(_ item: TrackModel,
                                   withCompletion completion: @escaping ((TrackModel) -> Void)) {
        
        guard let tempFileUrl = DataManager.shared.getTempURLToItem(item,
                                                                    withExtension: item.trackURL.pathExtension) else {
            return
        }
        if item.trackURL.startAccessingSecurityScopedResource() {
            do {
                if FileManager.default.fileExists(atPath: tempFileUrl.path) {
                    try FileManager.default.removeItem(at: tempFileUrl)
                }
                try FileManager.default.copyItem(at: item.trackURL,
                                                 to: tempFileUrl)
            } catch {
                print(error.localizedDescription)
                return
            }
        }

        item.trackURL.stopAccessingSecurityScopedResource()
        
        var mutableItem = item
        mutableItem.trackURL = tempFileUrl
        completion(mutableItem)
    }
    
    func showErrorAlert(withErrorDescription errorDescription: String = "Cannot load file",
                        inViewController viewController: UIViewController) {
        self.alertHelper.showSimpleAlert(inViewController: viewController,
                                         withTitle: "Error",
                                         message: errorDescription,
                                         confirmBlock: nil)
    }
    
    func requestItemsInViewController(inViewController view: UIViewController,
                                      showPickerCompletion: @escaping () -> Void) {
        self.getRequestAccess(inViewController: view, access: { isSuccess in
            showPickerCompletion()
        })
    }
}
