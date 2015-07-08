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
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		if let webViewAddress = webViewAddress,
			let url = NSURL.init(string: webViewAddress) {
				var urlRequest = NSURLRequest(URL:url)
				webView.loadRequest(urlRequest)
				activityIndicator.startAnimating()
		}
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		webView.stopLoading()
		activityIndicator.stopAnimating()
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	func webViewDidFinishLoad(webView: UIWebView) {
		activityIndicator.stopAnimating()
	}
	
}
