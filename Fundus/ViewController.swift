//
//  ViewController.swift
//  Fundus
//
//  Created by Ankit Sharma on 20/03/22.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView:  UIImageView!
    
    @IBAction func buttonUpload(_ sender: UIButton) {
        
        loadingIndicator.isHidden = false
        
        if textfield1.text!.isEmpty {
            loadingIndicator.isHidden = true
            showAlert(message: "Enter textField 1 content")
        } else if textfield2.text!.isEmpty {
            loadingIndicator.isHidden = true
            showAlert(message: "Enter textField 2 content")
        } else  {
            loadingIndicator.isHidden = false
            // add api call
        }
        
    }
    
    @IBOutlet weak var textfield1: UITextField!
    
    @IBOutlet weak var textfield2: UITextField!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicator.isHidden = true
        setupNotification()
    }
    
    @objc func fetchData() {
        if let prefs = UserDefaults(suiteName: "group.app.fundus.Fundus") {
            if let imageData = prefs.object(forKey: "Image") as? NSData {
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: imageData as Data)
                }
            }
            
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(fetchData),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchData()
        
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

