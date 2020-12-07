//
//  ForgotPasswordVC.swift
//  LENZZO
//
//  Created by Apple on 8/30/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit

class ForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var imageViewLogo: UIImageView!
    
    
    @IBOutlet weak var resetPasswordBtn: UIButton!
    @IBOutlet weak var resetPassdSummary: PaddingLabel!
    @IBOutlet weak var arrowImgView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textFieldEmail: RoundTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwip))
        
        if(HelperArabic().isArabicLanguage())
        {
            
            swipeRight.direction = UISwipeGestureRecognizer.Direction.left
            
        }
        else
        {
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        }
        
        if(HomeInfoModel.sharedInstance.appHeaderLogo.count > 0)
        {
            let urlString = HomeInfoModel.sharedInstance.appHeaderLogo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            
//            imageViewLogo.kf.setImage(with: URL(string: urlString!)!, placeholder: UIImage.init(named: "logo (3)"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
//                if(downloadImage != nil)
//                {
//                    self.imageViewLogo.image = downloadImage
//                }
//            })
        }
        
        self.view.addGestureRecognizer(swipeRight)
        
        
        // Do any additional setup after loading the view.
                self.changeTintAndThemeColor()
            
        textFieldEmail.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        resetPassdSummary.font = UIFont(name: FontLocalization.medium.strValue, size: 14.0)
        resetPasswordBtn.titleLabel?.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(HelperArabic().isArabicLanguage())
        {
         self.arrowImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
        else
        {
        self.arrowImgView.transform = CGAffineTransform(rotationAngle: 245)
        }
    }
        
        
        func changeTintAndThemeColor(){
            
            self.arrowImgView.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
            self.arrowImgView.tintColor = .white
            
          
            
        }
    
    
    
    override func viewWillLayoutSubviews() {
        self.textFieldEmail.bottomBorderColor = UIColor.white
        
        
        
    }
    @IBAction func butttonBack(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
        
    }
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            self.butttonBack(UIButton())
            
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @IBAction func buttonSubmit(_ sender: Any) {
        guard let email = textFieldEmail.text, (!(email.isEmpty)) else
            
        {
            KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG2", comment: ""),textField: textFieldEmail)
            return
        }
        guard let emailValid = textFieldEmail.text, (emailValid.isValidEmail()) else
        {
            KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG6", comment: ""),textField:textFieldEmail)
            return
        }
        
        SignupViewModel().forgotPassword(vc: self, params: ["email":textFieldEmail.text ?? ""])
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
