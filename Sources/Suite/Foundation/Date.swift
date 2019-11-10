//
//  Date+SA_Additions.swift
//  Suite
//
//  Created by Ben Gottlieb on 9/10/19.
//  Copyright (c) 2019 Stand Alone, Inc. All rights reserved.
//

import Foundation


extension Date {
	public enum StringLength: Int { case normal, short, veryShort }

	public enum DayOfWeek: Int { case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday
		public var nextDay: DayOfWeek { return self.increment(count: 1) }
		public func increment(count: Int) -> DayOfWeek { return DayOfWeek(rawValue: (self.rawValue + count - 1) % 7 + 1)! }
		public var abbrev: String { return Calendar.current.veryShortWeekdaySymbols[self.rawValue - 1] }
		public var shortName: String { return Calendar.current.shortWeekdaySymbols[self.rawValue - 1] }
		public var name: String { return Calendar.current.weekdaySymbols[self.rawValue - 1] }
		public var isWeekendDay: Bool { return self == .saturday || self == .sunday }
		public var isWeekDay: Bool { return !self.isWeekendDay }

		public static var firstDayOfWeek: DayOfWeek { return DayOfWeek(rawValue: Calendar.current.firstWeekday) ?? .monday }
		public static var weekdays: [DayOfWeek] {
			var days: [DayOfWeek] = []
			let first = Calendar.current.firstWeekday
			for i in 0..<7 {
				days.append(DayOfWeek(rawValue: (i + first + 7 - 1) % 7 + 1)!)
			}
			return days
		}
	}
	
	public enum Month: Int { case jan = 1, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
		public var nextMonth: Month { return self.increment(by: 1) }
		public func increment(by: Int) -> Month { return Month(rawValue: (self.rawValue + by - 1) % 12 + 1)! }
		public var abbrev: String { return Calendar.current.veryShortMonthSymbols[self.rawValue] }
		public var shortName: String { return Calendar.current.shortMonthSymbols[self.rawValue - 1] }
		public var name: String { return Calendar.current.monthSymbols[self.rawValue - 1] }
	}
	
	public var nearestSecond: Date {
		return Date(timeIntervalSinceReferenceDate: floor(self.timeIntervalSinceReferenceDate))
	}
}

public extension TimeInterval {
	static let minute: TimeInterval = 60.0
	static let hour: TimeInterval = 60.0 * 60.0
	static let day: TimeInterval = 60.0 * 60.0 * 24.0
	
	static var saveInterval: TimeInterval = 20.0
	static var keyPressSearchDelay: TimeInterval = 0.5
	static var pressAndHoldInterval: TimeInterval = 1.0

	
	var days: Int { return Int(self / .day) }
	var hours: Int { return Int(self / .hour) }
	var minutes: Int { return Int(self / .minute) }
	var seconds: Int { return Int(self) }
}


infix operator ≈≈ : ComparisonPrecedence
infix operator !≈ : ComparisonPrecedence


public func ≈≈(lhs: Date, rhs: Date) -> Bool {
	let lhSec = floor(lhs.timeIntervalSinceReferenceDate)
	let rhSec = floor(rhs.timeIntervalSinceReferenceDate)
	
	return lhSec == rhSec
}

public func !≈(lhs: Date, rhs: Date) -> Bool {
	let lhSec = floor(lhs.timeIntervalSinceReferenceDate)
	let rhSec = floor(rhs.timeIntervalSinceReferenceDate)
	
	return lhSec != rhSec
}

public extension Date {
	
	func localTimeString(dateStyle: DateFormatter.Style = .short, timeStyle: DateFormatter.Style = .short) -> String {
		let formatter = DateFormatter()
		
		formatter.dateStyle = dateStyle
		formatter.timeStyle = timeStyle
		
		return formatter.string(from: self)
	}
	
	var isToday: Bool { return self.isSameDay(as: Date()) }
	var isTomorrow: Bool { return self.isSameDay(as: Date().byAdding(days: 1)) }
	var isYesterday: Bool { return self.isSameDay(as: Date().byAdding(days: -1)) }
	
	func dateBySettingDate(date: Date?) -> Date {
		guard let date = date else { return self }
		let calendar = Calendar.current
		var components = calendar.dateComponents([.hour, .minute, .second, .year, .month, .day], from: self)
		let theirComponents = calendar.dateComponents([.year, .month, .day], from: date)
		
		components.year = theirComponents.year
		components.month = theirComponents.month
		components.day = theirComponents.day
		
		return calendar.date(from: components) ?? self
	}
	
