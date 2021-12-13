//
//  Response+Extension.swift
//  JLNetworking
//
//  Created by Jerry on 2021/12/11.
//

import Foundation
import Moya
import SwiftyJSON
import HandyJSON

/// 逻辑错误Model
public struct ErrorInfo : HandyJSON, LocalizedError {
    public var code : Int?
    public var msg : String?
    public init() {}
    
    public var localizedDescription: String {
        return self.msg ?? ""
    }
    
    public var errorDescription: String? {
        return self.localizedDescription
    }
    
    public var errorCode: Int {
        return self.code ?? 0
    }
    
    public var errorUserInfo: [String : Any] {
        return [NSLocalizedDescriptionKey : self.localizedDescription]
    }
}

extension Response {
    /// 筛选response，直接抛出data
    func filterCode() throws -> Response {
        do {
            // 尝试解析response为json
            let json = try JSON(self.mapJSON())
            
            // 拿到code
            guard let code = json.dictionaryValue["code"]?.intValue else {
                // code不存在时，直接返回error
                throw MoyaError.jsonMapping(self)
            }
            
            // 非服务器返回code非200
            if code != 200 {
                // 可以解析成model就转成ErrorModel转发出去
                if let model = try ErrorInfo.deserialize(from: self.mapString()) {
                    throw model
                }
                throw MoyaError.jsonMapping(self)
            }
            return self
        } catch {
            // response转换json失败，直接返回error
            throw MoyaError.jsonMapping(self)
        }
    }
    
    
    /// response 转 Dic
    func mapDic(keyPath: String? = nil) -> [String: Any] {
        do {
            // 当前response能否解析
            guard let dic = try mapJSON() as? [String: Any] else { return [String: Any]() }
            // 是否传入keypath，拿到对应的dic
            if let path = keyPath, path.count > 0 {
                if let result = (dic as NSDictionary).value(forKeyPath: path) as? [String: Any] {
                    return result
                }
                return [String: Any]()
            }
            // 如果没传直接返回转好的dic
            return dic
        } catch {
            // 解析失败
            return [String: Any]()
        }
    }
    
    /// response 转 model
    func mapModel<T: HandyJSON>(_ type: T.Type, atKeyPath keyPath: String? = nil) throws -> T {
        let jsonString = String.init(data: data, encoding: .utf8)
        guard let result = JSONDeserializer<T>.deserializeFrom(json: jsonString, designatedPath: keyPath) else {
            throw MoyaError.jsonMapping(self)
        }
        return result
    }
    
    
}

