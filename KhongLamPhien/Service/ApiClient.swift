//
//  ApiClient.swift
//
//  Created by Nguyen Anh on 14/07/2021.
//

import Foundation
import Moya
import SwiftyJSON
import PromiseKit
import Alamofire

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

class DefaultAlamofireManager: Alamofire.Session {
    static let sharedManager: DefaultAlamofireManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 40 // as seconds, you can set your request timeout
        configuration.timeoutIntervalForResource = 40 // as seconds, you can set your resource timeout
        configuration.requestCachePolicy = .useProtocolCachePolicy
        return DefaultAlamofireManager(configuration: configuration)
    }()
}

public class ApiClient {

    static let shared = ApiClient()
    
    var urlRequests: [URLRequest] = []
    
    func callApi<T: TargetType, A: ApiResponse>(_ target: T, completionHandler: @escaping ((A?) -> Void)) -> Cancellable {
        // for adding headers
        let endpointClosure = { (target: T) -> Endpoint in
            var headers = target.headers ?? [:]
            headers["X-Requested-With"] = "XMLHttpRequest"
            
            var defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            defaultEndpoint = defaultEndpoint.adding(newHTTPHeaderFields: headers)
            
            // cancel all previous requests same
            if let newUrlRequest = try? defaultEndpoint.urlRequest() {
                DefaultAlamofireManager.sharedManager.session.getAllTasks(completionHandler: { (tasks) in
                    tasks.forEach({ (task) in
                        let originalRequest = task.originalRequest
                        if originalRequest == newUrlRequest
                            && originalRequest?.httpBody == newUrlRequest.httpBody {
                            task.cancel()
                        }
                    })
                })
            }
            
            return defaultEndpoint
        }
        
        let provider = MoyaProvider<T>(endpointClosure: endpointClosure,
                                       session: DefaultAlamofireManager.sharedManager,
                                       plugins: [NetworkLoggerPlugin()])
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let cancellable = provider.request(target, completion: { result in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case let .success(moyaResponse):
                let resp = A.init(response: moyaResponse)
                completionHandler(resp)
            case let .failure(error):
                completionHandler(A.init(error: error))
            }
        })

        return cancellable
    }

    func callApi<T: TargetType, A: ApiResponse>(_ target: T) -> Promise<A> {
        
        // for adding headers
        let endpointClosure = { (target: T) -> Endpoint in
            var headers = target.headers ?? [:]
            headers["X-Requested-With"] = "XMLHttpRequest"
            
            var defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            defaultEndpoint = defaultEndpoint.adding(newHTTPHeaderFields: headers)
            
            // cancel all previous requests same
            if let newUrlRequest = try? defaultEndpoint.urlRequest() {
                DefaultAlamofireManager.sharedManager.session.getAllTasks(completionHandler: { (tasks) in
                    tasks.forEach({ (task) in
                        let originalRequest = task.originalRequest
                        if originalRequest == newUrlRequest
                            && originalRequest?.httpBody == newUrlRequest.httpBody {
                            task.cancel()
                        }
                    })
                })
            }
            
            return defaultEndpoint
        }
                
        let provider = MoyaProvider<T>(endpointClosure: endpointClosure,
                                       session: DefaultAlamofireManager.sharedManager,
                                       plugins: [NetworkLoggerPlugin()])
        
        return Promise<A> { (resoler) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            provider.request(target, completion: { result in
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch result {
                case let .success(moyaResponse):
                    let resp = A.init(response: moyaResponse)
//                    if let nsError = resp.error {
//                        resoler.reject(nsError)
//                    } else {
                        resoler.fulfill(resp)
//                    }
                case let .failure(moyaError):
                    switch moyaError {
                    case .underlying(let error, _):
                        let resp = A.init(error: error)
                        if let nsError = resp.error {
                            resoler.reject(nsError)
                        } else {
                            resoler.reject(moyaError)
                        }
                    default:
                        resoler.reject(moyaError)
                    }
                }
            })
        }
    }
    
    func suspendAllRequests() {
        DefaultAlamofireManager.sharedManager.session.getAllTasks { tasks in
            tasks.forEach({ (task) in
                task.suspend()
            })
        }
    }
    
    func cancelAllRequests() {
        DefaultAlamofireManager.sharedManager.session.getAllTasks { tasks in
            tasks.forEach({ (task) in
                task.cancel()
            })
        }
    }
    
    func resumeAllRequests() {
        DefaultAlamofireManager.sharedManager.session.getAllTasks { tasks in
            tasks.forEach({ (task) in
                task.resume()
            })
        }
    }
}
