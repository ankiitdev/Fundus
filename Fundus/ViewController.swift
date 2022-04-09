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
        print("Button Clicked")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
}

