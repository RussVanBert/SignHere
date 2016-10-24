//
//  ViewController.swift
//  SignHere
//
//  Created by Russell Van Bert on 24/10/2016.
//  Copyright © 2016 RV. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

  @IBOutlet var webView: UIWebView!
  @IBOutlet weak var authoriseButton: UIButton!
  @IBOutlet weak var thumbImage: UIImageView!

  override func viewDidLoad() {
    webView.scalesPageToFit = true
  }

  override func viewDidAppear(_ animated: Bool) {
    let targetURL = Bundle.main.url(forResource: "sample", withExtension: "pdf")!
    let data: Data?
    do {
      data = try Data(contentsOf: targetURL, options: .uncached)
      let baseUrl = targetURL.deletingLastPathComponent()
      webView.load(data!, mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: baseUrl)
    } catch _ {
      print("Whoa.. a bug.")
    }
  }

  @IBAction func authorise(_ sender: UIButton) {
    let context = LAContext()
    var error: NSError?
    guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
      showAlertViewIfNoBiometricSensorHasBeenDetected()
      return
    }
    
    evaluate(context, sender)
  }
  
  func evaluate(_ context: LAContext, _ sender: UIButton) {
    context.evaluatePolicy(
      .deviceOwnerAuthenticationWithBiometrics,
      localizedReason: "Sign this document?",
      reply: { [unowned self] (success, error) -> Void in
        if (success) {
          self.showAlertWithTitle("Awesome", message: "Thanks for signing this document.")
          
        } else {
          if let error = error {
            self.showAlertWithTitle("Error", message: error.localizedDescription)
          }
        }
      }
    )
  }
  
  func showAlertViewIfNoBiometricSensorHasBeenDetected(){
    showAlertWithTitle("Error", message: "This device does not have a TouchID sensor.")
  }
  
  func showAlertWithTitle(_ title:String, message:String ) {
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertVC.addAction(okAction)
    
    DispatchQueue.main.async {
      self.present(alertVC, animated: true, completion: nil)
    }
  }
}

