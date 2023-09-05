//
//  AVPlayer.swift
//  
//
//  Created by Ben Gottlieb on 6/6/21.
//

import Foundation
import AVKit
import AVFoundation

#if canImport(UIKit)

import UIKit
	public extension AVPlayer {
		static var cachedMoviesDirectory: URL = {
			let directory = FileManager.cachesDirectory.appendingPathComponent("cached_movies")
			try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
			return directory
		}()

		convenience init?(assetNamed name: String, extension ext: String) {
			let url = AVPlayer.cachedMoviesDirectory.appendingPathComponent(name + "." + ext)
			
			if FileManager.default.fileExists(at: url) {
				self.init(url: url)
				return
			}

			guard let video = NSDataAsset(name: name) else {
				self.init(url: url)
				return nil
			}
			
			FileManager.default.createFile(atPath: url.path, contents: video.data, attributes: nil)
			self.init(url: url)
		}
		
		var isPlaying: Bool { rate != 0 && error == nil }
	}

@available(watchOS 6.0, *)
public extension AVAudioPlayer {
	func seekTo(seconds: TimeInterval) {
		self.currentTime = seconds
	}

	func seekTo(percent: Double) {
		let time = self.duration * percent
		self.seekTo(seconds: time)
	}
}
#endif
