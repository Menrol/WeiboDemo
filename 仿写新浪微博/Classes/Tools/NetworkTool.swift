//
//  NetworkTool.swift
//  仿写新浪微博
//
//  Created by Apple on 2017/5/30.
//  Copyright © 2017年 WRQ. All rights reserved.
//

import UIKit
import AFNetworking

enum HTTPMethod: String{
    case GET = "GET"
    case POST = "POST"
}

// MARK: - 网络工具
class NetworkTool: AFHTTPSessionManager {
    
    // MARK: - 应用程序信息
    fileprivate let appKey = "4061584314"
    fileprivate let appSecret = "ba6839232b79fcbe92582cae2e98ff73"
    fileprivate let redirect = "http://www.baidu.com"
    
    /// 网络请求回调
    typealias FinishedCallback = (_ result:Any?, _ error: Error?) -> Void
    
    /// token字典
    fileprivate var tokenDic: [String: Any]?{
        if let token = UserAccountViewModel.sharedUersAccount.access_token{
            
            return ["access_token": token]
        }
        return nil
    }
    
    // 单例
    static let sharedTool:NetworkTool = {
        let tool = NetworkTool(baseURL: nil)
        tool.responseSerializer.acceptableContentTypes?.insert("text/plain")
        
        return tool
    }()
}

// MARK: - 用户相关方法
extension NetworkTool{
    
    /// 获取用户信息
    func loadUserInfo(uid: String, finished: @escaping FinishedCallback){
        
        // 获取token字典
        guard var parameters = tokenDic else {
            finished(nil, NSError(domain: "com.xyou3g.error", code: -1001, userInfo: ["message":"token为空"]))
            
            return
        }
        let urlString = "https://api.weibo.com/2/users/show.json"
        parameters["uid"] = uid
        request(method: .GET, urlString: urlString, parameters: parameters, finished: finished)
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
        self.request(method: .POST, urlString: urlString, parameters: parameters, finished: finished)
        
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
    
    fileprivate func request(method: HTTPMethod, urlString: String, parameters:Any?, finished:@escaping FinishedCallback){
        let success = { (task: URLSessionDataTask?, result: Any?) -> Void in
            finished(result,nil)
        }
        
        let failure = { (task: URLSessionDataTask?, error: Error) -> Void in
            print(error)
            finished(nil,error)
        }
        
        if method == HTTPMethod.GET{
            get(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
        else{
            post(urlString, parameters: parameters, progress: nil, success: success, failure: failure)
        }
    }
}
