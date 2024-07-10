//
//  DeSync.swift
//  
//
//  Created by Ben Gottlieb on 1/3/22.
//

import Foundation

public func desync<Output: Sendable>(block: @Sendable @escaping () async -> Output, completion: @Sendable @escaping (Output) -> Void) {
	Task {
		let result = await block()
		completion(result)
	}
}

public func desync<Output: Sendable>(block: @Sendable @escaping () async throws -> Output, completion: @Sendable @escaping (Result<Output, Error>) -> Void) {
	Task {
		do {
			let result = try await block()
			completion(.success(result))
		} catch {
			completion(.failure(error))
		}
	}
}

/*
@available(OSX 12, iOS 15.0, tvOS 13, watchOS 8, *)
public extension Publisher where Failure == Error, Output: Sendable  {
	func convertToAsync<MyOutput: Sendable>(block: @Sendable @escaping (Output) async throws -> MyOutput) -> AnyPublisher<MyOutput, Error> {
		flatMap { (input: Output) -> AnyPublisher<MyOutput, Error> in
			let future = Future<MyOutput, Error> { (promise: (Result<MyOutput, Error>) -> Void) in
				Task {
					do {
						let result = try await block(input)
						promise(.success(result))
					} catch {
						promise(.failure(error))
					}
				}
			}
			return future.eraseToAnyPublisher()
		}
		.eraseToAnyPublisher()
	}
}

@available(OSX 12, iOS 15.0, tvOS 13, watchOS 8, *)
public extension Publisher where Failure == Never, Output: Sendable  {
	func convertToAsync<MyOutput: Sendable>(block: @Sendable @escaping (Output) async -> MyOutput) -> AnyPublisher<MyOutput, Never> {
		flatMap { (input: Output) -> AnyPublisher<MyOutput, Never> in
			let future = Future<MyOutput, Never> { promise in
				Task {
					let result = await block(input)
					promise(.success(result))
				}
			}
			return future.eraseToAnyPublisher()
		}
		.eraseToAnyPublisher()
	}
}
*/
@available(OSX 12, iOS 15.0, tvOS 13, watchOS 8, *)
public extension Publisher where Failure == Error, Output: Sendable  {
	func asynchronize() async throws -> Output {
		var cancellable: AnyCancellable!
		var hasContinued = false
		
		let result: Output = try await withCheckedThrowingContinuation { continuation in
			cancellable = self
				.sink(receiveCompletion: { done in
					switch done {
					case .failure(let error):
						if hasContinued { return }
						continuation.resume(throwing: error)
						
					default:
						break
					}
				}, receiveValue: { output in
					cancellable?.cancel()
					if hasContinued { return }
					hasContinued = true
					continuation.resume(returning: output)
				})
			}
		
		return result
	}
}
