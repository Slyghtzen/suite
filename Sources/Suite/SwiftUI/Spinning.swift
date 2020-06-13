//
//  Spinning.swift
//  
//
//  Created by Ben Gottlieb on 6/12/20.
//

#if canImport(Combine)

import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13, watchOS 6, *)
public struct Spinning<Thing: View>: View {
	private let spinee: Thing
	private let period: TimeInterval
	@State private var rotation = Angle.zero
	
	public init(_ spinee: Thing, period: TimeInterval = 1) {
		self.spinee = spinee
		self.period = period
	}
	
	public var body: some View {
		spinee
			.rotationEffect(self.rotation)
			.animation(Animation.linear(duration: self.period).repeatForever(autoreverses: false))
			.onAppear { self.rotation = .radians(2 * .pi) }
	}
}

#endif
