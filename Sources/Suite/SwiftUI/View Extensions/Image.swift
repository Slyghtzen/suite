//
//  Image.swift
//  
//
//  Created by Ben Gottlieb on 5/14/20.
//

#if canImport(Combine)
import SwiftUI

@available(OSX 10.15, iOS 13.0, watchOS 6.0, *)
public extension Image {
	@MainActor @inlinable func resizeTo(_ mode: ContentMode = .fit, _ size: CGSize) -> some View {
		return self
			.resizable()
			.aspectRatio(contentMode: mode)
			.frame(size: size)
	}
}

@available(OSX 10.16, iOS 13.0, watchOS 6.0, *)
public extension Image {
	init(_ sfsymbol: SFSymbol) {
		self.init(systemName: sfsymbol.rawValue)
	}
	
	static func random() -> Image {
		Image(SFSymbol.allCases.randomElement()!)
	}
}

#if os(iOS)
@available(iOS 13.0, *)
public extension Image {
	init(string: String) {
		let image = UIImage.from(string: string)
		self.init(uiImage: image ?? UIImage())
	}
}
#endif

#endif
