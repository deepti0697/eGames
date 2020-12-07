//
//  ViewController.swift
//  LENZZO
//
//  Created by Rajshree on 13/03/20.
//  Copyright © 2020 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON
import AVFoundation
import AVKit

class ViewController: UIViewController
{
    
    
    
    let player = AVPlayer(url: NSURL(fileURLWithPath:  Bundle.main.path(forResource: "gauri", ofType:"mp4")!) as URL)
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.imgView.image = UIImage(named: "bg")
        self.imgView.isHidden = true
        self.view.backgroundColor = .black
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initVideo()
    }
    
    
    func initVideo(){
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.itemDidFinishPlaying(_:)), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
        DispatchQueue.main.async(execute: {() -> Void in
            let playerLayer = AVPlayerLayer(player: self.player)
            playerLayer.frame = self.mainView.bounds
            playerLayer.videoGravity = AVLayerVideoGravity.resize
            playerLayer.zPosition = 1
            self.mainView.layer.addSublayer(playerLayer)
            self.player.seek(to: CMTime.zero)
            self.player.play()
            self.imgView.isHidden = true
        })
    }
    
    @objc func itemDidFinishPlaying(_ notification: Notification?) {
        
        self.imgView.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            KeyConstant.sharedAppDelegate.setRoot()
        }
         
        //checkCountry()
        //move to whatever UIViewcontroller with a storyboard ID of "menu"
    }
    
    
    func checkCountry()
    {
        if let isCountrySelected = KeyConstant.user_Default.value(forKey: KeyConstant.kSelectedCountry) as? String
        {
            if(isCountrySelected.count > 0)
            {
                KeyConstant.sharedAppDelegate.setRoot()
                
                return
            }
        }
        
        KeyConstant.sharedAppDelegate.showCountryScreen(vc: self)
        
    }
}


/*
 
 @IBOutlet weak var imageLogo: UIImageView!
 
 override func viewDidLoad() {
 super.viewDidLoad()
 imageLogo.backgroundColor = UIColor.white
 imageLogo.alpha = 1.0
 
 self.getLaunchImage()
 // Do any additional setup after loading the view.
 }
 
 override func viewWillAppear(_ animated: Bool) {
 super.viewWillAppear(animated)
 
 
 }
 
 override func viewWillLayoutSubviews() {
 
 
 
 }
 /*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */
 
 
 func getLaunchImage()
 {
 
 //MBProgress().showIndicator(view: self.view)
 WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIGetLanchImage, params: [:], completionHandler: { (result: [String:Any], err:Error?) in
 print(result)
 DispatchQueue.main.async {
 MBProgress().hideIndicator(view: self.view)
 }
 if(!(err == nil))
 {
 self.pushSplash()
 
 
 }
 let json = JSON(result)
 
 let statusCode = json["status"].string
 print(json)
 if(statusCode == "success")
 {
 
 if let urlString = json["response"]["logo"].string?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
 {
 
 self.imageLogo.kf.setImage(with: URL(string:KeyConstant.kImageBaseBannerSliderURL + urlString), placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
 
 
 
 self.imageLogo.transform = CGAffineTransform(scaleX: 0.0,y: 0.0);
 
 UIView.animate(withDuration: 3.0, delay: 3.0, options: [.curveEaseInOut], animations: {
 
 self.imageLogo.transform = CGAffineTransform(scaleX: 1.0,y: 1.0);
 
 }){ (finished) in
 if finished {
 sleep(2)
 UIView.transition(with: self.imageLogo,
 duration: 2.0,
 options: .transitionFlipFromRight,
 animations: {
 
 self.imageLogo.image = downloadImage
 
 
 },
 completion: { _ in
 
 self.pushSplash()
 })
 
 }
 }})
 }
 else
 {
 self.pushSplash()
 
 }
 
 }
 else
 {
 self.pushSplash()
 }
 
 })
 
 
 
 }
 
 func pushSplash()
 {
 DispatchQueue.main.async {
 
 let splashVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SplashVC") as! SplashVC
 self.present(splashVC, animated: false, completion: nil)
 }
 }
 
 
 
 
 
 }
 */
