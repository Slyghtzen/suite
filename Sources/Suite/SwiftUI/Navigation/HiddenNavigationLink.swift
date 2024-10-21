//
//  HiddenNavigationLink.swift
//  Suite
//
//  Created by Ben Gottlieb on 10/21/24.
//

import SwiftUI

@available(iOS 16.0, *)
public struct HiddenNavigationLink<Label: View, Value: Hashable>: View {
	let value: Value?
	let label: Label
	public init(value: Value?, @ViewBuilder label: () -> Label) {
		self.value = value
		self.label = label()
	}
	
	public var body: some View {
		ZStack {
			NavigationLink(value: value, label: { EmptyView() }).opacity(0)
			label
		}
	}
}
