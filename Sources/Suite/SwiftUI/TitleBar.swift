//
//  TitleBar.swift
//  Internal
//
//  Created by Ben Gottlieb on 3/6/23.
//

import SwiftUI

public struct TitleBar<Leading: View, Trailing: View, Title: View>: View {
	let title: () -> Title
	let leading: () -> Leading
	let trailing: () -> Trailing
	
	public init(title: @escaping () -> Title, leading: @escaping () -> Leading, trailing: @escaping () -> Trailing) {
		self.title = title
		self.leading = leading
		self.trailing = trailing
	}
	
	public var body: some View {
		ZStack {
			leading()
				.frame(maxWidth: .infinity, alignment: .leading)

			trailing()
				.frame(maxWidth: .infinity, alignment: .trailing)
			
			title()
				.frame(maxWidth: .infinity, alignment: .center)
		}
		.padding(.horizontal)
		.frame(height: 50)
	}
}

extension TitleBar where Leading == EmptyView {
	public init(title: @escaping () -> Title, trailing: @escaping () -> Trailing) {
		self.init(title: title, leading: { EmptyView() }, trailing: trailing)
	}
}

extension TitleBar where Trailing == EmptyView {
	public init(title: @escaping () -> Title, leading: @escaping () -> Leading) {
		self.init(title: title, leading: leading, trailing: { EmptyView() })
	}
}

extension TitleBar where Trailing == EmptyView, Leading == EmptyView {
	public init(title: @escaping () -> Title) {
		self.init(title: title, leading: { EmptyView() }, trailing: { EmptyView() })
	}
}

extension TitleBar where Title == Text {
	public init(title: String, leading: @escaping () -> Leading, trailing: @escaping () -> Trailing) {
		self.init(title: { Text(title) }, leading: leading, trailing: trailing)
	}
}

extension TitleBar where Leading == EmptyView, Title == Text {
	public init(title: String, trailing: @escaping () -> Trailing) {
		self.init(title: { Text(title) }, leading: { EmptyView() }, trailing: trailing)
	}
}

extension TitleBar where Trailing == EmptyView, Title == Text {
	public init(title: String, leading: @escaping () -> Leading) {
		self.init(title: { Text(title) }, leading: leading, trailing: { EmptyView() })
	}
}

extension TitleBar where Trailing == EmptyView, Leading == EmptyView, Title == Text {
	public init(title: String) {
		self.init(title: { Text(title) }, leading: { EmptyView() }, trailing: { EmptyView() })
	}
}

struct TitleBar_Previews: PreviewProvider {
	static var previews: some View {
		TitleBar(title: "Title")
	}
}
