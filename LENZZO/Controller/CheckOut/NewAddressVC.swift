//
//  NewAddressVC.swift
//  LENZZO
//
//  Created by Apple on 9/10/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON
import IQKeyboardManagerSwift
import CoreLocation
class NewAddressVC: UIViewController,UITextFieldDelegate,UITextViewDelegate,CLLocationManagerDelegate {
    var user_id = KeyConstant.sharedAppDelegate.getUserId()

    @IBOutlet weak var backImgView: UIImageView!
    @IBOutlet weak var imageMapIcon: UIImageView!
    @IBOutlet weak var imageBubbleIcon: UIImageView!
    @IBOutlet weak var labelTitlShareLoca: PaddingLabel!
    @IBOutlet weak var labelHouseRequired: UILabel!
    @IBOutlet weak var labelStreetRequired: UILabel!
    @IBOutlet weak var labelBlockRequired: UILabel!
    @IBOutlet weak var labelAreaRequired: UILabel!
    @IBOutlet weak var textFieldPACI: UITextField!
    @IBOutlet weak var viewSharedLocation: UIView!
    @IBOutlet weak var scrollContentHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var viewBubble: UIView!
    @IBOutlet weak var heightConstrintTopSharedView: NSLayoutConstraint!
    @IBOutlet weak var viewTopSharedLocation: UIView!
    @IBOutlet weak var currentSharedLong: UITextField!
    @IBOutlet weak var currentLatitude: UITextField!
    @IBOutlet weak var topConstantArea: NSLayoutConstraint!
    @IBOutlet weak var currentLocationName: UITextField!
    @IBOutlet weak var heightconstantSharedView: NSLayoutConstraint!
    @IBOutlet weak var buttonSharedLocation: UIButton!
    //@IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textFieldName: UITextField!
     @IBOutlet weak var textFieldArea: UITextField!
     @IBOutlet weak var textFieldBlock: UITextField!
     @IBOutlet weak var textFieldStreet: UITextField!
     @IBOutlet weak var textFieldAvenue: UITextField!
     @IBOutlet weak var textFieldHouse: UITextField!
     @IBOutlet weak var textFieldFloorNum: UITextField!
     @IBOutlet weak var textFieldFlatNum: UITextField!
     @IBOutlet weak var textFieldPhoneNumber: UITextField!
    
    @IBOutlet weak var imageBubble: UIImageView!
    @IBOutlet weak var textViewComments: IQTextView!
    @IBOutlet weak var labelStep: PaddingLabel!
    @IBOutlet weak var labelCountCart: UILabel!
   
    @IBOutlet weak var fullNameLbl: PaddingLabel!
    
    @IBOutlet weak var currentLocationLbl: PaddingLabel!
    @IBOutlet weak var currentLatitudeLbl: PaddingLabel!
    
    @IBOutlet weak var newAddressLbl: PaddingLabel!
    @IBOutlet weak var checkOutTitleLbl: PaddingLabel!
    @IBOutlet weak var shippingAddreLbl: PaddingLabel!
    
    @IBOutlet weak var currentLongitudeLbl: PaddingLabel!
    
    @IBOutlet weak var areaLbl: PaddingLabel!
    
    @IBOutlet weak var blockLbl: PaddingLabel!
    
    @IBOutlet weak var streetLbl: PaddingLabel!
    @IBOutlet weak var avenueLbl: PaddingLabel!
    
    @IBOutlet weak var houseBldLbl: PaddingLabel!
    
    @IBOutlet weak var floorLbl: PaddingLabel!
    
    
    @IBOutlet weak var flatLbl: PaddingLabel!
    
    @IBOutlet weak var phoneNumberLbl: PaddingLabel!
    
    @IBOutlet weak var PaciLbl: PaddingLabel!
    
    @IBOutlet weak var commentsLbl: PaddingLabel!
    
    
    @IBOutlet weak var buttonSave: UIButton!
    let locationManager = CLLocationManager()
    var locationLati = 0.0
    var locationLon = 0.0
    var locationName = ""
    var dicEditData = [String:JSON]()
    lazy var geocoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.isHidden = true
        
       self.labelTitlShareLoca.text = NSLocalizedString("MSG352", comment: "")
        
        textFieldArea.isUserInteractionEnabled = true
        currentLatitude.isUserInteractionEnabled = false
        currentSharedLong.isUserInteractionEnabled = false
        currentLocationName.isUserInteractionEnabled = true

