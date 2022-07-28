//
//  ApiLinker.swift
//  Nerd
//
//  Created by Sachtech on 14/10/17.
//  Copyright © 2019 Sachtech. All rights reserved.
//


import UIKit
import Alamofire
import NVActivityIndicatorView

public typealias StringResponseHandler = (_ success:Bool ,_ message:String?,_ error:String?)->()
public typealias JsonResponseHandler = (_ success:Bool ,_ response:AnyObject?,_ error:String?)->()

/*
 *Request Type Methods
 */
enum ApiMethod {
    case get
    case post
    case httpPost
    case stringGet
    case stringPost
    case put
}

/*
 *Class For Server Tasks
 */
class ApiLinker: NSObject {
    
    fileprivate var netErrorMessage = "Your request can not be completed because your are not connected to internet. Please verify your Internet Connection and Try Again"
    fileprivate var netErrorTitle = "Connection Error!"
    
    fileprivate var isProgress:Bool = false
    fileprivate var progressMessage:String!
    fileprivate var requestCode:Int!
    fileprivate var requestMethod = ApiMethod.post
    fileprivate var object:UIViewController!
    fileprivate var url:String!
    fileprivate var headers = [String:String]()
    
    fileprivate var progressView = UIView()
    fileprivate var indicatorView : NVActivityIndicatorView!
       fileprivate var maskView : UIView!
    
    init(object:UIViewController) {
        self.object = object
        
    }
    
    
    override init() {
        
    }
    
    /*
     *Use for progress message
     *Set TRUE if progress is required else FALSE
     */
    func setProgress(isProgress:Bool)->ApiLinker{
        self.isProgress = isProgress
        return self
    }
    
    /*
     *Set Message on progress bar to show
     */
    func withMessage(message:String)->ApiLinker{
        self.progressMessage = message
        return self
    }
    
    /*
     *Set Request Method Type to Cummunicate with server api
     */
    func requestMethod(method:ApiMethod)->ApiLinker{
        self.requestMethod = method
        return self
    }
    
