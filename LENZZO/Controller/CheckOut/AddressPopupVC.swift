//
//  AddressPopupVC.swift
//  LENZZO
//
//  Created by Apple on 9/12/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit

class AddressPopupVC: UIViewController {
  
    var address = String()
    var titleTop = String()

    @IBOutlet weak var labelTitle: PaddingLabel!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(address)
        self.labelTitle.text = titleTop
        //self.textView.text = address
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(rightSwip))
       
        textView.attributedText  = getAddress(stringAddress: address)
         if(HelperArabic().isArabicLanguage())
        {
            textView.textAlignment = .right
            swipeRight.direction = UISwipeGestureRecognizer.Direction.left

        }
        else
        {
            textView.textAlignment = .left
            swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        }
        
        
        self.view.addGestureRecognizer(swipeRight)
        textView.textColor = .white
        labelTitle.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        // Do any additional setup after loading the view.
    }
    
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            self.buttonCross(UIButton())

        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @IBAction func buttonCross(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
        
    }
    func getAddress(stringAddress:String)->NSAttributedString
    {
    
        
        let stringBold = [NSLocalizedString("MSG302", comment: ""),NSLocalizedString("MSG303", comment: ""),NSLocalizedString("MSG304", comment: ""),NSLocalizedString("MSG305", comment: ""),NSLocalizedString("MSG306", comment: ""),NSLocalizedString("MSG307", comment: ""),NSLocalizedString("MSG308", comment: ""),NSLocalizedString("MSG309", comment: ""),NSLocalizedString("MSG310", comment: ""),NSLocalizedString("MSG311", comment: ""),NSLocalizedString("MSG312", comment: ""),NSLocalizedString("MSG313", comment: "")]
      
        
        return stringAddress.withBoldTextParagraphLineSpace(arraytext: stringBold, font: UIFont.init(name: FontLocalization.medium.strValue, size: 13.0),boldFont:UIFont.init(name: FontLocalization.Bold.strValue, size: 13.0))
        
       
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
