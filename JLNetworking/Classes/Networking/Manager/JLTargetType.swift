//
//  JLTargetType.swift
//  JLNetworking
//
//  Created by Jerry on 2021/12/11.
//

import Foundation
import Moya
import HandyJSON

public protocol JLTargetType: TargetType {
    /// 请求模型
    associatedtype ResponseType: HandyJSON
    /// 参数
    var params : [String: Any]? { get }
    /// 网络超时
    var timeoutInterval: TimeInterval { get }
    /// 参数编码
    var parameterEncoding: ParameterEncoding { get }
    /// 获取路径
    var keyPath: String? { get }
    /// 显示菊花器
    var showHUD: Bool { get }
}

public extension JLTargetType {
    var baseURL: URL {
        guard let baseUrl = URL(string: JLNetworkConfig.shared.baseUrl) else {
            assert(false, "未设置baseUrl")
            return URL.init(string: "https://baidu.com")!
        }
        return baseUrl
    }
    
    /// 单元测试用
    var sampleData: Data {
        if let data = "".data(using: .utf8) {
            return data
        }
        return Data()
    }
    
    /// 请求task
    var task: Task {
        return .requestParameters(parameters: params ?? [String: Any](), encoding: parameterEncoding)
    }
    
    /// 参数编码
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    /// 请求头
    var headers: [String : String]? {
        return JLNetworkConfig.shared.header
    }
    
    /// 获取指定路径response
    var keyPath: String? {
        return "data"
    }
    
    /// 网络超时
    var timeoutInterval: TimeInterval {
        return 30
    }
    
    /// 是否显示菊花器
    var showHUD: Bool {
        return false
    }
    
}
