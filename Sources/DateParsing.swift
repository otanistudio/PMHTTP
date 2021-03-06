//
//  DateParsing.swift
//  PMHTTP
//
//  Created by Kevin Ballard on 3/3/16.
//  Copyright © 2016 Postmates.
//
//  Licensed under the Apache License, Version 2.0 <LICENSE-APACHE or
//  http://www.apache.org/licenses/LICENSE-2.0> or the MIT license
//  <LICENSE-MIT or http://opensource.org/licenses/MIT>, at your
//  option. This file may not be copied, modified, or distributed
//  except according to those terms.
//

import Foundation

public extension HTTPManager {
    /// Parses the `Date` header from a URL response and returns it.
    ///
    /// - Parameter response: An `NSURLResponse` that the header is pulled from. If this
    ///   is not an `NSHTTPURLResponse`, `nil` is returned.
    /// - Returns: An `NSDate`, or `nil` if the header doesn't exist or has an invalid format.
    static func parsedDateHeaderFromResponse(response: NSURLResponse) -> NSDate? {
        guard let response = response as? NSHTTPURLResponse,
            dateString = response.allHeaderFields["Date"] as? String
            else { return nil }
        return parsedDateHeaderFromString(dateString)
    }
    
    /// Parses a header value that is formatted like the "Date" HTTP header.
    ///
    /// This parses the specific format allowed for the "Date" header, and any
    /// other header that uses the `HTTP-date` production.
    ///
    /// See [section 3.3.1 of RFC 2616][RFC] for details.
    ///
    /// [RFC]: https://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1
    ///
    /// - Parameter dateString: The string value of the HTTP header.
    /// - Returns: An `NSDate`, or `nil` if `dateString` contains an invalid format.
    static func parsedDateHeaderFromString(dateString: String) -> NSDate? {
        return rfc1123DateFormatter.dateFromString(dateString)
            ?? rfc850DateFormatter.dateFromString(dateString)
            ?? asctimeDateFormatter.dateFromString(dateString)
    }
    
    private static let posixLocale = NSLocale(localeIdentifier: "en_US_POSIX")
    private static let gregorianCalendar: NSCalendar = {
        let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        return calendar
    }()
    private static let rfc1123DateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = posixLocale
        formatter.calendar = gregorianCalendar
        formatter.timeZone = gregorianCalendar.timeZone
        formatter.dateFormat = "EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'"
        formatter.lenient = false
        return formatter
    }()
    private static let rfc850DateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = posixLocale
        formatter.calendar = gregorianCalendar
        formatter.timeZone = gregorianCalendar.timeZone
        formatter.dateFormat = "EEEE',' dd'-'MMM'-'yy HH':'mm':'ss 'GMT'"
        formatter.lenient = false
        // From RFC 2616 Section 19.3 Tolerant Applications:
        // > HTTP/1.1 clients and caches SHOULD assume that an RFC-850 date
        // > which appears to be more than 50 years in the future is in fact
        // > in the past (this helps solve the "year 2000" problem).
        formatter.twoDigitStartDate = gregorianCalendar.dateByAddingUnit(.Year, value: -49, toDate: NSDate(), options: [])
        return formatter
    }()
    private static let asctimeDateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.locale = posixLocale
        formatter.calendar = gregorianCalendar
        formatter.timeZone = gregorianCalendar.timeZone
        // NB: asctime specifies day as ( 2DIGIT | ( SP 1DIGIT ) ). There's no way to represent this with a
        // date format, ICU seems to treat stretches of consecutive whitespace all as a single space, so this should
        // still parse just fine. Luckily we don't have to generate these strings.
        formatter.dateFormat = "EEE MMM dd HH':'mm':'ss yyyy"
        formatter.lenient = false
        return formatter
    }()
}
