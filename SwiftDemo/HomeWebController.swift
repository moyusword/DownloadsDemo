//
//  HomeWebController.swift
//  SwiftDemo
//
//  Created by Chivalrous on 2019/1/22.
//  Copyright © 2019 ML. All rights reserved.
//

import WebKit

class HomeWebController: UIViewController, WKNavigationDelegate, WKUIDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var nameTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "首页"
        let customUA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0 Safari/605.1.15"
        webView.customUserAgent = customUA
        self.webView.navigationDelegate = self
        self.webView.load(URLRequest.init(url: URL.init(string: homeURLStr)!))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "继续阅读", style: .done, target: self, action: #selector(oldBooks))
    }
    
    //MARK: -- 继续阅读
    @objc private func oldBooks() {
        performSegue(withIdentifier: "startRead", sender: nil)
    }
    
    //MARK: -- webView delegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        let hostStr = navigationResponse.response.url?.absoluteString ?? ""
        print(hostStr)
        if !hostStr.contains("630book") {
            decisionHandler(.cancel)
            return
        }
        let sufStr = hostStr.components(separatedBy: "book_").last ?? ""
        if sufStr.hasSuffix(".html") && hostStr.contains("/") {
            print("跳转")
            UserDefaults.standard.set(hostStr, forKey: "NetBooks")
            UserDefaults.standard.synchronize()
            performSegue(withIdentifier: "startRead", sender: nil)
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
    }
    
}
