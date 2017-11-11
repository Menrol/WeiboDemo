//
//  NetworkTool.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/5/30.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit
import Alamofire

// MARK: - 网络工具
class NetworkTool {
    
    // MARK: - 应用程序信息
    fileprivate let appKey = "4061584314"
    fileprivate let appSecret = "ba6839232b79fcbe92582cae2e98ff73"
    fileprivate let redirect = "http://www.baidu.com"
    
    /// 网络请求回调
    typealias FinishedCallback = (_ result:Any?, _ error: Error?) -> Void
    
    // 单例
    static let sharedTool:NetworkTool = NetworkTool()
}

// MARK: - 微博数据
extension NetworkTool{
    
    /// 获取微博数据
    func loadStatuses(since_id: Int, max_id: Int, finished: @escaping FinishedCallback){
        
        var parameters = [String: Any]()
        
        let urlString = "https://api.weibo.com/2/statuses/home_timeline.json"
        if since_id > 0 {
            parameters["since_id"] = since_id
        }else if max_id > 0 {
            parameters["max_id"] = max_id - 1
        }
        tokenRequest(method: .get, urlString: urlString, parameters: parameters, finished: finished)
    }
    
    /// 获取未读微博条数
    func unreadCount(finished: @escaping FinishedCallback) {
        let urlString = "https://rm.api.weibo.com/2/remind/unread_count.json"
        guard let uid = UserAccountViewModel.sharedUersAccount.userAccount?.uid else {
            return
        }
        let parameters = ["uid": uid]
        
        tokenRequest(method: .get, urlString: urlString, parameters: parameters, finished: finished)
    }
}

// MARK: - 发布微博
extension NetworkTool {
    /// 发布微博
    func sendStatus(status: String, image: UIImage?, finished: @escaping FinishedCallback) {
        var parameters = [String: Any]()
        parameters["status"] = status
        
        if image == nil {
            let urlString = "https://api.weibo.com/2/statuses/update.json"
            tokenRequest(method: .post, urlString: urlString, parameters: parameters, finished: finished)
        }else {
            let urlString = "https://api.weibo.com/2/statuses/upload.json"
            let data = UIImagePNGRepresentation(image!)
            upLoad(urlString: urlString, data: data!, name: "pic", parameters: parameters, finished: finished)
        }
        
    }
}

// MARK: - 用户相关方法
extension NetworkTool{
    
    /// 获取用户信息
    func loadUserInfo(uid: String, finished: @escaping FinishedCallback){
        var parameters = [String: Any]()
        let urlString = "https://api.weibo.com/2/users/show.json"
        parameters["uid"] = uid
        tokenRequest(method: .get, urlString: urlString, parameters: parameters, finished: finished)
    }
}

// MARK: - OAuth相关方法
extension NetworkTool{
    
    /// OAuth授权
    var oauthURL:URL {
        let urlString = "https://api.weibo.com/oauth2/authorize?client_id=\(appKey)&redirect_uri=\(redirect)"
        
        return URL(string: urlString)!
    }
    
    /// 获取AccessToken
    func loadAccessToken(code: String,finished: @escaping FinishedCallback){
        let urlString = "https://api.weibo.com/oauth2/access_token"
        let parameters = ["client_id":appKey,
                          "client_secret":appSecret,
                          "grant_type":"authorization_code",
                          "code":code,
                          "redirect_uri":redirect]
        self.request(method: .post, urlString: urlString, parameters: parameters, finished: finished)
        
//        // 测试返回数据格式
//        responseSerializer = AFHTTPResponseSerializer()
//        post(urlString, parameters: parameters, progress: nil, success: { (_, result) in
//            let json = String(data: (result as? Data)!, encoding: .utf8)
//            print(json!)
//        }, failure: nil)
    }
}

// MARK: - 封装AFN
extension NetworkTool{
    
    fileprivate func tokenRequest(method: HTTPMethod, urlString: String, parameters:[String: Any]?, finished:@escaping FinishedCallback) {
        var parameters = parameters
        if !addtoken(parameters: &parameters) {
            finished(nil, NSError(domain: "com.xyou3g.error", code: -1001, userInfo: ["message":"token为空"]))
            
            return
        }
        
        request(method: method, urlString: urlString, parameters: parameters, finished: finished)
    }
    
    fileprivate func request(method: HTTPMethod, urlString: String, parameters: [String: Any]?, finished:@escaping FinishedCallback){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        Alamofire.request(urlString, method: method, parameters: parameters).responseJSON { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            if response.result.isFailure {
                print(response.result.error as Any)
            }
            
            finished(response.result.value, response.result.error)
            }
    }
    
    /// 上传文件
    fileprivate func upLoad(urlString: String, data:Data, name: String, parameters: [String: Any]?, finished:@escaping FinishedCallback) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        var parameters = parameters
        if !addtoken(parameters: &parameters) {
            finished(nil, NSError(domain: "com.xyou3g.error", code: -1001, userInfo: ["message":"token为空"]))
            
            return
        }
        
        Alamofire.upload(multipartFormData: { (formData) in
            formData.append(data, withName: name, fileName: "xxx", mimeType: "application/octet-stream")
           
            // 传入字典参数
            if let parameters = parameters {
                for (k, v) in parameters {
                    let string = v as! String
                    let strData = string.data(using: String.Encoding.utf8)!
                    
                    formData.append(strData, withName: k)
                }
            }
        }, to: urlString) { (result) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON(completionHandler: { (response) in
                    finished(response.result.value, nil)
                })
            case .failure(let error):
                print(error)
                finished(nil, error)
            }
        }
    }
    
    fileprivate func addtoken(parameters: inout [String: Any]?) -> Bool {
        guard let token = UserAccountViewModel.sharedUersAccount.access_token else {
            
            return false
        }
        
        if parameters == nil {
            parameters = [String: Any]()
        }
        parameters!["access_token"] = token
        
        return true
    }
}
