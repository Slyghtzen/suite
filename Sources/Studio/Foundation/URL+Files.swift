//
//  URL+Files.swift
//  
//
//  Created by Ben Gottlieb on 7/2/21.
//

import Foundation

public extension URL {
	static func systemDirectoryURL(which: FileManager.SearchPathDirectory) -> URL? {
		guard let path = NSSearchPathForDirectoriesInDomains(which, [.userDomainMask], true).first else { return nil }
		let url = URL(fileURLWithPath: path)
		if !FileManager.default.fileExists(at: url) { try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil) }
		return url
	}
	
	static var documents: URL { return systemDirectoryURL(which: .documentDirectory)! }
	static var applicationSupport: URL { return systemDirectoryURL(which: .applicationSupportDirectory)! }
	static var library: URL { return systemDirectoryURL(which: .libraryDirectory)! }
	static var caches: URL { return systemDirectoryURL(which: .cachesDirectory)! }
	static var applicationSpecificSupport: URL { return systemDirectoryURL(which: .applicationSupportDirectory)!.appendingPathComponent(Bundle.main.bundleIdentifier ?? Bundle.main.name) }
	static var temp: URL { return URL(fileURLWithPath: NSTemporaryDirectory()) }
	
	static func document(named path: String) -> URL {
		let url = URL.documents + path
		_ = url.dropLast().existingDirectory
		return url
	}

	static func cache(named path: String) -> URL {
		let url = URL.caches + path
		_ = url.dropLast().existingDirectory
		return url
	}

	static func tempFile(named path: String) -> URL {
		let url = URL.temp + path
		_ = url.dropLast().existingDirectory
		return url
	}

	static func library(named path: String) -> URL {
		let url = URL.library + path
		_ = url.dropLast().existingDirectory
		return url
	}

	static func bundled(in bundle: Bundle = .main, named name: String, withExtension ext: String? = nil, subDirectory: String? = nil) -> URL? {
		bundle.url(forResource: name, withExtension: ext, subdirectory: subDirectory)
	}
	
	func removeFromDisk() throws {
		guard isFileURL else { return }
		if FileManager.default.fileExists(at: self) { try FileManager.default.removeItem(at: self) }
	}
}