	func dateBySettingTime(time: Date?) -> Date {
		guard let time = time else { return self }
		let calendar = Calendar.current
		var components = calendar.dateComponents([.hour, .minute, .second, .year, .month, .day], from: self)
		let theirComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
		
		components.hour = theirComponents.hour
		components.minute = theirComponents.minute
		components.second = theirComponents.second
		
		return calendar.date(from: components) ?? self
	}
	
	var dateOnly: Date { return self.midnight }			/// returns midnight on the day in question
	var timeOnly: Date { return self }					/// just returns the current date, since we're only interested in the time
	
	var midnight: Date { return self.byChanging(nanosecond: 0, second: 0, minute: 0, hour: 0) }
	var lastSecond: Date { return self.byChanging(nanosecond: 0, second: 59, minute: 59, hour: 23) }

	var year: Int { return self.components(which: .year).year! }
	var month: Month { return Month(rawValue: self.components(which: .month).month!) ?? .jan }
	var day: Int { return self.components(which: .day).day ?? 1 }
	var hour: Int { return self.components(which: .hour).hour ?? 0 }
	var minute: Int { return self.components(which: .minute).minute ?? 0 }
	var second: Int { return self.components(which: .second).second ?? 0 }
	var dayOfWeek: DayOfWeek { return DayOfWeek(rawValue: self.components(which: .weekday).weekday!) ?? .sunday }
	func dayOfWeekString(length: StringLength = .short) -> String {
		let day = self.dayOfWeek
		
		switch length {
		case .normal: return day.name
		case .short: return day.shortName
		case .veryShort: return day.abbrev
		}
	}
	
	var numberOfDaysInMonth: Int { return Date.numberOfDays(in: self.month, year: self.year) }
	
	static func numberOfDays(in month: Month, year: Int) -> Int {
		let shortMonths: [Month] = [.apr, .jun, .sep, .nov]
		if month == .feb { return year.isLeapYear ? 29 : 28 }
		if shortMonths.contains(month) { return 30 }
		return 31
	}
	
	var firstDayOfWeekInMonth: DayOfWeek { return self.firstDayInMonth.dayOfWeek }
	
	var firstDayInMonth: Date {
		let cal = Calendar.current
		var components = cal.dateComponents(in: TimeZone.current, from: self)
		components.day = 1
		let date = cal.date(from: components)
		return date ?? self
	}
	
	var lastDayInMonth: Date {
		let cal = Calendar.current
		var components = cal.dateComponents(in: TimeZone.current, from: self)
		components.day = self.numberOfDaysInMonth
		let date = cal.date(from: components)
		return date ?? self
	}
	
	func byAdding(seconds: Int? = nil, minutes: Int? = nil, hours: Int? = nil, days: Int? = nil, months: Int? = nil, years: Int? = nil) -> Date {
		
		let calendar = Calendar.current
		let components = DateComponents(calendar: calendar, year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds)
		
		return calendar.date(byAdding: components, to: self, wrappingComponents: false) ?? self
	}
	
	func byChanging(nanosecond: Int? = nil, second: Int? = nil, minute: Int? = nil, hour: Int? = nil, day: Int? = nil, month: Int? = nil, year: Int? = nil) -> Date {
		let units: Set<Calendar.Component> = [.year, .month, .day, .hour, .minute, .second, .nanosecond]
		let calendar = Calendar.current
		var components: DateComponents = calendar.dateComponents(units, from: self)
		
		if let nanosecond = nanosecond { components.nanosecond = nanosecond }
		if let second = second { components.second = second }
		if let minute = minute { components.minute = minute }
		if let hour = hour { components.hour = hour }
		if let day = day { components.day = day }
		if let month = month { components.month = month }
		if let year = year { components.year = year }

		return calendar.date(from: components) ?? self
	}
	
	var nextDay: Date {
		var components = DateComponents()
		components.day = 1
		
		return NSCalendar.current.date(byAdding: components, to: self, wrappingComponents: true) ?? self
	}
	
	var previousDay: Date {
		var components = DateComponents()
		components.day = -1
		
		return NSCalendar.current.date(byAdding: components, to: self, wrappingComponents: true) ?? self
	}
	
	var noon: Date { return self.byChanging(second: 0, minute: 0, hour: 12) }
	
//	func isAfter(date: Date) -> Bool { return self.earlierDate(date) != self && date != self }
//	func isBefore(date: Date) -> Bool { return self.earlierDate(date) == self && date != self }
	