      // tableView.tableFooterView = UIView()
        self.textFieldName.addPadding(.left(10))
        self.currentSharedLong.addPadding(.left(10))
        self.currentLocationName.addPadding(.left(10))
        self.currentLatitude.addPadding(.left(10))

        self.textFieldArea.addPadding(.left(10))
        self.textFieldBlock.addPadding(.left(10))
        self.textFieldStreet.addPadding(.left(10))
        self.textFieldAvenue.addPadding(.left(10))
        self.textFieldHouse.addPadding(.left(10))
        self.textFieldFloorNum.addPadding(.left(10))
        self.textFieldFlatNum.addPadding(.left(10))
        self.textFieldPhoneNumber.addPadding(.left(10))
        self.textFieldPACI.addPadding(.left(10))
        self.textFieldPACI.keyboardType = .asciiCapableNumberPad
        self.textFieldPhoneNumber.keyboardType = .asciiCapableNumberPad


        self.viewSharedLocation.isHidden = true
        self.heightconstantSharedView.constant = 0
        self.currentLocationName.text = ""
        self.currentSharedLong.text = ""
        self.currentLatitude.text = ""
        self.locationLon = 0.0
        self.locationLati = 0.0
        self.textViewComments.text = NSLocalizedString("MSG271", comment: "")
        self.textViewComments.textColor = .lightGray
        self.textViewComments.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10);
        
        if(dicEditData.count > 0)
        {
            buttonSave.setTitle(NSLocalizedString("MSG211", comment: ""), for: .normal)
            
            self.displayData()
            
        }
        else
        {
            buttonSave.setTitle(NSLocalizedString("MSG212", comment: ""), for: .normal)
        }
        
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
        

        
        if(HelperArabic().isArabicLanguage())
        {
            
            imageBubbleIcon.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            imageBubble.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)

            self.textViewComments.textAlignment = .right
           textFieldName.textAlignment = .right
            self.textFieldArea.textAlignment = .right
            self.textFieldBlock.textAlignment = .right
            self.textFieldStreet.textAlignment = .right
            self.textFieldAvenue.textAlignment = .right
            self.textFieldHouse.textAlignment = .right
            self.textFieldFloorNum.textAlignment = .right
            self.textFieldFlatNum.textAlignment = .right
            self.textFieldPhoneNumber.textAlignment = .right
            self.textFieldPACI.textAlignment = .right
            
        }
        else
        {
          

            self.textViewComments.textAlignment = .left
            textFieldName.textAlignment = .left
            self.textFieldArea.textAlignment = .left
            self.textFieldBlock.textAlignment = .left
            self.textFieldStreet.textAlignment = .left
            self.textFieldAvenue.textAlignment = .left
            self.textFieldHouse.textAlignment = .left
            self.textFieldFloorNum.textAlignment = .left
            self.textFieldFlatNum.textAlignment = .left
            self.textFieldPhoneNumber.textAlignment = .left
            self.textFieldPACI.textAlignment = .left
            
        }
        
        self.setPermissionAlert()
        // Do any) additional setup after loading the view.
        self.setFontType()
    }
    
    
    func setFontType(){
        self.commentsLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.PaciLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.phoneNumberLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.flatLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.floorLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.houseBldLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.avenueLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.streetLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.blockLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.areaLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.currentLongitudeLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.currentLatitudeLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.fullNameLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 16.0)
        self.labelStep.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        self.buttonSave.titleLabel?.font = UIFont(name: FontLocalization.medium.strValue, size: 17.0)
        self.shippingAddreLbl.font = UIFont(name: FontLocalization.Bold.strValue, size: 15.0)
        self.newAddressLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 13.0)
        self.checkOutTitleLbl.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.textFieldName.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.currentLocationName.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.textFieldPACI.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.currentSharedLong.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        self.currentLatitude.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
    
        
        
        textFieldName.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        textFieldArea.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        textFieldBlock.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        textFieldStreet.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        textFieldAvenue.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        textFieldHouse.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        textFieldFloorNum.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        textFieldFlatNum.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        textFieldPhoneNumber.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        textViewComments.font = UIFont(name: FontLocalization.medium.strValue, size: 15.0)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width - 20, height:1000)
        self.scrollContentHeightCons.constant = 1000
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.backImgView.image = UIImage(named: "arrow")?.withRenderingMode(.alwaysTemplate)
        self.backImgView.tintColor = .white
        getCartList()
        if(HelperArabic().isArabicLanguage())
        {
         self.backImgView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            
        }
        else
        {
        self.backImgView.transform = CGAffineTransform(rotationAngle: 245)
        }
       // self.viewBubble.isHidden = true
        self.viewTopSharedLocation.isHidden = true
       self.heightConstrintTopSharedView.constant = 0
