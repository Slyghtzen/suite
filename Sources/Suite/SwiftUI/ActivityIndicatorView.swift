//
//  ActivityIndicatorView.swift
//  
//
//  Created by ben on 5/1/20.
//

#if canImport(Combine)

import SwiftUI
import Foundation

@available(OSX 10.15, iOS 13.0, tvOS 13, watchOS 6, *)
public struct ActivityIndicatorView: View {
	@State private var spokeRotation = 1
	@State private var timer: Timer?
	
	private var fixedPercent: Double?
	private var spokeCount: Int

	private var period: TimeInterval = 1.0
	private var spokeColors: [Color]
	private let visibleSpokeCount: Int
	
	public init(_ color: Color = Color(white: 0.5), count: Int = 8, fixed percent: Double? = nil) {
		spokeCount = count
		fixedPercent = percent
		visibleSpokeCount = Int(Double(count) * (percent ?? 1))

		spokeColors = Array(0..<count).map { color.opacity(1.0 - Double($0) / Double(count)) }
	}
	
	static public var smallHeight: CGFloat = 20
	static public var mediumHeight: CGFloat = 35
	static public var largeHeight: CGFloat = 50

	public func small() -> some View { self.frame(width: Self.smallHeight, height: Self.smallHeight) }
	public func medium() -> some View { self.frame(width: Self.mediumHeight, height: Self.mediumHeight) }
	public func large() -> some View { self.frame(width: Self.largeHeight, height: Self.largeHeight) }
	
	public var body: some View {
		self.spokes
			.onAppear() {
				timer = Timer(timeInterval: 0.1, repeats: true) { _ in
					spokeRotation += 1
				}
				#if os(iOS)
					RunLoop.main.add(timer!, forMode: .common)
				#else
					RunLoop.main.add(timer!, forMode: .common)
				#endif
			}
			.onDisappear() {
				timer?.invalidate()
			}
	}
	
	var spokes: some View {
		GeometryReader { geo in
			if visibleSpokeCount > 0 {
				ForEach(0..<visibleSpokeCount, id: \.self) { index in
					RoundedRectangle(cornerRadius: 2)
						.fill(spokeColor(at: index))
						.frame(width: geo.size.width / 8.5, height: geo.size.height / 3)
						.position(x: geo.size.width / 2, y: geo.size.height / 6)
						.rotationEffect(.radians(2 * .pi * Double(index) / Double(self.spokeCount)))
				}
			}
		}
	}
	
	func spokeColor(at index: Int) -> Color {
		if let percent = fixedPercent {
			let colorIndex = (Int(percent * Double(spokeCount)) - index) % spokeCount
			
			return spokeColors[colorIndex]
		}
		
		let colorIndex = (spokeCount + spokeRotation - index) % spokeCount
		return spokeColors[colorIndex]
	}
}

#endif