	func isSameDay(as other: Date) -> Bool {
		let cal = NSCalendar.current
		let myComp = cal.dateComponents([.year, .month, .day], from: self)
		let otherComp = cal.dateComponents([.year, .month, .day], from: other)
		
		return (myComp.day == otherComp.day && myComp.month == otherComp.month && myComp.year == otherComp.year)
	}
	
	
	private func components(which: Calendar.Component) -> DateComponents { return Calendar.current.dateComponents([which], from: self) }
}

public extension Date {
	static func ageString(age: TimeInterval, style: DateFormatter.Style = .short) -> String {
		let seconds = abs(Int(age))
		let minutes = seconds / 60
		let hours = minutes / 60
		let days = hours / 24
		let weeks = days / 7
		let months = days / 30
		let years = months / 12
		
		if years > 0 {
			switch style {
			case .short: return "\(years)" + NSLocalizedString("y", comment: "short years")
			case .medium: return "\(years) " + NSLocalizedString("y", comment: "short years")
			case .long: return "\(years) " + NSLocalizedString("yr", comment: "medium years")
			case .full:
				if years == 1 { return NSLocalizedString("1 year", comment: "1 year") }
				return "\(years) " + NSLocalizedString("years", comment: "long years")
			default: return ""
			}
		}
		
		if months > 0 {
			switch style {
			case .short: return "\(months)" + NSLocalizedString("mo", comment: "short months")
			case .medium: return "\(months) " + NSLocalizedString("mo", comment: "short months")
			case .long: return "\(months) " + NSLocalizedString("mos", comment: "medium months")
			case .full:
				if months == 1 { return NSLocalizedString("1 month", comment: "1 month") }
				return "\(months) " + NSLocalizedString("months", comment: "long months")
			default: return ""
			}
		}
		
		if weeks > 0 {
			switch style {
			case .short: return "\(weeks)" + NSLocalizedString("w", comment: "short weeks")
			case .medium: return "\(weeks) " + NSLocalizedString("w", comment: "short weeks")
			case .long: return "\(weeks) " + NSLocalizedString("wk", comment: "medium weeks")
			case .full:
				if weeks == 1 { return NSLocalizedString("1 week", comment: "1 week") }
				return "\(weeks) " + NSLocalizedString("weeks", comment: "long weeks")
			default: return ""
			}
		}
		
		if days > 0 {
			switch style {
			case .short: return "\(days)" + NSLocalizedString("d", comment: "short days")
			case .medium: return "\(days) " + NSLocalizedString("d", comment: "short days")
			case .long: return "\(days) " + NSLocalizedString("days", comment: "medium days")
			case .full:
				if days == 1 { return NSLocalizedString("1 day", comment: "1 day") }
				return "\(days) " + NSLocalizedString("days", comment: "long days")
			default: return ""
			}
		}
		
		if hours > 0 {
			switch style {
			case .short: return "\(hours)" + NSLocalizedString("h", comment: "short hours")
			case .medium: return "\(hours) " + NSLocalizedString("h", comment: "short hours")
			case .long: return "\(hours) " + NSLocalizedString("hr", comment: "medium hours")
			case .full:
				if hours == 1 { return NSLocalizedString("1 hour", comment: "1 hour") }
				return "\(hours) " + NSLocalizedString("hours", comment: "long hours")
			default: return ""
			}
		}
		
		if minutes > 0 {
			switch style {
			case .short: return "\(minutes)" + NSLocalizedString("m", comment: "short minutes")
			case .medium: return "\(minutes) " + NSLocalizedString("m", comment: "short minutes")
			case .long: return "\(minutes) " + NSLocalizedString("min", comment: "medium minutes")
			case .full:
				if minutes == 1 { return NSLocalizedString("1 minute", comment: "1 minute") }
				return "\(minutes) " + NSLocalizedString("minutes", comment: "long minutes")
			default: return ""
			}
		}
		
		if seconds > 0 {
			switch style {
			case .short: return "\(seconds)" + NSLocalizedString("s", comment: "short seconds")
			case .medium: return "\(seconds) " + NSLocalizedString("s", comment: "short seconds")
			case .long: return "\(seconds) " + NSLocalizedString("sec", comment: "medium seconds")
			case .full:
				if seconds == 1 { return NSLocalizedString("1 second", comment: "1 second") }
				return "\(seconds) " + NSLocalizedString("seconds", comment: "long seconds")
			default: return ""
			}
		}
		
		return NSLocalizedString("now", comment: "now")
	}

}

public extension Int {
	var isLeapYear: Bool {
		let year = self
		
		if year % 4 != 0 { return false }
		if year % 400 == 0 { return true }
		return year % 100 != 0
	}
	
}