//
//  UserDefaultsContainer.swift
//  
//
//  Created by Ben Gottlieb on 6/9/24.
//

import Foundation

public protocol UserDefaultsContainer {
	nonisolated var userDefaults: UserDefaults { get }
}

public extension UserDefaultsContainer {
	nonisolated func hasValue(for key: String) -> Bool { userDefaults.object(forKey: key) != nil }
	
	nonisolated func setString(_ string: String?, for key: String) { userDefaults.setValue(string, forKey: key) }
	nonisolated func string(for key: String) -> String? { userDefaults.string(forKey: key) }
	
	nonisolated func setBool(_ bool: Bool, for key: String) { userDefaults.setValue(bool, forKey: key) }
	nonisolated func bool(for key: String) -> Bool { userDefaults.bool(forKey: key) }
	
	nonisolated func setDate(_ date: Date?, for key: String) { userDefaults.setValue(date, forKey: key) }
	nonisolated func date(for key: String) -> Date? { userDefaults.object(forKey: key) as? Date }
	
	nonisolated func setData(_ data: Data?, for key: String) { userDefaults.setValue(data, forKey: key) }
	nonisolated func data(for key: String) -> Data? { userDefaults.data(forKey: key) }
	
	nonisolated func setInt(_ int: Int, for key: String) { userDefaults.setValue(int, forKey: key) }
	nonisolated func int(for key: String) -> Int { userDefaults.integer(forKey: key) }
	
	nonisolated func setDouble(_ double: Double, for key: String) { userDefaults.setValue(double, forKey: key) }
	nonisolated func double(for key: String) -> Double { userDefaults.double(forKey: key) }
}
