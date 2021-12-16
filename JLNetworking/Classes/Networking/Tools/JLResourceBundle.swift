//
//  JLResourceBundle.swift
//  JLNetworking
//
//  Created by Jerry on 2021/12/16.
//

import Foundation


/**
 获取当前App资源Bundle
 只会查找APP目录和Frameworks目录
 同名的Bundle 会覆盖
 */
public class JLResourceBundle {
    
    private static let shared = JLResourceBundle()
    
    /// 保存Bundle
    private var bundles = [String: Bundle]()
    
    /// 当前主Bundle名字
    private var mainBundleName = ""
    
    private init() {
        self.mainBundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String ?? ""
        
        self.readResourceBundlesInFramework(Bundle.main.bundlePath)
        self.readFrameworks(Bundle.main.bundlePath + "/Frameworks")
    }
    
}


extension JLResourceBundle {
    /// 读取framework里的bundle
    /// - Parameter path:
    private func readResourceBundlesInFramework(_ path: String) {
        if let subpaths = try? FileManager.default.contentsOfDirectory(atPath: path) {
            /// 遍历frameowk 查找bundle目录
            for subpath in subpaths {
                if subpath.hasSuffix(".bundle") {
                    if let bundle = Bundle.init(path: path + "/" + subpath),
                       bundle.infoDictionary?["CFBundlePackageType"] as? String == "BNDL",
                       let bundleName = bundle.infoDictionary?["CFBundleName"] as? String {
                        // BDNL 类型的bundle 视为资源bundle
                        self.bundles[bundleName] = bundle
                    }
                }
            }
        }
    }
    
    
    /// 读取Frameworks
    private func readFrameworks(_ path: String) {
        if let subpaths = try? FileManager.default.contentsOfDirectory(atPath: path) {
            for subpath in subpaths {
                if subpath.hasSuffix(".framework") {
                    self.readResourceBundlesInFramework(path + "/" + subpath)
                }
            }
        }
    }
    
    
    /// 获取所有资源bundle
    /// - Returns:
    public static func allBundles() -> [String: Bundle] {
        return self.shared.bundles
    }
    
    /// 获取当前所在模块的资源bundle
    /// - Parameter file:
    /// - Returns:
    public static func current(_ file: String = #fileID) -> Bundle? {
        
        
        guard let name = file.components(separatedBy: "/").first else {
            return nil
        }
        
        if name == self.shared.mainBundleName {
            return Bundle.main
        }
        
        return self.shared.bundles[name]
    }
    
}

