//
//  UIColor.swift
//  
//
//  Created by Ben Gottlieb on 12/2/19.
//

#if canImport(UIKit)
import UIKit

public extension UIColor {
	convenience init?(hex hexString: String?) {
		guard let values = hexString?.extractedHexValues else {
			self.init(white: 0, alpha: 0)
			return nil
		}
		self.init(red: CGFloat(values[0]), green: CGFloat(values[1]), blue: CGFloat(values[2]), alpha: CGFloat(values.count > 3 ? values[3] : 1.0))
	}
	
	convenience init(red: Int, green: Int, blue: Int, alpha: Double = 1.0) {
		self.init(red: CGFloat(red.capped(0...255)) / 255.0, green: CGFloat(green.capped(0...255)) / 255.0, blue: CGFloat(blue.capped(0...255)) / 255.0, alpha: CGFloat(alpha))
	}
	
	convenience init(hex: Int, alpha: Double = 1.0) {
		self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: hex & 0xFF, alpha: alpha)
	}
	
	var hexString: String {
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		
		self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		
		let r = Int(255.0 * red)
		let g = Int(255.0 * green)
		let b = Int(255.0 * blue)
		
		return String(format: "%02x%02x%02x", arguments: [r, g, b])
	}

	var hex: Int {
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		
		self.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		
		let r = Int(255.0 * red)
		let g = Int(255.0 * green)
		let b = Int(255.0 * blue)
		
		return r << 16 + g << 8 + b
	}
}
#else
	import Cocoa
#endif

public extension Int {
	
}

public extension String {
	var extractedHexValues: [Double]? {
		var rgbValue: UInt32 = 0
		var hex = self
		
		if hex.hasPrefix("#") { hex = String(hex.dropFirst()) }
		
		if #available(macOS 10.15, iOS 13.0, *) {
			let rgbInt = Scanner(string: hex).scanInt(representation: .hexadecimal) ?? 0
			rgbValue = UInt32(rgbInt)
		} else {
			Scanner(string: hex).scanHexInt32(&rgbValue)
		}
		
		if hex.count == 3 {
			return [
				Double((rgbValue & 0x000F00) >> 8) / 15,
				Double((rgbValue & 0x0000F0) >> 4) / 15,
				Double(rgbValue & 0x00000F) / 15,
			]
		}
		
		if hex.count == 4 {
			return [
				Double((rgbValue & 0x000F00) >> 12) / 15,
				Double((rgbValue & 0x000F00) >> 8) / 15,
				Double((rgbValue & 0x0000F0) >> 4) / 15,
				Double(rgbValue & 0x00000F),
			]
		}
		
		if hex.count == 6 {
			return [
				Double((rgbValue & 0xFF0000) >> 16) / 255,
				Double((rgbValue & 0x00FF00) >> 8) / 255,
				Double(rgbValue & 0x0000FF) / 255
			]
		}

		if hex.count == 8 {
			return [
				Double((rgbValue & 0xFF0000) >> 24) / 255,
				Double((rgbValue & 0xFF0000) >> 16) / 255,
				Double((rgbValue & 0x00FF00) >> 8) / 255,
				Double(rgbValue & 0x0000FF) / 255
			]
		}
		return nil
	}
}