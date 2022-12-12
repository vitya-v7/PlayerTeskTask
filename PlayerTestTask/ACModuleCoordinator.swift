//
//  ACModuleCoordinator.swift
//  A.Convertly
//
//  Created by viktor.deryabin on 25.04.2022.
//  Copyright © 2022 MusiCode. All rights reserved.
//

import AnalyticsManager
import DevCloudKit
import Foundation
import MediaPlayer
import UIKit
import UniformTypeIdentifiers

class ACModuleCoordinator {
    
    private var navigationController: UINavigationController
    private var dimmingViewWithSettings: UIView?
    private var settingsIsShown = false
    
    init(withNavigationController navigationController: UINavigationController) {
        self.navigationController = navigationController
        
    }
    
    private lazy var onCloseSettingsController: (() -> Void)? = {
        DispatchQueue.main.async {
            self.dimmingViewWithSettings?.removeFromSuperview()
            self.settingsIsShown = false
        }
    }
    
    private lazy var onBackToStartScreen: (() -> Void)? = {
        DispatchQueue.main.async {
            self.navigationController.popToRootViewController(animated: true)
        }
    }
    
    private lazy var onGoToScreensBackWithCountToPop: ((Int) -> Void)? = { numberOfControllerToPop in
        DispatchQueue.main.async {
            let countOfVC = self.navigationController.viewControllers.count
            self.navigationController.popToViewController(
                self.navigationController.viewControllers[countOfVC - numberOfControllerToPop - 1],
                animated: true)
        }
    }
    
    private lazy var onSharingScreen: ((URL, UIView) -> Void)? = { url, sourceView in
        AnalyticsManager.logEvent("go_to_screen",
                                  withParameters: ["place": "sharing_screen"])
        DispatchQueue.main.async {
            let activityVC = UIActivityViewController(activityItems: [url],
                                                      applicationActivities: nil)
            if UIScreen.main.isIpad() {
                activityVC.popoverPresentationController?.sourceView = sourceView
                activityVC.popoverPresentationController?.permittedArrowDirections = .down
                activityVC.popoverPresentationController?.sourceRect = sourceView.bounds
                activityVC.modalPresentationStyle = .popover
            } else {
                activityVC.modalPresentationStyle = .pageSheet
            }
            
            self.navigationController.present(activityVC, animated: true, completion: nil)
        }
    }
    
    private lazy var onShowConvertingCompletedController: ((CLMediaItem) -> Void)? = { item in
        DispatchQueue.main.async {
            let convertingCompletedViewController = ACConvertingCompletedViewController()
            convertingCompletedViewController.onBackToStartScreen = self.onBackToStartScreen
            convertingCompletedViewController.onGoToScreensBackWithCountToPop = self.onGoToScreensBackWithCountToPop
            
            convertingCompletedViewController.onSharingScreen = self.onSharingScreen
            convertingCompletedViewController.onShowOfferScreen = self.onShowOfferScreen
            let convertingCompletedPresenter = ACConvertingCompletedPresenter(
                withView: convertingCompletedViewController,
                item: item
            )
            
            convertingCompletedViewController.output = convertingCompletedPresenter
            self.setNavigationBlocksToViewController(convertingCompletedViewController)
            self.navigationController.pushViewController(convertingCompletedViewController,
                                                         animated: true)
        }
    }
    
    private lazy var onShowConvertingController: ((CLMediaItem,
                                                   CLMediaItem,
                                                   ACConstants.ACFileTypes,
                                                   ACTrackSettingsModel) -> Void)? = { inputItem,
        outputItem,
        type,
        info in
        
        DispatchQueue.main.async {
        let convertingFileViewController = ACConvertingViewController()
        
        let chooseConvertFilePresenter = ACConvertingPresenter(withView: convertingFileViewController,
                                                               inputItem: inputItem,
                                                               outputItem: outputItem,
                                                               convertingFormat: type,
                                                               andAdditionalConvertingInfo: info)
        
        convertingFileViewController.onSharingViewController = self.onShowConvertingCompletedController
        
        convertingFileViewController.output = chooseConvertFilePresenter
        self.setNavigationBlocksToViewController(convertingFileViewController)
        
            self.navigationController.pushViewController(convertingFileViewController,
                                                         animated: true)
        }
    }
    
