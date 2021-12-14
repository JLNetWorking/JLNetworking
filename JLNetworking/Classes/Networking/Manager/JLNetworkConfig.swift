//
//  JLNetworkConfig.swift
//  JLNetworking
//
//  Created by Jerry on 2021/12/11.
//

import Foundation

public class JLNetworkConfig {
    /// 基础域名设置
    public var baseUrl: String = ""
    /// 开启日志输出 默认不开启
    public var openLog: Bool = false
    /// 配置基础网络请求header用于补充部分业务参数
    public var header: [String: String]?
    
    public static let shared = JLNetworkConfig()
    private init() {}
}
