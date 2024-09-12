//
//  Environment.swift
//  
//
//  Created by Ben Gottlieb on 3/19/23.
//

import SwiftUI

public struct IsEditingEnvironmentKey: EnvironmentKey {
	nonisolated(unsafe) public static var defaultValue = false
}

@available(iOS 16.0, macOS 13, watchOS 9, *)
public struct NavigationPathEnvironmentKey: EnvironmentKey {
	nonisolated(unsafe) public static var defaultValue = Binding.constant(NavigationPath())
}

public struct IsScrollingEnvironmentKey: EnvironmentKey {
	nonisolated(unsafe) public static var defaultValue = false
}

public struct DismissParentEnvironmentKey: EnvironmentKey {
	nonisolated(unsafe) public static var defaultValue = { }
}


@available(iOS 16.0, macOS 13, watchOS 9, *)
public extension EnvironmentValues {
	var navigationPath: Binding<NavigationPath> {
		get { self[NavigationPathEnvironmentKey.self] }
		set { self[NavigationPathEnvironmentKey.self] = newValue }
	}
}

public extension EnvironmentValues {
	var dismissParent: () -> Void {
		get { self[DismissParentEnvironmentKey.self] }
		set { self[DismissParentEnvironmentKey.self] = newValue }
	}
	
	var isEditing: Bool {
		get { self[IsEditingEnvironmentKey.self] }
		set { self[IsEditingEnvironmentKey.self] = newValue }
	}
	
	var isScrolling: Bool {
		get { self[IsScrollingEnvironmentKey.self] }
		set { self[IsScrollingEnvironmentKey.self] = newValue }
	}
}


