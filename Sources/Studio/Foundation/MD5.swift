//
//  MD5.swift
//  
//
//  Created by Ben Gottlieb on 9/10/21.
//

#if canImport(CryptoKit)
import Foundation
import CryptoKit

@available(watchOS 6.0, iOS 13.0, macOS 10.15, *)
public extension String {
	var md5: String? {
		autoreleasepool {
			guard let data = data(using: .utf8) else { return nil }
			return Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
		}
	 }
}

@available(watchOS 6.0, iOS 13.0, macOS 10.15, *)
public extension Data {
	var md5: String? {
		autoreleasepool {
			Insecure.MD5.hash(data: self).map { String(format: "%02hhx", $0) }.joined()
		}
	 }
}

@available(watchOS 6.0, iOS 13.0, macOS 10.15, *)
public extension URL {
	var md5: String? {
		autoreleasepool {
			guard isFileURL, let data = try? Data(contentsOf: self) else { return nil }
			return Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
		}
	 }
}

#endif
