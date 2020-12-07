//
//  TapWebView.swift
//  LENZZO
//
//  Created by Apple on 9/26/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import WebKit
import Kingfisher
import AlamofireImage
import SwiftyJSON
import IQKeyboardManagerSwift

class TapWebView: UIViewController, WKNavigationDelegate, UIScrollViewDelegate{
    var param = [String:String]()
    var urlString = String()
    var user_id = KeyConstant.sharedAppDelegate.getUserId()
    
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        self.webView.scrollView.delegate = self
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        MBProgress().showIndicator(view: self.view)
        
        
        self.webView.load(URLRequest(url: URL(string:urlString)!))
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        //MBProgress().hideIndicator(view: self.view)
        
    }
    
    @IBAction func buttonBack(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) // show indicator
    {
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return nil
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        MBProgress().hideIndicator(view: self.view)
        if let currentURL = webView.url?.absoluteString{
            print(currentURL)
            if(currentURL.contains("/payment_by_tap/response?tap_id="))
            {
                DispatchQueue.main.async {
                    MBProgress().hideIndicator(view: self.view)
                }
                let cURL: String = currentURL
                let tapID = cURL.components(separatedBy: "tap_id=")
                if(tapID.count > 1)
                {
                    self.updateAPI(tapID: tapID[1])
                }
                else
                {
                    self.updateAPI(tapID: "")
                }
                
            }
        }
    }
    
    func updateAPI(tapID:String)
    {
        
        param["tap_id"] = tapID
        
        MBProgress().showIndicator(view: self.view)
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIPayment_by_tap, params: param, completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            DispatchQueue.main.async {
                MBProgress().hideIndicator(view: self.view)
            }
            if(!(err == nil))
            {
                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: err?.localizedDescription ?? NSLocalizedString("MSG21", comment: ""))
                
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                var message = json["message"].string
                
                if(HelperArabic().isArabicLanguage())
                {
                    if let msg = json["message_ar"].string
                    {
                        if( msg.count > 0)
                        {
                            message = msg
                        }
                    }
                }
                
                let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
                let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
                let msgAttrString = NSMutableAttributedString(string: message ?? NSLocalizedString("MSG233", comment: ""), attributes: msgFont)
                alertView.setValue(msgAttrString, forKey: "attributedMessage")
                let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
                    
                    KeyConstant.sharedAppDelegate.setRoot()
                    
                    
                    
                }
                alertAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
                
                alertView.addAction(alertAction)
                self.present(alertView, animated: true, completion: nil)
                
                
                
            }
            else
            {
                var message = json["message"].string
                
                if(HelperArabic().isArabicLanguage())
                {
                    if let msg = json["message_ar"].string
                    {
                        if( msg.count > 0)
                        {
                            message = msg
                        }
                    }
                }
                KeyConstant.sharedAppDelegate.showAlertView(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: message ?? NSLocalizedString("MSG21", comment: ""))
            }
            
        })
        
        
        
        
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        DispatchQueue.main.async {
            MBProgress().hideIndicator(view: self.view)
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
