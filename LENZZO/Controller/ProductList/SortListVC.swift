//
//  SortListVC.swift
//  LENZZO
//
//  Created by Apple on 9/19/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher
import AlamofireImage
import SwiftyJSON

protocol SelectedSortDelegate
{
    func updateSelected(index:[String:String])
}
class SortListVC: UIViewController {
    
    var arraySortType = [JSON]()
    var selectedType = [String:String]()
    var tempselectedIndex = -1
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortImgView: UIImageView!
    var delegateSort: SelectedSortDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sortImgView.image = UIImage(named: "sort")?.withRenderingMode(.alwaysTemplate)
        self.sortImgView.tintColor = .white
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
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        self.getSortData()
    }
    @IBAction func buttonDismiss(_ sender: Any) {
        self.backAction()
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.backAction()
        
    }
    
    
    func getSortData()
    {
        
        MBProgress().showIndicator(view: self.view)
        
        
        WebServiceHelper.sharedInstanceAPI.hitPostAPI(urlString: KeyConstant.APISortBy, params: [:], completionHandler: { (result: [String:Any], err:Error?) in
            print(result)
            DispatchQueue.main.async {
                
                MBProgress().hideIndicator(view: self.view)
            }
            if(!(err == nil))
            {
                
                
                return
            }
            let json = JSON(result)
            
            let statusCode = json["status"].string
            print(json)
            if(statusCode == "success")
            {
                
                print(result)
                self.arraySortType = json["response"]["sortlist_Array"]["sortlist"].array ?? [JSON]()
                
            }
            self.tableView.reloadData()
            
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
    
}
extension SortListVC:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arraySortType.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cellMenu = tableView.dequeueReusableCell(withIdentifier: "SortTVCell") as! SortTVCell
        
        cellMenu.labelTitle.text = arraySortType[indexPath.row]["title"].string ?? ""
        if(HelperArabic().isArabicLanguage())
        {
            if let title_ar =  arraySortType[indexPath.row]["title_ar"].string
            {
                cellMenu.labelTitle.text = title_ar
                
            }
            
        }
        if(tempselectedIndex == indexPath.row)
        {
            cellMenu.imageSelection.image = UIImage(named:"slect_100x100")
        }
        else if (selectedType["key"] == String(arraySortType[indexPath.row]["key"].string ?? "") && selectedType["value"] == String(arraySortType[indexPath.row]["value"].string ?? ""))
        {
            cellMenu.imageSelection.image = UIImage(named:"slect_100x100")
            
        }
        else
        {
            cellMenu.imageSelection.image = UIImage(named:"de_select_100x100")
            
        }
        
        cellMenu.buttonSelect.tag = indexPath.row
        cellMenu.buttonSelect.addTarget(self, action: #selector(buttonSelect), for: .touchUpInside)
        return cellMenu
        
        
    }
    
    
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            self.backButtonAction(UIButton())
            
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.showData(index: indexPath.row)
        
    }
    func showData(index:Int)
    {
        tempselectedIndex = index
        tableView.reloadData()
        let dic = ["key":arraySortType[index]["key"].string ?? "","value":arraySortType[index]["value"].string ?? ""]
        self.delegateSort.updateSelected(index: dic)
        self.backAction()
    }
    
    func backAction()
    {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func buttonSelect(sender:UIButton)
    {
        self.showData(index: sender.tag)
    }
    
    
    
    
    
    
}
