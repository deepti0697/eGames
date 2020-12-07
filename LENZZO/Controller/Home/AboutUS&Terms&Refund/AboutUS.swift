//
//  AboutUS.swift
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


class AboutUS: UIViewController, WKNavigationDelegate, UIScrollViewDelegate {
    @IBOutlet weak var buttonMenu: UIButton!
    var titleArray = [String]()
    @IBOutlet weak var labelCountCart: UILabel!
    var htmlString = String()
    var titleString = String()
    var typeCMSAPI = String()
    var webURL = String()

    
    @IBOutlet weak var labelTitle: PaddingLabel!
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.buttonMenu.addTarget(self, action:#selector(backAction), for: .touchUpInside)
        self.textView.isEditable = false
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwip))
           
         if(HelperArabic().isArabicLanguage())
        {
           
            swipeRight.direction = UISwipeGestureRecognizer.Direction.left

        }
        else
        {
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        }
        
        
        self.view.addGestureRecognizer(swipeRight)
        

        self.labelTitle.text = titleString
//        webView.loadHTMLString(htmlString, baseURL: nil)
        webView.isHidden = true
        textView.isHidden = false
        
        if(self.typeCMSAPI.count > 0)
        {
            if(typeCMSAPI == "social")
            {
                webView.isHidden = false
                textView.isHidden = true
                webView.navigationDelegate = self
                self.webView.scrollView.delegate = self
               MBProgress().showIndicator(view: self.view)
                print(webURL)
                var url = webURL
                if(!(webURL.contains("https://")))
                {
                    url = "https://" + url
                }
                webView.load(URLRequest(url: URL(string: url) ?? URL(string: "https://google.com")!))


            }
            else
            {
                self.getCMSData()
            }
        }
        else
        {
        textView.text = htmlString.html2String
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        labelCountCart.text = ""
        
        
         CartViewModel().viewCartList(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result:[JSON], totalCount:String ,error:Error?) in
            
            self.labelCountCart.text = ""
        
            
            
            if(result.count > 0)
            {
                print(result.count)
                self.labelCountCart.text = totalCount
                
            }})
        
       // MBProgress().showIndicator(view: self.view)
       
        
    }
    
    func getCMSData()
    {
        
        MBProgress().showIndicator(view: self.view)
        
     
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APICMSDetails, params: ["seourl":typeCMSAPI], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            DispatchQueue.main.async {
                MBProgress().hideIndicator(view: self.view)
            }
            if(!(err == nil))
            {
                self.textView.text = self.htmlString.html2String

                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                if let stringData = json["response"]["cms_detail_Array"]["cms_detail"]["description"].string
                {
                    if(stringData.count > 0)
                    {
                        self.textView.text = stringData.html2String
                        
                    }
                }
                if(HelperArabic().isArabicLanguage())
                {
                    if let stringData = json["response"]["cms_detail_Array"]["cms_detail"]["description_ar"].string
                    {
                        if(stringData.count > 0)
                        {
                            self.textView.text = stringData.html2String
                        }
                    }
                }
            }
            else
            {
            self.textView.text = self.htmlString.html2String
            }
            
        })
        
        
        
    }
    
    @objc func backAction(sender:UIButton)
    {
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            self.backAction(sender: UIButton())

        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @IBAction func buttoCart(_ sender: Any) {
        
        let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
        self.present(myCartVC, animated: false, completion: nil)
    }
    @IBAction func buttoSort(_ sender: Any) {
        
        KeyConstant.sharedAppDelegate.showSearchScreen(vc: self)
        
    }
    @IBAction func buttonFilter(_ sender: Any) {
        KeyConstant.sharedAppDelegate.showFilterScreen(vc: self)
        
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
        DispatchQueue.main.async {
            MBProgress().hideIndicator(view: self.view)
        }
        if let currentURL = webView.url?.absoluteString{
            print(currentURL)
            
        }
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
