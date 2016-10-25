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

  @IBAction func accept(_ sender: AnyObject) {
    self.authenticate()
  }

  func signDocument() {
    let urlString = "http://52.65.146.41:3001/api/document/eb0a6886-8da2-4240-aab6-a7599ed4993f/accept/1"
    let fullUrl = URL(string: urlString)!
    var request = URLRequest(url: fullUrl, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 30)
    request.httpMethod = "PUT"

    let session = URLSession(configuration: .default, delegate: nil, delegateQueue: nil)
    let dataTask = session.dataTask(with: request)
    dataTask.resume()

    showAlertWithTitle("Awesome", message: "The document has been signed.")
  }

  @IBAction func reject(_ sender: AnyObject) {
    exit(0)
  }

  override func viewDidAppear(_ animated: Bool) {
    showPdf()
  }

  func showPdf() {
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

  func authenticate() {
    let context = LAContext()
    var error: NSError?
    guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
      showAlertViewIfNoBiometricSensorHasBeenDetected()
      return
    }

    evaluate(context)
  }

  func evaluate(_ context: LAContext) {
    context.evaluatePolicy(
      .deviceOwnerAuthenticationWithBiometrics,
      localizedReason: "Please authenticate to sign this document.",
      reply: { [unowned self] (success, error) -> Void in
        if (success) {
          self.signDocument()
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
    let alertVC = alertController(title: title, message: message)
    DispatchQueue.main.async { self.present(alertVC, animated: true, completion: nil) }
  }

  func alertController(title: String, message: String) -> UIAlertController {
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alertVC.addAction(okAction)
    return alertVC
  }
}

