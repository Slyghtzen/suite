//
//  View+ViewContoller.swift
//  
//
//  Created by ben on 3/22/20.
//

#if canImport(UIKit) && !os(watchOS)
#if canImport(Combine)
#if canImport(SwiftUI)

import UIKit
import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13, watchOS 6, *)
@available(iOSApplicationExtension, unavailable)
public class EnclosingViewControllerContainer: CustomStringConvertible {
	weak var _viewController: UIViewController?
	public init() { }
	
	public var description: String { 
		if let controller = self._viewController {
			return "Contained controller: \(type(of: controller))"
		}
		return "Contained controller: none"
	}
	@MainActor public var viewController: UIViewController? {
		if let current = self._viewController { return current }
		return UIApplication.shared.currentWindow?.rootViewController
	}
	
	public func load(_ viewController: UIViewController?) {
		self._viewController = viewController
	}
}

@available(OSX 10.15, iOS 13.0, tvOS 13, watchOS 6, *)
@available(iOSApplicationExtension, unavailable)
public struct EnclosingViewControllerKey: EnvironmentKey {
    nonisolated(unsafe) public static var defaultValue = EnclosingViewControllerContainer()
}

@available(OSX 10.15, iOS 13.0, tvOS 13, watchOS 6, *)
@available(iOSApplicationExtension, unavailable)
extension EnvironmentValues {
    public var enclosingViewControllerContainer: EnclosingViewControllerContainer {
        get { self[EnclosingViewControllerKey.self] }
        set { self[EnclosingViewControllerKey.self] = newValue }
    }
}

@available(OSX 10.15, iOS 13.0, tvOS 13, watchOS 6, *)
@available(iOSApplicationExtension, unavailable)
public protocol ContainedInViewController {
	var enclosingViewControllerContainer: EnclosingViewControllerContainer { get }
}

@available(OSX 10.15, iOS 13.0, tvOS 13, watchOS 6, *)
@available(iOSApplicationExtension, unavailable)
public extension View {
	var enclosingViewController: UIViewController? {
		return (self as? ContainedInViewController)?.enclosingViewControllerContainer.viewController
	}
	
	var enclosingRootViewController: UIViewController? {
		return enclosingViewController ?? UIApplication.shared.currentWindow?.rootViewController
	}
	
	func load(enclosingViewController: UIViewController?) {
		(self as? ContainedInViewController)?.enclosingViewControllerContainer.load(enclosingViewController) 
	}
}




#endif
#endif
#endif
