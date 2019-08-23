//
//  CurrencyFormatter.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2018-11-24.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

import Foundation

/// A formatter that converts between monetary values and their textual representations.
public struct CurrencyFormatter {
    private let formatter: NumberFormatter
    private let autoTruncate: Bool
    
    /// Initialize a new currency formatter.
    ///
    /// - Parameters:
    ///   - locale: The locale to retrieve the currency from.
    ///   - autoTruncate: Truncate decimal if `.00`.
    ///   - decimalDigits: The minimum number of digits after the decimal separator. Default is 2.
    ///   - usePrefix: Adds a prefix for positive and negative values.
    public init(for locale: Locale = .current, autoTruncate: Bool = false, decimalDigits: Int = 2, usePrefix: Bool = false) {
        self.formatter = NumberFormatter().with {
            $0.numberStyle = .currency
            $0.locale = locale
            $0.currencyCode = locale.currencyCode
            $0.minimumFractionDigits = decimalDigits
            $0.maximumFractionDigits = decimalDigits
            
            if usePrefix {
                $0.positivePrefix = $0.plusSign + $0.currencySymbol
                $0.negativePrefix = $0.negativePrefix + ""
            }
        }
        
        self.autoTruncate = autoTruncate
    }
}

public extension CurrencyFormatter {
    
    /// Returns a string containing the formatted value of the provided number object.
    ///
    ///     let amount: DOuble = 123456789.987
    ///
    ///     let formatter = CurrencyFormatter()
    ///     formatter.string(fromAmount: amount) // "$123,456,789.99"
    ///
    ///     let formatter2 = CurrencyFormatter(for: Locale(identifier: "fr-FR"))
    ///     formatter2.string(fromAmount: amount) // "123 456 789,99 €"
    ///
    /// - Parameter double: A monetary number that is parsed to create the returned string object.
    /// - Returns: A string containing the formatted value of number using the receiver’s current settings.
    func string(fromAmount double: Double) -> String {
        let validValue = getAdjustedForDefinedInterval(value: double)
        
        if autoTruncate && validValue.truncatingRemainder(dividingBy: 1) == 0 {
            let truncatingFormatter = formatter.copy() as? NumberFormatter // TODO: Lazy load
            truncatingFormatter?.minimumFractionDigits = 0
            truncatingFormatter?.maximumFractionDigits = 0
            return truncatingFormatter?.string(from: validValue as NSNumber) ?? "\(double)"
        }
        
        return formatter.string(from: validValue as NSNumber) ?? "\(double)"
    }
    
    /// Returns the given value adjusted to respect formatter's max an min values.
    ///
    /// - Parameter value: value to be adjusted if needed
    /// - Returns: Ajusted value
    private func getAdjustedForDefinedInterval(value: Double?) -> Double {
        if let minValue = formatter.minimum?.doubleValue, value ?? 0 < minValue {
            return minValue
        } else if let maxValue = formatter.maximum?.doubleValue, value ?? 0 > maxValue {
            return maxValue
        }
        return value ?? 0
    }
}

public extension CurrencyFormatter {
    
    /// Returns a string containing the currency formatted value of the provided number object.
    ///
    ///     let cents = 123456789
    ///
    ///     let formatter = CurrencyFormatter()
    ///     formatter.string(fromCents: cents) // "$1,234,567.89"
    ///
    ///     let formatter2 = CurrencyFormatter(for: Locale(identifier: "fr-FR"))
    ///     formatter2.string(fromCents: cents) // "1 234 567,89 €"
    ///
    /// - Parameter cents: The cents of the value.
    /// - Returns: A string containing the formatted value of number using the receiver’s current currency settings.
    func string(fromCents cents: Int) -> String {
        let amount = Double(cents) / 100
        return string(fromAmount: amount)
    }
}
