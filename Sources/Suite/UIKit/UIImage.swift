//
//  UIImage.swift
//  
//
//  Created by Ben Gottlieb on 12/7/19.
//

#if canImport(UIKit)
import UIKit

public enum ImageFormat: String, Sendable { case PNG = "png", JPEG = "jpeg"
	public var mimeType: String {
		switch self {
		case .PNG: return "image/png"
		case .JPEG: return "image/jpeg"
		}
	}
}


@available(iOS 13.0, watchOS 6.0, *)
public extension UIImage {
	convenience init?(_ sfsymbol: SFSymbol) {
		self.init(systemName: sfsymbol.rawValue)
	}
}

public extension UIImage {
	enum ImageStoreError: Error, Sendable { case nonLocalURL, unableToConverToData }
	func store(in url: URL) throws {
		if !url.isFileURL { throw ImageStoreError.nonLocalURL }
		guard let data = self.pngData() else { throw ImageStoreError.unableToConverToData }
		let dir = url.deletingLastPathComponent()
		try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
		try data.write(to: url, options: [.atomic])
	}

	convenience init?(contentsOf url: URL) {
		guard let data = try? Data(contentsOf: url), data.count != 0 else {
			self.init()
			return nil
		}
		
		self.init(data: data)
	}
	
	#if os(iOS)
	func byRoundingCorners(radius: CGFloat) -> UIImage {
		UIImage.create(size: size) { context in
			context.clear(size.rect)
			let bezier = UIBezierPath(roundedRect: size.rect, cornerRadius: radius)
			bezier.addClip()
			self.draw(in: size.rect)
		} ?? self
		
	}
	
	@available(iOS 10.0, watchOS 6.0, *)
	func clipped(to clip: CGRect) -> UIImage? {
		UIGraphicsBeginImageContextWithOptions(clip.size, false, self.scale)
		self.draw(at: CGPoint(x: -clip.minX, y: -clip.minY))
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return image
	}
	

	
	class func create(size: CGSize, closure: (CGContext) -> Void) -> UIImage? {
		if #available(iOS 10.0, iOSApplicationExtension 10.0, *) {
			return UIGraphicsImageRenderer(size: size).image { renderer in
				guard let ctx = UIGraphicsGetCurrentContext() else {
					dlogg("UIGraphicsGetCurrentContext() Failed")
					return
				}
				
				closure(ctx)
			}
		} else {
			UIGraphicsBeginImageContextWithOptions(size, false, 0)
			guard let ctx = UIGraphicsGetCurrentContext() else {
				dlogg("UIGraphicsGetCurrentContext() Failed")
				return nil
			}

			closure(ctx)
			let image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			return image
		}
	}
	#endif
	
	func tintedImage(tint: UIColor) -> UIImage? {
		let frame = self.size.rect
		
		UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
		self.draw(in: frame)
		tint.setFill()
		UIRectFillUsingBlendMode(frame, CGBlendMode.sourceIn)
		let result = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()

		return result
	}
	
    func overlaying(_ overlay: UIImage) async -> UIImage {
        let frame = self.size.rect
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        self.draw(in: frame)
        await overlay.resized(to: self.size, trimmed: true)?.draw(in: frame)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return result ?? self
    }

	func scaledImage(scale: CGFloat) -> UIImage {
		if scale == 1.0 { return self }
		if let cgImage = self.cgImage {
			return UIImage(cgImage: cgImage, scale: 1 / scale, orientation: .up)
		}
		return self
	}

	@MainActor func resized(to limit: CGSize?, trimmed: Bool = true) -> UIImage? {
		resized(to: limit, trimmed: trimmed, scale: UIView.screenScale)
	}
	
	func resized(to limit: CGSize?, trimmed: Bool = true, scale: Double) -> UIImage? {
		guard let limit = limit else { return self }
		var frame = self.size.rect.within(limit: limit.rect, placed: .scaleAspectFit).rounded()

		if frame.origin.x > 0 {
			frame.origin.x = 0;
			if trimmed { frame.size.width = limit.width; }
		} else {
			frame.origin.y = 0;
			if trimmed { frame.size.height = limit.height; }
		}
		
		UIGraphicsBeginImageContextWithOptions(frame.size, false, scale)
		
		self.draw(in: frame)
		
		let result = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return result
	}
	
	func draw(in frame: CGRect, blendMode: CGBlendMode = .normal, alpha: CGFloat = 1.0, mode: CGRect.Placement) {
		var rect = self.size.rect.within(limit: frame, placed: mode)
        rect.origin.x += frame.minX
        rect.origin.y += frame.minY
		self.draw(in: rect, blendMode: blendMode, alpha: alpha)
	}
	
	var hasAlpha: Bool {
		guard let cg = self.cgImage else { return false }
		
		let alpha = cg.alphaInfo
		
		return (alpha == .first || alpha == .last || alpha == .premultipliedFirst || alpha == .premultipliedLast)
	}

}

#if os(iOS)
@available(iOS 10.0, *)
public extension UIImage {
	static func from(string: String, ofSize size: CGSize = CGSize(width: 128, height: 128), background color: UIColor = .clear) -> UIImage? {
		var fontSize = size.height
		var attributedString = NSAttributedString(string: "")
		var attributedStringSize: CGSize = .zero
		
		while true {
			attributedString = NSAttributedString(string: string, attributes: [.font: UIFont.systemFont(ofSize: fontSize)])
			attributedStringSize = attributedString.size()
			
			if attributedStringSize.height <= size.height, attributedStringSize.width < size.width { break }
			fontSize -= 1
		}
		
		return UIGraphicsImageRenderer(size: size).image { ctx in
			color.setFill()
			UIRectFill(size.rect)
			attributedString.draw(in: CGRect(x: (size.width - attributedStringSize.width) / 2, y: (size.height - attributedStringSize.height) / 2, width: attributedStringSize.width, height: attributedStringSize.height))
		}
	}
}

@available(iOS 10.0, *)
public extension UIImage {
	static func randomEmojiImage(face: Bool = false, ofSize size: CGSize, background color: UIColor = .white) -> UIImage? {
		from(string: String.randomEmoji(facesOnly: face), ofSize: size, background: color)
	}
}
#endif
#endif