//        if let strCountryCode = KeyConstant.user_Default.value(forKey: KeyConstant.kuserCountryCode) as? String
//        {
//            if(strCountryCode.replacingOccurrences(of: "+", with: "") == "965")
//            {
                self.locationManager.requestAlwaysAuthorization()
                // For use in foreground
                self.locationManager.requestWhenInUseAuthorization()
                self.viewTopSharedLocation.isHidden = true
                self.heightConstrintTopSharedView.constant = 0
                self.viewBubble.isHidden = false

     //       }
     //   }
       
        
    }
    
//    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
//        // Update View
//
//        if let error = error {
//            print("Unable to Reverse Geocode Location (\(error))")
//            self.currentLocationName.text = "Unable to Find Address for Location"
//
//        } else {
//            if let placemarks = placemarks, let placemark = placemarks.first {
//                currentLocationName.text = placemark.name
//            } else {
//                currentLocationName.text = "No Matching Addresses Found"
//            }
//        }
//    }
    
    func hideAreaRequired(isHidden:Bool)
    {
        self.labelAreaRequired.isHidden = isHidden
        self.labelBlockRequired.isHidden = isHidden
        self.labelHouseRequired.isHidden = isHidden
        self.labelStreetRequired.isHidden = isHidden

    }
  
    func setPermissionAlert()
    {
        let alertController = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
        
      
        let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
        
        let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG241", comment: ""), attributes: msgFont)
        
        alertController.setValue(msgAttrString, forKey: "attributedMessage")
        
        
        let settingsAction = UIAlertAction(title: NSLocalizedString("MSG242", comment: ""), style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("MSG53", comment: ""), style: .default, handler: nil)
        cancelAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")
        settingsAction.setValue(AppColors.SelcetedColor, forKey: "titleTextColor")

        
        alertController.addAction(cancelAction)
        alertController.addAction(settingsAction)
        alertController.view.tintColor = UIColor.black
        alertController.view.layer.cornerRadius = 40
        alertController.view.backgroundColor = UIColor.white
      
        // check the permission status
        switch(CLLocationManager.authorizationStatus()) {
        case .authorizedAlways, .authorizedWhenInUse: break
        // get the user location
        case .notDetermined, .restricted, .denied:
            // redirect the users to settings
            DispatchQueue.main.async(execute: {
                
                self.present(alertController, animated: true, completion: nil)
            })
            
        }
    }
    
    func displayData()
   {
    self.textFieldName.text = dicEditData["full_name"]?.string ?? ""
    self.textFieldArea.text = dicEditData["area"]?.string ?? ""
    self.textFieldStreet.text = dicEditData["street"]?.string ?? ""
    self.textFieldBlock.text = dicEditData["block"]?.string ?? ""
    self.textFieldAvenue.text = dicEditData["avenue"]?.string ?? ""
    self.textFieldHouse.text = dicEditData["house_no"]?.string ?? ""
    self.textFieldFloorNum.text = dicEditData["floor_no"]?.string ?? ""
    self.textFieldFlatNum.text = dicEditData["flat_no"]?.string ?? ""
    self.textFieldPhoneNumber.text = dicEditData["phone_no"]?.string ?? ""
    self.textFieldPACI.text = dicEditData["paci_number"]?.string ?? ""
    
    if let comments = dicEditData["comments"]?.string
    {
        if(comments.count > 0)
        {
            self.textViewComments.text = comments
            self.textViewComments.textColor = .black

        }
    }
    
    locationLati = Double(dicEditData["latitude"]?.string ?? "0.0") ?? 0.0
    locationLon = Double(dicEditData["longitude"]?.string ?? "0.0") ?? 0.0

  
    if(dicEditData["currrent_location"]?.string?.count ?? 0 > 0)
    {
        self.currentLocationName.text = dicEditData["currrent_location"]?.string ?? "0.0"
        self.currentLatitude.text = dicEditData["latitude"]?.string ?? "0.0"
        self.currentSharedLong.text = dicEditData["longitude"]?.string ?? "0.0"
        self.viewSharedLocation.isHidden = false
        self.viewTopSharedLocation.isHidden = true
        self.heightconstantSharedView.constant = 219
        self.heightConstrintTopSharedView.constant = 0
        self.scrollView.setNeedsLayout()
        self.scrollView.layoutIfNeeded()
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width - 20, height:1800)
        self.scrollContentHeightCons.constant = 1800
        self.scrollView.setNeedsLayout()
        self.scrollView.layoutIfNeeded()
        self.viewBubble.isHidden = false


    }
    
    }
    
  
    func getCartList()
    {
        labelCountCart.text = ""
        
      
             CartViewModel().viewCartList(vc: self, param: ["user_id":KeyConstant.sharedAppDelegate.getUserId()], completionHandler: { (result:[JSON], totalCount:String ,error:Error?) in
            
            self.labelCountCart.text = ""
        
                
                
                if(result.count > 0)
                {
                    self.labelCountCart.text = totalCount
                    
                    print(result.count)
                }})
        
    }
    
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            self.buttonBackAction(UIButton())

        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    @IBAction func buttonBackAction(_ sender: Any) {
        //self.dismiss(animated: false, completion: nil)
        self.dismiss(animated: false, completion: nil)
    }
   
    @IBAction func buttonCartList(_ sender: Any) {
        
        let myCartVC = self.storyboard?.instantiateViewController(withIdentifier: "MyCartVC") as! MyCartVC
        self.present(myCartVC, animated: false, completion: nil)
    }
    
    
    @IBAction func buttonCurrentLocation(_ sender: Any) {
        self.setPermissionAlert()
        self.hideAreaRequired(isHidden: true)
        self.viewBubble.isHidden = true

        self.viewTopSharedLocation.isHidden = true
        self.heightConstrintTopSharedView.constant = 0

        self.viewSharedLocation.isHidden = false
        self.heightconstantSharedView.constant = 219
        self.viewBubble.isHidden = true

    
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width - 20, height:1600)
        self.scrollContentHeightCons.constant = 1600
       
