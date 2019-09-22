//
//  WifiFunctions.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 12/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import Foundation
import SystemConfiguration.CaptiveNetwork


func SSIDOnListMode() -> [String]? {
    guard let interfaceNames = CNCopySupportedInterfaces() as? [String] else {
        return nil
    }
    return interfaceNames.flatMap { name in
        guard let info = CNCopyCurrentNetworkInfo(name as CFString) as? [String:AnyObject] else {
            return nil
        }
        guard let ssid = info[kCNNetworkInfoKeySSID as String] as? String else {
            return nil
        }
        return ssid
    }
}
func getCurrentSSID () ->String {
    guard let ssid = SSIDOnListMode() else {
        return ""
    }
    if let ssidaFinal = ssid.first {
        return ssidaFinal
    }
    else{ return ""
    }
    
}
func getSSIDWhithMac(mac: String)->String{
    
    var ssid = "Wiicoon"
    let aux = mac.replacingOccurrences(of: ":", with: "")
    ssid = ssid + "_"+aux.dropFirst(aux.count - 6)
    
    return ssid
}

func getWiFiAddress() -> String? {
    var address: String?
    var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
    if getifaddrs(&ifaddr) == 0 {
        
        var ptr = ifaddr
        while ptr != nil {
            defer { ptr = ptr?.pointee.ifa_next } // memory has been renamed to pointee in swift 3 so changed memory to pointee
            
            let interface = ptr?.pointee
            let addrFamily = interface?.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                if let name: String = String(cString: (interface?.ifa_name)!), name == "en0" {  // String.fromCString() is deprecated in Swift 3. So use the following code inorder to get the exact IP Address.
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
                
            }
        }
        freeifaddrs(ifaddr)
    }
    return address
}
