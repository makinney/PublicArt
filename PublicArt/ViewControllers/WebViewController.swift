//
//  WebViewController.swift
//  PublicArt
//
//  Created by Michael Kinney on 7/7/15.
//  Copyright (c) 2015 makinney. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

	@IBOutlet weak var webView: UIWebView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	var webViewAddress: String?
	
	override func viewDidLoad() {
        super.viewDidLoad()
		webView.delegate = self
		webView.scalesPageToFit = true
        // Do any additional setup after loading the view.
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let webViewAddress = webViewAddress,
			let url = URL.init(string: webViewAddress) {
				let urlRequest = URLRequest(url:url)
				webView.loadRequest(urlRequest)
				activityIndicator.startAnimating()
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		webView.stopLoading()
		activityIndicator.stopAnimating()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func webViewDidFinishLoad(_ webView: UIWebView) {
		activityIndicator.stopAnimating()
	}
	
}
