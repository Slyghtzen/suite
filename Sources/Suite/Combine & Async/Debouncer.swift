//
//  Debouncer.swift
//
//
//  Created by Ben Gottlieb on 11/28/22.
//

import Foundation
import Combine

@MainActor public class Debouncer<Value: Sendable>: ObservableObject {
	@Published public var input: Value
	@Published public var output: Value
	
	private var debounce: AnyCancellable?
	
	public func setInput(_ newInput: Value, withoutDebounce: Bool) {
		input = newInput
		if withoutDebounce {
			output = newInput
		}
	}
	
	public init(initialValue: Value, delay: Double = 1) {
		self.input = initialValue
		self.output = initialValue
		debounce = $input
			.debounce (for: . seconds (delay), scheduler: DispatchQueue.main)
			.sink { [weak self] result in
				guard let self else { return }
				Task { @MainActor in self.output = result }
			}
	}
}
