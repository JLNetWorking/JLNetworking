//
//  JLPlugin.swift
//  JLNetworking
//
//  Created by Jerry on 2021/12/14.
//

import Foundation
import Moya


class JLPlugin: PluginType {
    
    private let showHUD: Bool
    
    init(showHUD: Bool) {
        self.showHUD = showHUD
    }
    
    
    
    /// 开始发起请求。我们可以在这里显示网络状态指示器。
    func willSend(_ request: RequestType, target: TargetType) {
        if showHUD {
            JLLoadingHUD.showHUD()
        }
    }
    
    /// 收到请求响应。我们可以在这里根据结果自动进行一些处理，比如请求失败时将失败信息告诉用户，或者记录到日志中。
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        if showHUD {
            JLLoadingHUD.dismissHUD()
        }
    }
    
    
    
    /// 准备发起请求。我们可以在这里对请求进行修改，比如再增加一些额外的参数。
//    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
//
//    }
    
    /// 处理请求结果。我们可以在 completion 前对结果进行进一步处理。
//    func process(_ result: Result<Response, MoyaError>, target: TargetType) -> Result<Response, MoyaError> {
//
//    }
}
