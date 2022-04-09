//
//  ShareViewController.swift
//  Share
//
//  Created by Ankit Sharma on 20/03/22.
//

import UIKit
import Social
import CoreServices

class ShareViewController: UIViewController {
    
    private let appURL = "Fundus://"
    let groupName = "group.app.fundus.Fundus"
    
    private let typeImage = String(kUTTypeImage)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        handleIncomingData()
    }
    
    
    func handleIncomingData() {
        let content = extensionContext!.inputItems[0] as! NSExtensionItem
        let contentType = kUTTypeImage as String
        for attachment in content.attachments! {
            if attachment.hasItemConformingToTypeIdentifier(contentType) {
                attachment.loadItem(forTypeIdentifier: contentType, options: nil) { data, error in
                    if error == nil {
                        let url = data as! NSURL
                        if let imageData = NSData(contentsOf: url as URL) {
                            print("Here 1:: \(imageData)")
                            if let prefs = UserDefaults(suiteName: self.groupName) {
                                prefs.removeObject(forKey: "Image")
                                prefs.set(imageData, forKey: "Image")
                            }
                        } else {
                            self.showMessage(title: "Error", message: "Couldn't load the image", VC: self)
                        }
                    }
                }
            }
        }
        
        self.openMainApp()
        
    }
    
    func showMessage(title: String, message: String, VC: UIViewController) {
        let alert: UIAlertController = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { UIAlertAction in
        }
        alert.addAction(okAction)
        VC.present(alert, animated: true, completion: nil)
    }
    
    private func openMainApp() {
        self.extensionContext?.completeRequest(returningItems: nil, completionHandler: { _ in
            guard let url = URL(string: self.appURL) else { return }
            _ = self.openURL(url)
        })
    }
    
    @objc private func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application.perform(#selector(openURL(_:)), with: url) != nil
            }
            responder = responder?.next
        }
        return false
    }
}