    private lazy var onShowCustomGalleryScreen: ((Bool) -> Void)? = { isCloudStorage in
        DispatchQueue.main.async {
            AnalyticsManager.logEvent("Open.Gallery")
            let customCollectionViewController = ACCustomCollectionViewController()
            let customCollectionPresenter = ACCustomCollectionViewPresenter(
                withView: customCollectionViewController)
            customCollectionViewController.output = customCollectionPresenter
            customCollectionViewController.modalPresentationStyle = .pageSheet
            customCollectionPresenter.isCloudStorage = isCloudStorage
            print("debug: isCloudStorage \(isCloudStorage)")
            self.navigationController.present(customCollectionViewController, animated: true)
        }
    }
    
    private lazy var onShowSettingsController: (() -> Void) = {
        AnalyticsManager.logEvent("go_to_screen",
                                  withParameters: ["place": "settings_screen"])
        DispatchQueue.main.async {
            guard self.settingsIsShown == false,
                  let topViewController = self.navigationController.topViewController as? ACGeneralViewController,
                  let currentWindow = UIApplication.shared.keyWindow else {
                return
            }
            let settingsView = ACSettingsView()
            settingsView.delegate = topViewController
            self.dimmingViewWithSettings = ACDimmingViewWithCenterView(withFrame: currentWindow.frame,
                                                                       withCenterView: settingsView,
                                                                       alphaComponent: 0.5,
                                                                       andSize: CGSize(width: 278,
                                                                                       height: 212))
            guard let dimmingViewWithSettings = self.dimmingViewWithSettings else {
                return
            }
            currentWindow.addSubview(dimmingViewWithSettings)
            self.settingsIsShown = true
            if let controller = self.navigationController.topViewController as? ACGeneralViewController {
                controller.settingsView = settingsView
            }
        }
    }
    
    private lazy var onShowProfileController: (() -> Void) = {
        DispatchQueue.main.async {
            guard
                let topViewController = self.navigationController.topViewController as? ACGeneralViewController,
                let currentWindow = UIApplication.shared.keyWindow
            else { return }
            
            let profileView = ProfileView()
            profileView.delegate = topViewController
            
            self.dimmingViewWithSettings = ACDimmingViewWithCenterView(withFrame: currentWindow.frame,
                                                                       withCenterView: profileView,
                                                                       alphaComponent: 0.5,
                                                                       andSize: CGSize(width: 326,
                                                                                       height: 312))
            guard let dimmingViewWithSettings = self.dimmingViewWithSettings else { return }
            currentWindow.addSubview(dimmingViewWithSettings)
            
            if let controller = self.navigationController.topViewController as? ACGeneralViewController {
                controller.profileView = profileView
            }
        }
    }
    
    private lazy var onShowRegisterCloudScreen: (() -> Void) = {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: ACConstants.registrationStoryboardName, bundle: nil)
            guard
                let registrationController = storyboard.instantiateViewController(
                    withIdentifier: ACConstants.registrationViewControllerID
                ) as? ACRegistrationViewController
            else { return }
            
            let registrationPresenter = ACRegistrationPresenter(withView: registrationController)
            registrationController.output = registrationPresenter
            registrationController.onShowCloudStorageScreen = self.onShowCloudStorageScreen
                        