    /*
     *Execute the task  acc. to current set parameters
     *Useful in case of post methods
     */
    func execute(view:UIView?,url:String,parameters: () -> [String:AnyObject]?,onResponse:@escaping (_ response:AnyObject?)->Void,onError:@escaping (_ error:String?)->Void){
        self.url = url
        
        //Check Internet Connection first
        //        if !AppDelegate.share().reachability.isReachable{
        //           displayAlert(title: netErrorTitle, andMessage: netErrorMessage)
        //            return
        //        }
        //
        
        if isProgress {
            showProgress(view: view!)
        }
        
        let params = parameters()
        
        switch requestMethod {
        case .get:
            get(response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            break
        case .post:
            post(params: params!, response: { (response) in
                onResponse(response)
                    self.hideProgress()
            }, error: { (error) in
                onError(error)
                    self.hideProgress()
            })
            break
        case .httpPost:
            httpPost(params: params, response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            break
        case .stringGet:
            stringGet(response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            break
        case .stringPost:
            stringPost(params: params, response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
        case .put:
            put(params: params, response: { (response) in
                onResponse(response)
                if self.isProgress{
                    self.hideProgress()
                }
            },error: { (error) in
                onError(error)
                if self.isProgress{
                    self.hideProgress()
                }
            })
            break
        }
        
        
    }
    
    /*
     *Execute the task  acc. to current set parameters
     *Useful in case of post and get methods
     */
    func execute(view:UIView,url:String,onResponse:@escaping (_ response:AnyObject?)->Void,onError:@escaping (_ error:String?)->Void){
        
        
        //Check Internet Connection first
        //        if !AppDelegate.share().reachability.isReachable{
        //            displayAlert(title: netErrorTitle, andMessage: netErrorMessage)
        //            return
        //        }
        //
        
        print("Url-->"+url)
        
        self.url = url
        if isProgress {
            showProgress(view: view)
        }
        
        
        
        switch requestMethod {
        case .get:
            get(response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            break
        case .post:
            post(params: nil, response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            break
        case .httpPost:
            httpPost(params: nil, response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            break
        case .stringGet:
            stringGet(response: { (response) in
                onResponse(response)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (error) in
                onError(error)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            break
        default:
            break
        }
        
        
    }
    
 
    
    /*
     *Execute the task  acc. to current set parameters
     *Useful in case of post multipart request methods
     */
    func execute(view:UIView,url:String,image:UIImage,withName:String,parameters: @escaping () -> [String:AnyObject],onResponse:@escaping (_ response:AnyObject?)->Void,onError:@escaping (_ error:String?)->Void){
        self.url = url
        
        //Check Internet Connection first
        //        if !AppDelegate.share().reachability.isReachable{
        //            displayAlert(title: netErrorTitle, andMessage: netErrorMessage)
        //            return
        //        }
        
        
        if isProgress {
            showProgress(view: view)
        }
        
        
        DispatchQueue.global(qos: .background).async {
            self.postRequestMultipart(withName: withName,image: image, parameters: parameters(), response: { (resp) in
                onResponse(resp)
                if self.isProgress {
                    self.hideProgress()
                }
            }, error: { (err) in
                onError(err)
                if self.isProgress {
                    self.hideProgress()
                }
            })
            
        }
    }
    /*
     *Show progress to user for current task
     */
     func showProgress(view:UIView){
        // An animated UIImage
        if self.maskView == nil{
            maskView = UIView()
            maskView.frame = view.bounds
            maskView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        }
        indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
              indicatorView.center = view.center
              indicatorView.type = .ballSpinFadeLoader
        self.maskView.addSubview(indicatorView)
        view.addSubview(maskView)
        if AppPreferences.share.get(forkey: .theme) as? String == "light"{
            indicatorView.color = UIColor.black}
        else{
            indicatorView.color = UIColor.white
        }
        indicatorView.startAnimating()
    }
    
    /*
     *Hide/dismiss progress
     */
     func hideProgress(){
       if self.indicatorView != nil{
            self.indicatorView.removeFromSuperview()
            indicatorView.stopAnimating()
        }
        if maskView != nil{
            self.maskView.removeFromSuperview()
        }
    }
    
    func jSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
           
           let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
           if JSONSerialization.isValidJSONObject(value) {
               do{
                   let data = try JSONSerialization.data(withJSONObject: value, options: options)
                   if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                       return string as String
                   }
               }catch {
                   
                   print("error")
                   //Access error here
               }
               
           }
           return ""
           
       }
    
    
    /*
     *For create get request to the server
     */
    fileprivate func get(response:@escaping (_ response:AnyObject?)->Void,error:@escaping (_ error:String?)->Void){
        Alamofire.request(url ,headers: headers).responseString{ response in }.responseJSON{ respons in
            
            if (respons.result.error == nil){
                let successRange = 200...210
                if successRange.contains(respons.response?.statusCode ?? 0)                {
                    let responseObject = respons.result.value
                    response(responseObject as AnyObject)
                }
                else
                {
                    let val = respons.result.value as? NSDictionary
                    let a = val?.allValues.first as? NSArray
                    error("\(a?[0] ?? "Status code : \(respons.response?.statusCode ?? 0)")")
                }
            }else{
                error(respons.result.error.debugDescription)
                
            }
        }
    }
    fileprivate func stringGet(response:@escaping (_ response:AnyObject?)->Void,error:@escaping (_ error:String?)->Void){
        Alamofire.request(url ,headers: headers).responseString{resposne  in
            if (resposne.result.error == nil){
                let responseObject = resposne.result.value
                response(responseObject as AnyObject)
                
            }else{
                error(resposne.result.error.debugDescription)
                
            }
        }
    }
    
    /*
     *For create put request to the server
     */
    fileprivate func put(params:[String:AnyObject]?,response:@escaping (_ response:AnyObject?)->Void,error:@escaping (_ error:String?)->Void){
        var parameters = [String:AnyObject]()
        if let p = params{
            parameters = p
        }
        
        Alamofire.request(url,method:.put,parameters: parameters,/*encoding: JSONEncoding.default,*/headers:getHeaders()).responseString{response in}
            .responseJSON{ resp in
                
                if (resp.result.error == nil){
                    let responseObject = resp.result.value
                    
                    response(responseObject as AnyObject)
                }else{
                    error(resp.result.error.debugDescription)
                }
        }
        
    }
    
    /*
     *For create post request to the server
     */
    fileprivate func post(params:[String:AnyObject]?,response:@escaping (_ response:AnyObject?)->Void,error:@escaping (_ error:String?)->Void){
        var parameters = [String:AnyObject]()
        if let p = params{
            parameters = p
        }
        
        Alamofire.request(url,method:.post,parameters: parameters,encoding: JSONEncoding.default,headers:getHeaders()).responseString{response in
            }
            .responseJSON{ resp in
                if (resp.result.error == nil){
                    let successRange = 200...210
                    if successRange.contains(resp.response?.statusCode ?? 0)
                    {
                        let responseObject = resp.result.value
                        response(responseObject as AnyObject)
                    }
                    else
                    {
                        let val = resp.result.value as? NSDictionary
                        let a = val?.allValues.first as? NSArray
                        error("\(a?[0] ?? "Status code : \(resp.response?.statusCode ?? 0)")\nPlease try again after some time...")
                    }
                }else{
                    error(resp.result.error.debugDescription)
                }
        }
    }
    
    /*`
     *For create post request to the server
     */
    fileprivate func stringPost(params:[String:AnyObject]?,response:@escaping (_ response:AnyObject?)->Void,error:@escaping (_ error:String?)->Void){
        var parameters = [String:AnyObject]()
        if let p = params{
            parameters = p
        }
        
        Alamofire.request(url,method:.post,parameters: parameters,/*encoding: JSONEncoding.default,*/headers:getHeaders()).responseString{responses in
            
            
            if (responses.result.error == nil){
                let responseObject = responses.result.value
                
                response(responseObject as AnyObject)
            }else{
                error(responses.result.error.debugDescription)
            }
        }
        
    }
    
    /*
     *For create http post request to the server
     */
    fileprivate func httpPost(params:[String:AnyObject]?,response:@escaping (_ response:AnyObject?)->Void,error:@escaping (_ error:String?)->Void){
        var parameters = [String:AnyObject]()
        if let p = params{
            parameters = p
        }
        
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding(options:[]), headers: headers).responseJSON { (resp) in
            
            
            switch resp.result {
            case .failure(let err):
                print(err)
                
                if let data = resp.data, let responseString = String(data: data, encoding: .utf8) {
                    error(responseString)
                }
            case .success(let responseObject):
                response(responseObject as AnyObject)
                
            }
        }
    }
    
    /**
     *Create multipart post request to server
     */
     func postRequestMultipart(withName:String,image:UIImage!,parameters:[String:AnyObject],response: @escaping (_ response:AnyObject)->Void,error:@escaping (_ error:String)->Void){
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            multipartFormData.append(image.jpegData(compressionQuality: 0.5)!, withName: withName, fileName: "file0.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append(value.data!(using: String.Encoding.utf8.rawValue)!, withName: key)
            }
        }, to:url)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (Progress) in
                    print("Upload Progress: \(Progress.fractionCompleted)")
                })
                
                upload.responseJSON { resp in
                    
                    
                    if let JSON = resp.result.value {
                        print("JSON: \(JSON)")
                        response(JSON as AnyObject)
                    }
                }
                
            case .failure(let encodingError):
                //self.delegate?.showFailAlert()
                print(encodingError)
                error(encodingError.localizedDescription)
                
                
            }
            
        }
    }
    
    
//
//    func download(downloadUrl:String,fileName:String,dirName:String, completion: ((Bool, String?) -> Void)?){
//        if isProgress{
//            showProgress()
//        }
//        let destination: DownloadRequest.DownloadFileDestination  = {_,_ in
//
//            if(createDirectoryAtDocumentDirectory(dirName))
//            {
//                print("btk created")
//            }else{
//                print("error when creating btk")
//
//            }
//
//            /* let directoryUrl = getDocumentDirectoryStringPath().appendingFormat("/%@", dirName)
//             let file = directoryUrl.appendingFormat("/%@", fileName)*/
//            let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(dirName)
//            let file = directoryURL.appendingPathComponent(fileName, isDirectory: false)
//
//            return (file, [.createIntermediateDirectories, .removePreviousFile])
//
//        }
//
//        Alamofire.download(downloadUrl, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil, to:destination ).downloadProgress { (progress) in
//            print(progress)
//            }.responseString { (response) in
//                if self.isProgress{
//                    self.hideProgress()
//                }
//                if response.result.error == nil {
//                    completion!(true,response.result.value)
//                } else {
//                    print(response.result.error!.localizedDescription)
//                    completion!(false,nil)
//                }
//        }
//    }
    
    
    
    
    func   setHeader(headers:[String:String]){
        self.headers = headers
    }
    
    fileprivate func getHeaders() -> [String:String] {
        return headers
    }
    
    
    fileprivate func displayAlert(title: String, andMessage message: String)
    {
        let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindow.Level.alert + 1
        alertWindow.makeKeyAndVisible()
        
        let alertController: UIAlertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { (action) -> Void in
            
            alertWindow.isHidden = true
            
        }))
        
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}

