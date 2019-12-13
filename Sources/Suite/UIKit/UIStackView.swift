//
//  UIStackView.swift
//  
//
//  Created by ben on 11/29/19.
//

import UIKit

public extension UIStackView {
	@discardableResult
	func setup(inScrollView scrollView: UIScrollView) -> Self {
		scrollView.add(subview: self)
		
		self.translatesAutoresizingMaskIntoConstraints = false
		self.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
		self.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
		self.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
		
		return self
	}
	
	@discardableResult func axis(_ axis: NSLayoutConstraint.Axis) -> Self {
		self.axis = axis
		return self
	}
	
	@discardableResult func alignment(_ alignment: UIStackView.Alignment) -> Self {
		self.alignment = alignment
		return self
	}
	
	@discardableResult func distribution(_ distribution: UIStackView.Distribution) -> Self {
		self.distribution = distribution
		return self
	}
	
	@discardableResult func spacing(_ spacing: CGFloat) -> Self {
		self.spacing = spacing
		return self
	}
	
	@discardableResult func addArrangedSubviews(_ views: UIView...) -> Self {
		for view in views {
			addArrangedSubview(view)
		}
		return self
	}
	
	@discardableResult func addArrangedSubviews(_ views: [UIView]) -> Self {
		for view in views {
			addArrangedSubview(view)
		}
		return self
	}
	
	@discardableResult func removeAllArrangedSubviews() -> Self {
		for view in self.arrangedSubviews {
			removeArrangedSubview(view)
			view.removeFromSuperview()
		}
		
		return self
	}
	
	@discardableResult func customSpacing(_ spacing: CGFloat, after arrangedSubview: UIView) -> Self {
		self.setCustomSpacing(spacing, after: arrangedSubview)
		return self
	}
	
}