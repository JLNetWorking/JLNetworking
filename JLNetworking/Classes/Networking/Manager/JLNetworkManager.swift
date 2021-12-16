//
//  JLNetworkManager.swift
//  JLNetworking
//
//  Created by Jerry on 2021/12/11.
//

import UIKit
import Moya

/// 存储NetworkingManager
fileprivate var singletons_store = [String: Any]()

public class JLNetworkManager<T: JLTargetType> {
    
    /// 进度条Block
    public typealias ProgressValueBlock = ((_ progress: Double) -> Void)?
    /// 成功Block（返回Dic）
    public typealias SuccessBlock = (([String: Any]) -> Void)?
    /// 成功Block（返回model）
    public typealias SuccessInfoBlock = ((T.ResponseType) -> Void)?
    /// 失败Block
    public typealias ErrorBlock = ((Error) -> Void)?
    /// 失败Block
    public typealias ErrorInfoBlock = ((ErrorInfo) -> Void)?
    
    
    
    /// Moya的管理者
    private let privider = MoyaProvider<T>(endpointClosure: endpointMapping, callbackQueue: nil, plugins: [JLNetworkManager.shared.plugin])
    
    private var plugin: PluginType = JLPlugin(showHUD: false)
    
    
    
    /// 取出保存的NetworkingManager
    private static var shared: JLNetworkManager<T> {
        let store_key = String(describing: T.self)
        if let singleton = singletons_store[store_key] as? JLNetworkManager<T> {
            return singleton
        } else {
            let new_singleton = JLNetworkManager<T>()
            singletons_store[store_key] = new_singleton
            return new_singleton
        }
    }
    
    /// 发起请求
    public class func request(_ target: T,
                              onProgress: ProgressValueBlock = nil,
                              onSuccessOriginal: SuccessBlock = nil,
                              onSuccess: SuccessInfoBlock = nil,
                              onErrorInfo: ErrorInfoBlock = nil,
                              onError: ErrorBlock = nil) -> Cancellable {
        JLNetworkManager.shared.plugin = JLPlugin(showHUD: target.showHUD)
        return JLNetworkManager.shared.privider.request(target, callbackQueue: nil) { progress in
            // 进度回调
            if let progressBlock = onProgress {
                progressBlock(progress.progress)
            }
        } completion: { result in
            switch result {
            case .success(let response):
                do {
                    // 过滤请求状态码（200...299）
                    var successResponse = try response.filterSuccessfulStatusCodes()
                    
                    // 下载请求直接返回
                    switch target.task {
                    case .downloadDestination:
                        fallthrough
                    case .downloadParameters:
                        onSuccessOriginal?([:])
                        return
                        
                    default:
                        break
                    }
                    
                    // 过滤服务器返回的状态码
                    successResponse = try successResponse.filterCode()
                    // response转dic
                    if let successOriginalBlock = onSuccessOriginal {
                        let dic = successResponse.mapDic(keyPath: target.keyPath)
                        successOriginalBlock(dic)
                    }
                    
                    // response转model
                    if let successInfoBlock = onSuccess {
                        let model = try successResponse.mapModel(T.ResponseType.self, atKeyPath: target.keyPath)
                        successInfoBlock(model)
                    }
                    
                } catch let error {
                    // error回调（包括非200...299，转model失败）
                    if let error = error as? MoyaError {
                        // 能否转成model
                        if let errorInfo = try? error.response?.mapModel(ErrorInfo.self), let errorInfoBlock = onErrorInfo {
                            // 抛出errorInfo
                            errorInfoBlock(errorInfo)
                        } else if let errorBlock = onError {
                            // 不能转model，抛出error
                            errorBlock(error)
                        }
                    }
                }
            case .failure(let moyaError):
                if let errorBlock = onError {
                    errorBlock(moyaError)
                }
            }
        }

    }
    
    
    
    /// 自定义endPoint，配置网络
    private static func endpointMapping(for target: T) -> Endpoint {
        let endpoint = Endpoint(
            url: URL(target: target).absoluteString,
            sampleResponseClosure: { .networkResponse(200, target.sampleData) },
            method: target.method,
            task: target.task,
            httpHeaderFields: target.headers
        )
        do {
            var request: URLRequest = try endpoint.urlRequest()
            // 请求超时
            request.timeoutInterval = target.timeoutInterval
        } catch {
            print("\(error)")
        }
        return endpoint
    }
    
}
