//
//  ViewController.swift
//  SignHere
//
//  Created by Russell Van Bert on 24/10/2016.
//  Copyright © 2016 RV. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet var webView: UIWebView!

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
}

