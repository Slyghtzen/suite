//
//  ScreenOrientedView.swift
//
//  Created by ben on 4/6/20.
//  Copyright © 2020 Ben Gottlieb. All rights reserved.
//

#if canImport(Combine)
#if canImport(UIKit) && !os(watchOS) && !os(visionOS)
import SwiftUI
import Combine
import UIKit

@available(OSX 10.15, iOS 13.0, tvOS 13, watchOS 6, *)
@available(iOSApplicationExtension, unavailable)
@MainActor public class OrientationWatcher: ObservableObject, @preconcurrency CustomStringConvertible {
	public static var instance = OrientationWatcher()
	
	public static func setup(windowScene: UIWindowScene) {
		self.instance = OrientationWatcher(initialOrientation: windowScene.interfaceOrientation)
	}
	
	var cancellables = Set<AnyCancellable>()
	init(initialOrientation: UIInterfaceOrientation = .unknown) {
		self.orientation = initialOrientation
		self.subscription = UIDevice.orientationDidChangeNotification.publisher()
			.sink() { device in
				if let newOrientation = UIApplication.shared.currentScene?.interfaceOrientation, newOrientation != self.orientation {
					self.orientation = newOrientation
				}
			}
	}
	
	@Published public var orientation: UIInterfaceOrientation
	private var subscription: AnyCancellable!
	
	public var isLandscape: Bool { return self.orientation.isLandscape }
	public var description: String { return self.isLandscape ? "Landscape" : "Portrait" }
}

@available(OSX 10.15, iOS 13.0, tvOS 13, watchOS 6, *)
@available(iOSApplicationExtension, unavailable)
public struct InterfaceOrientedView<Contents: View>: View {
	@ObservedObject var orientationWatcher = OrientationWatcher.instance
	
	let contents: () -> Contents
	public init(contents: @escaping () -> Contents) {
		self.contents = contents
	}
	
    public var body: some View {
		contents()
			.id(orientationWatcher.isLandscape)
	}
}

#endif
#endif