            self.setNavigationBlocksToViewController(registrationController)
            self.navigationController.pushViewController(registrationController, animated: true)
        }
    }
    
    private lazy var onShowCloudStorageScreen: (([DCKFileItem]?) -> Void) = { dckItems in
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: ACConstants.cloudStorageStoryboardName, bundle: nil)
            guard
                let cloudStorageController = storyboard.instantiateViewController(
                    withIdentifier: ACConstants.cloudStorageViewControllerID
                ) as? ACCloudStorageViewController
            else { return }
            
            let cloudStoragePresenter = ACCloudStoragePresenter(withView: cloudStorageController)
            cloudStorageController.output = cloudStoragePresenter
            cloudStoragePresenter.setOnShowFilesAppScreen(self.onShowDocumentPickerScreen)
            cloudStorageController.onShowCustomGalleryScreen = self.onShowCustomGalleryScreen
            cloudStorageController.dckFileItems = dckItems
            cloudStorageController.onShowPreparingScreen = self.onShowPreparingScreen
            
            self.setNavigationBlocksToViewController(cloudStorageController)
            self.navigationController.pushViewController(cloudStorageController, animated: true)
        }
    }
    
    private lazy var onShowHistoryScreen: (() -> Void) = {
        DispatchQueue.main.async {
            let showHistoryViewController = ACConvertedTracksHistoryViewController()
            let onShowHistoryPresenter = ACConvertedTracksHistoryPresenter(withView: showHistoryViewController)
            
            showHistoryViewController.output = onShowHistoryPresenter
            showHistoryViewController.onSharingScreen = self.onSharingScreen
            self.setNavigationBlocksToViewController(showHistoryViewController)
            self.navigationController.pushViewController(showHistoryViewController,
                                                         animated: true)
        }
    }
    
    private lazy var onShowOfferScreen: ((String, String) -> Void) = { source, place in
        if ACMonetizationManager.shared.isSubsctiptionActive() {
            return
        }
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: ACConstants.offersStoryboardName, bundle: nil)
            guard let offerViewController =
                    storyboard.instantiateViewController(
                        withIdentifier: ACConstants.offerViewControllerID) as? ACOfferViewController else {
                return
            }
            let offerPresenter = ACOfferPresenter(withView: offerViewController)
            
            offerViewController.output = offerPresenter
            offerViewController.source = source
            offerViewController.place = place
            if let visibleViewController = self.navigationController.topViewController {
                visibleViewController.modalPresentationStyle = .fullScreen
                visibleViewController.present(offerViewController,
                                              animated: true)
            }
        }
    }
    
    private lazy var onGoToPreviousScreen: (() -> Void) = {
        DispatchQueue.main.async {
            self.navigationController.popViewController(animated: true)
        }
    }
    
    private lazy var onShowPreparingScreen: ((CLMediaItem) -> Void)? = { item in
        DispatchQueue.main.async {
        let chooseConvertFileViewController = ACChooseConvertFileViewController()
        chooseConvertFileViewController.onShowConvertingController = self.onShowConvertingController
        let chooseConvertFilePresenter = ACChooseConvertFilePresenter(
            withView: chooseConvertFileViewController,
            andItem: item)
        chooseConvertFileViewController.output = chooseConvertFilePresenter
        self.setNavigationBlocksToViewController(chooseConvertFileViewController)
            self.navigationController.pushViewController(chooseConvertFileViewController,
                                                         animated: true)
        }
    }
    
    private lazy var onShowDocumentPickerScreen: ((UIDocumentPickerDelegate) -> Void)? = { documentDelegate in
        DispatchQueue.main.async {
            AnalyticsManager.logEvent("Open.Files")
            let documentPicker = UIDocumentPickerViewController(documentTypes: ["public.audio"],
                                                                in: .import)
            documentPicker.delegate = documentDelegate
            documentPicker.allowsMultipleSelection = false
            self.navigationController.present(documentPicker,
                                              animated: true)
            
        }
    }
    
    func start() {
        DispatchQueue.main.async {
            let startViewController = ACStartViewController()
            
            startViewController.onShowPreparingScreen = self.onShowPreparingScreen
            let startPresenter = ACStartPresenter(withView: startViewController)
            startPresenter.setOnShowFilesAppScreen(self.onShowDocumentPickerScreen)
            startViewController.onShowHistoryScreen = self.onShowHistoryScreen
            startViewController.onShowCustomGalleryScreen = self.onShowCustomGalleryScreen
            startViewController.onShowRegisterScreen = self.onShowRegisterCloudScreen
            startViewController.onShowCloudStorageScreen = self.onShowCloudStorageScreen
            startViewController.output = startPresenter
            self.setNavigationBlocksToViewController(startViewController)
            self.navigationController.pushViewController(startViewController,
                                                         animated: true)
        }
    }
    
    func setNavigationBlocksToViewController(_ viewController: ACGeneralViewController) {
        viewController.onShowSettingsScreen = self.onShowSettingsController
        viewController.onShowProfileScreen = self.onShowProfileController
        viewController.onShowOffer = self.onShowOfferScreen
        viewController.onGoToPreviousScreen = self.onGoToPreviousScreen
        viewController.onCloseSettingsScreen = self.onCloseSettingsController
    }
}
