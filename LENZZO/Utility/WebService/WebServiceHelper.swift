//
//  WebServiceHelper.swift
//
//

import Foundation
import Alamofire
import UIKit


class WebServiceHelper
{
    static let sharedInstanceAPI = WebServiceHelper()
    private init(){}
    let resultG = [String:Any]()
    let baseURL = KeyConstant.kBaseURL
    
    func hitPostAPI(urlString: String, params: [String: String], completionHandler:@escaping (_ result: [String: Any], _ errorC : Error?) -> Void)
    {
        print("params-> ",params)
        
        
        let openUrl : URL
        
        
        openUrl = URL(string: baseURL + urlString)!
        
        
        
        
        print("API URL-> ",openUrl)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                for (key, value) in params
                {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }
        },
            to: openUrl,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        if let data = response.data {
                            print("Response html data: \(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)")
                        }
                        do{
                            let result = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                            print(result)
                            let errorC = Error.self
                            completionHandler(result,errorC as? Error)
                        }catch{
                            if let err = response.error {
                                completionHandler(self.resultG,err as? Error);                                return
                            }
                        }                    }
                    upload.uploadProgress(queue: DispatchQueue(label: "uploadQueue"), closure: { (progress) in
                        
                        
                    })
                    
                case .failure(let encodingError):
                    print(encodingError)
                    completionHandler(self.resultG,encodingError as? Error)
                    
                }
        }
        )
    }
    
    //    func hitPostAPIINJSON(urlString: String, params: [String: AnyObject], completionHandler:@escaping (_ result: [String: Any], _ errorC : Error?) -> Void)
    //    {
    //        Alamofire.request(baseURL + urlString, method: .post, parameters: params)
    //            .responseJSON { response in
    //                print(response)
    //                if let data = response.data {
    //                    print("Response html data: \(NSString(data: data, encoding: String.Encoding.utf8.rawValue)!)")
    //                }
    //                do{
    //                    let result = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
    //                    print(result)
    //                    let errorC = Error.self
    //                    completionHandler(result,errorC as? Error)
    //                }catch{
    //                    if let err = response.error {
    //                        completionHandler(self.resultG,err as? Error);                                return
    //                    }
    //                }
    //        }
    //    }
    
    
    func hitPostAPIWithImage(urlString: String, params: [String: String],imageData: Data,imageKey: String, completionHandler:@escaping (_ result: [String: Any], _ errorC : Error?) -> Void)
    {
        print("params-> ",params)
        
        
        let openUrl : URL
        openUrl = URL(string: baseURL + urlString)!
        
        print("params-> ",openUrl)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                for (key, value) in params
                {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }
                multipartFormData.append(imageData, withName: imageKey, fileName: "user.jpg", mimeType: "image/jpeg")
                
        },
            to: openUrl,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        do{
                            let result = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                            print(result)
                            let errorC = Error.self
                            completionHandler(result,errorC as? Error)
                        }catch{
                            if let err = response.error {
                                completionHandler(self.resultG,err as? Error);                                return
                            }
                        }                    }
                    upload.uploadProgress(queue: DispatchQueue(label: "uploadQueue"), closure: { (progress) in
                        
                        
                    })
                    
                case .failure(let encodingError):
                    print(encodingError)
                    completionHandler(self.resultG,encodingError as? Error)
                    
                }
        }
        )
    }
    
    func hitGetShipAPI(urlString: String, completionHandler:@escaping (_ result: [String: Any], _ errorC : Error?) -> Void)
    {
        
        let openUrl : URL
        let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        if(escapedString?.count ?? 0 > 0)
        {
            openUrl = URL(string: escapedString!)!
            
            print("params-> ",openUrl)
            
            Alamofire.request(openUrl , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .responseJSON
                { response in
                    debugPrint(response)
                    do{
                        let result = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                        print(result)
                        let errorC = Error.self
                        completionHandler(result,errorC as? Error)
                    }catch{
                        if let err = response.error {
                            completionHandler(self.resultG,err as? Error);                                return
                        }
                    }
                    
            }
        }
        
    }
    
    
    
    
    
    func hitGetAPI(urlString: String, completionHandler:@escaping (_ result: [String: Any], _ errorC : Error?) -> Void)
    {
        
        let openUrl : URL
        
        openUrl = URL(string: baseURL + urlString)!
        
        print("params-> ",openUrl)
        
        Alamofire.request(openUrl , method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON
            { response in
                debugPrint(response)
                do{
                    let result = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                    print(result)
                    let errorC = Error.self
                    completionHandler(result,errorC as? Error)
                }catch{
                    if let err = response.error {
                        completionHandler(self.resultG,err as? Error);                                return
                    }
                }                    }
    }
    
    
    
    
    func hitPostVideoChatUpload(urlString: String, params: [String: String], imageData:Data,videoData:Data,urlKey:String, completionHandler:@escaping (_ result: [String: Any], _ errorC : Error?) -> Void)
    {
        print("params-> ",params)
        
        let urlKey = urlKey.lowercased()
        let openUrl : URL
        
        openUrl = URL(string: baseURL + urlString)!
        
        print("params-> ",openUrl)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                for (key, value) in params
                {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }
                
                multipartFormData.append(videoData, withName: "video", fileName: "video.mov", mimeType: "application/\(urlKey)")
                multipartFormData.append(imageData, withName: "image", fileName: "thumbnail.png", mimeType: "application/jpeg")
                
                
        },
            to: openUrl,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        do{
                            let result = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                            print(result)
                            let errorC = Error.self
                            completionHandler(result,errorC as? Error)
                        }catch{
                            if let err = response.error {
                                completionHandler(self.resultG,err as? Error);                                return
                            }
                        }                    }
                    upload.uploadProgress(queue: DispatchQueue(label: "uploadQueue"), closure: { (progress) in
                        
                        
                    })
                    
                case .failure(let encodingError):
                    print(encodingError)
                    completionHandler(self.resultG,encodingError as? Error)
                    
                }
        }
        )
    }
    
    
    
    
    
    
    
    
    func hitPostAPIWithMultipleImage(urlString: String, params: [String: String],imageData: [UIImage],imageKey: String, completionHandler:@escaping (_ result: [String: Any], _ errorC : Error?) -> Void)
    {
        print("params-> ",params)
        
        
        let openUrl : URL
        var openData = Data()
        
        openUrl = URL(string: baseURL + urlString)!
        
        print("params-> ",openUrl)
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                
                for (key, value) in params
                {
                    multipartFormData.append((value.data(using: .utf8))!, withName: key)
                }
                
                for (image) in imageData
                {
                    openData = image.pngData()!
                    multipartFormData.append(openData, withName: imageKey, fileName: "user.jpg", mimeType: "image/jpeg")
                }
                
                
                
        },
            to: openUrl,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        do{
                            let result = try JSONSerialization.jsonObject(with: response.data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                            print(result)
                            let errorC = Error.self
                            completionHandler(result,errorC as? Error)
                        }catch{
                            if let err = response.error {
                                completionHandler(self.resultG,err as? Error);                                return
                            }
                        }                    }
                    upload.uploadProgress(queue: DispatchQueue(label: "uploadQueue"), closure: { (progress) in
                        
                        
                    })
                    
                case .failure(let encodingError):
                    print(encodingError)
                    completionHandler(self.resultG,encodingError as? Error)
                    
                }
        }
        )
    }
    
    
}