//        guard let lat = Double("26.4585314") else { return  }
//        guard let lng = Double("79.5170627") else { return }
//        let location = CLLocation(latitude: lat, longitude: lng)
//
//        // Geocode Location
//        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
//            // Process Response
//            self.processResponse(withPlacemarks: placemarks, error: error)
//        }
        //self.topConstantArea.constant =
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
       
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if(locations.count > 0)
        {
        let userLocation :CLLocation = locations[0] as CLLocation
        
      

        guard let loc: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            if let placemark1 = placemarks as? [CLPlacemark]
            {
            if placemark1.count>0{
                let placemark = placemark1[0]
           
                
                if(self.viewSharedLocation.isHidden == false)
                {
                    
                    self.locationLati = loc.latitude
                    self.locationLon = loc.longitude
                    
                    
               self.currentLocationName.text = "\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.subLocality ?? ""),\(placemark.administrativeArea ?? ""), \(placemark.country ?? ""), \(placemark.postalCode ?? "")"
                    
                    self.currentSharedLong.text = String(format:"%f",loc.latitude )
                    self.currentLatitude.text = String(format:"%f",loc.longitude )

                }
                self.locationManager.stopUpdatingLocation()

            }
            }
        }
        }
    }
    
    @IBAction func buttonCloseSharedLocation(_ sender: Any) {
        self.viewBubble.isHidden = false

        self.hideAreaRequired(isHidden: false)
        self.viewSharedLocation.isHidden = true
        self.heightconstantSharedView.constant = 0
        self.currentLocationName.text = ""
        self.currentSharedLong.text = ""
        self.currentLatitude.text = ""
        self.locationLon = 0.0
        self.locationLati = 0.0
        self.scrollView.setNeedsLayout()
        self.scrollView.layoutIfNeeded()
        self.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width - 20, height:1000)
        self.scrollContentHeightCons.constant = 1000
        self.scrollView.setNeedsLayout()
        self.scrollView.layoutIfNeeded()
        
        
        //self.topConstantArea.constant =
    }
    
    @IBAction func buttonSave(_ sender: Any) {
        
       // APIAddAddress
//        guard let name = textFieldName.text, (!(name.isEmpty)) else
//            
//        {
//            KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG1", comment: ""),textField:textFieldName )
//            return
//        }
        
//        if(self.currentLocationName.text?.count == 0 && self.viewSharedLocation.isHidden == true)
//        {
//            guard let area = textFieldArea.text, (!(area.isEmpty)) else
//
//            {
//                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG208", comment: ""),textField:textFieldArea )
//                return
//            }
//            guard let block = textFieldBlock.text, (!(block.isEmpty)) else
//
//            {
//                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG220", comment: ""),textField:textFieldBlock )
//                return
//            }
//            guard let street = textFieldStreet.text, (!(street.isEmpty)) else
//
//            {
//                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG221", comment: ""),textField:textFieldStreet )
//                return
//            }
//            guard let house = textFieldHouse.text, (!(house.isEmpty)) else
//
//            {
//                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG222", comment: ""),textField:textFieldHouse )
//                return
//            }
//        }
//        else
//        {
//            guard let area = currentLocationName.text, (!(area.isEmpty)) else
//
//            {
//                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG247", comment: ""),textField:UITextField() )
//                return
//            }
//        }
       
        guard let phone = textFieldPhoneNumber.text, (!(phone.isEmpty)) else
            
        {
            KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG3", comment: ""),textField: textFieldPhoneNumber)
            return
        }
        guard let mobile = textFieldPhoneNumber.text, (!(mobile.isEmpty) && mobile.count > 7)
            else {
                if let strCountryCode = KeyConstant.user_Default.value(forKey: KeyConstant.kuserCountryCode) as? String
                {
                if(strCountryCode == "+965")
                {
                    KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG213", comment: ""),textField:textFieldPhoneNumber )
                }
                    else
                {
                    KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG219", comment: ""),textField:textFieldPhoneNumber )
                    }
                }
                else
                {
                    KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG219", comment: ""),textField:textFieldPhoneNumber )
                }
                return
        }
        

//        if (textFieldPACI.text!.isEmpty)
//        {
//
//
//            guard let house = textFieldHouse.text, (!(house.isEmpty)) else
//
//            {
//                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG378", comment: ""),textField:textFieldHouse )
//                return
//            }
//            guard let floor = textFieldFloorNum.text, (!(floor.isEmpty)) else
//
//            {
//                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG379", comment: ""),textField:textFieldFloorNum )
//                return
//            }
//            guard let flat = textFieldFlatNum.text, (!(flat.isEmpty)) else
//
//            {
//                KeyConstant.sharedAppDelegate.showAlertViewWithTextField(vc: self,titleString:NSLocalizedString("MSG31", comment: ""), messageString: NSLocalizedString("MSG380", comment: ""),textField:textFieldFlatNum )
//                return
//            }
//
//
//        }
//
             var comments  = ""
            let phoneNumber = textFieldPhoneNumber.text ?? ""
            if(textViewComments.textColor == .black)
            {
                comments = textViewComments.text ?? ""
            }
            
            let cLocation = self.currentLocationName.text ?? ""
            let paci = self.textFieldPACI.text ?? ""

            var params = ["full_name":textFieldName.text ?? "","area":textFieldArea.text ?? "","block":textFieldBlock.text ?? "","street":textFieldStreet.text ?? "","avenue":textFieldAvenue.text ?? "","house_no":textFieldHouse.text ?? "","floor_no":textFieldFloorNum.text ?? "","flat_no":textFieldFlatNum.text ?? "","phone_no":phoneNumber,"comments": comments,"latitude":String(format:"%.2f",locationLati), "longitude":String(format:"%.2f",locationLon),"user_id":user_id,"currrent_location":cLocation,"paci_number":paci]
            
            //"currentLocation": self.currentLocationName.text ?? ""
            
            if(dicEditData.count > 0)
            {
            
                params["user_billing_address_id"] = dicEditData["id"]?.string ?? ""
                self.editAddress(param:params)
            }
            else
            {
                self.addNewAddress(param:params)
            }
        
    
    }
    
