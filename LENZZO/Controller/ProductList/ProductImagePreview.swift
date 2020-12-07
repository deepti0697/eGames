//
//  ProductImagePreview.swift
//  LENZZO
//
//  Created by Apple on 8/19/19.
//  Copyright © 2019 LENZZO. All rights reserved.
//

import UIKit
import Kingfisher

class ProductImagePreview: UIViewController, UIScrollViewDelegate {
    var arrImageUrl = [String]()
    var currentIndex = Int()
    private var pageControl = UIPageControl(frame: .zero)
    
    @IBOutlet weak var imageViewT: UIImageView!
    @IBOutlet weak var scrollViewImage: UIScrollView!
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
        
        
        self.view.addGestureRecognizer(swipeRight)
        
        
        
        self.setupPageControl()
        pageControl.currentPage = currentIndex
        
        scrollViewImage.minimumZoomScale = 1.0
        scrollViewImage.maximumZoomScale = 10.0
        addSwipe()
        
        
        
        loadImage(index: currentIndex)
        
        // Do any additional setup after loading the view.
    }
    
    func loadImage(index:Int)
    {
        
        let urlString = arrImageUrl[index].addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        
        imageViewT.kf.setImage(with: URL(string: urlString!)!, placeholder: UIImage.init(named: "noImage"), options: [.transition(.fade(1))], progressBlock: nil, completionHandler: { (downloadImage, error, cacheType, url) in
            if(downloadImage != nil)
            {
                self.imageViewT.image = downloadImage!
            }
        })
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageViewT
    }
    @IBAction func buttonCancel(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    @objc func rightSwip(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            self.buttonCancel(UIButton())
            
        }
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func addSwipe() {
        let directions: [UISwipeGestureRecognizer.Direction] = [.right, .left]
        for direction in directions {
            let gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
            gesture.direction = direction
            self.view.addGestureRecognizer(gesture)
        }
    }
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                if(currentIndex > 0)
                {
                    currentIndex = currentIndex - 1
                    loadImage(index: currentIndex)
                    self.pageControl.currentPage = currentIndex
                }
                break
            case UISwipeGestureRecognizer.Direction.left:
                print("Swiped left")
                if(currentIndex < arrImageUrl.count - 1)
                {
                    currentIndex = currentIndex  + 1
                    loadImage(index: currentIndex)
                    self.pageControl.currentPage = currentIndex
                    
                }
                break
            default:
                break
            }
        }
    }
    
    private func setupPageControl() {
        
        pageControl.numberOfPages = arrImageUrl.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.hidesForSinglePage = true
        
        pageControl.currentPageIndicatorTintColor = AppColors.SelcetedColor
        pageControl.pageIndicatorTintColor = UIColor.lightGray.withAlphaComponent(0.8)
        
        let leading = NSLayoutConstraint(item: pageControl, attribute: .leading, relatedBy: .equal, toItem: imageViewT, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: pageControl, attribute: .trailing, relatedBy: .equal, toItem: imageViewT, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: pageControl, attribute: .bottom, relatedBy: .equal, toItem: imageViewT, attribute: .bottom, multiplier: 1, constant: 0)
        
        imageViewT.insertSubview(pageControl, at: 0)
        imageViewT.bringSubviewToFront(pageControl)
        view.addConstraints([leading, trailing, bottom])
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