//    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?, _ userLocationName:CLLocation?)-> Void) {
//        let geocoder = CLGeocoder()
//        geocoder.geocodeAddressString(address) { (placemarks, error) in
//            guard let placemarks = placemarks,
//                let location = placemarks.first?.location else {
//
//                    return
//            }
//            completion(placemarks.first?.location?.coordinate,placemarks.first?.location)
//        }
//    }
    
    
    func addNewAddress(param:[String:String])
    {
        
        MBProgress().showIndicator(view: self.view)
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIAddAddress, params: param, completionHandler: { (result: [String:Any], err:Error?) in
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
                
              
                let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message: "", preferredStyle: .alert)
                let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
                let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG235", comment: ""), attributes: msgFont)
                alertView.setValue(msgAttrString, forKey: "attributedMessage")
                
                let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
                   
                        self.dismiss(animated: true, completion: nil)
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
        
        
        func editAddress(param:[String:String])
        {
            
            MBProgress().showIndicator(view: self.view)
            
            
            WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APIEditAddress, params: param, completionHandler: { (result: [String:Any], err:Error?) in
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
                    
                    
                    let alertView = UIAlertController(title: NSLocalizedString("MSG31", comment: "").uppercased(), message:"", preferredStyle: .alert)
                    let msgFont = [NSAttributedString.Key.font: UIFont(name: FontLocalization.medium.strValue, size: 15.0)!]
                    let msgAttrString = NSMutableAttributedString(string: NSLocalizedString("MSG236", comment: ""), attributes: msgFont)
                    alertView.setValue(msgAttrString, forKey: "attributedMessage")
                    let alertAction = UIAlertAction(title: NSLocalizedString("MSG18", comment: ""), style: .default) { (alert) in
                        
                        self.dismiss(animated: true, completion: nil)
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
        
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView == textViewComments)
        {
            if(textView.text == "") {
                
                
                textView.text = NSLocalizedString("MSG271", comment: "")
                textView.textColor = .lightGray
                
            }
        }
        
    }
    
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        
        if(textView == textViewComments)
        {
            textView.textColor = .black
            
            if(textView.text == NSLocalizedString("MSG271", comment: "")) {
                textView.text = ""
            }
        }
        
        
        return true
    }
    
 
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if(textField == textFieldArea)
//        {
//            tableView.isHidden = false
//        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if(textField == textFieldArea)
//        {
//            tableView.isHidden = true
//        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(textField == currentLocationName)
        {
            return false
        }
        
        if(textField == textFieldPhoneNumber)
        {
            var maxLength = 10
//            if let strCountryCode = KeyConstant.user_Default.value(forKey: KeyConstant.kuserCountryCode) as? String
//            {
//                if(strCountryCode == "+965")
//                {
//                    maxLength = 8
//                }
//            }
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
        if(textField == textFieldPACI)
        {
            var maxLength = 15
         
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        
//        if(textField == textFieldArea)
//        {
//            if(tableView.isHidden == true)
//            {
//                tableView.isHidden = false
//            }
//
//            self.locationName = ""
//            self.tableView.reloadData()
//
//            let currentString: NSString = textField.text as NSString? ?? ""
//            let newString: NSString =
//                currentString.replacingCharacters(in: range, with: string) as NSString
//            self.getLocation(from: newString as String) { location,userLocation  in
//               print("Location is", location.debugDescription)
//
//                self.locationLati = location?.latitude ?? 0.0
//                self.locationLon = location?.longitude ?? 0.0
//                let geocoder = CLGeocoder()
//                geocoder.reverseGeocodeLocation(userLocation!) { (placemarks, error) in
//                    if (error != nil){
//                        print("error in reverseGeocode")
//                    }
//                    let placemark = placemarks! as [CLPlacemark]
//                    if placemark.count>0{
//                        let placemark = placemarks![0]
//
//                         self.locationName = "\(placemark.name ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? ""), \(placemark.country ?? "") \(placemark.postalCode ?? "")"
//                        print(self.locationName)
//
//                        self.tableView.reloadData()
//                    }
//                }
//
//
//
//            }
//        }
        
        return true
    }
  
    
    
    
}

//extension NewAddressVC:UITableViewDelegate, UITableViewDataSource
//{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//
//
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LocationTableVCell
//         cell.labelLocationName.leftInset = 10.0
//        cell.labelLocationName.text = locationName
//        return cell
//
//    }
//
//
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//
//
//        return  50
//
//        //return  UITableView.automaticDimension
//
//
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        //self.textFieldArea.text = locationName
//        //tableView.isHidden = true
//
//
//    }
//
//
//
//
//
//
//
//}
class LocationTableVCell:UITableViewCell
{
    @IBOutlet weak var labelLocationName: PaddingLabel!

}
