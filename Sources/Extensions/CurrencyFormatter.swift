//
//  CurrencyFormatter.swift
//  ZamzamKit
//
//  Created by Basem Emara on 2018-11-24.
//  Copyright © 2018 Zamzam. All rights reserved.
//

import Foundation

/// A formatter that converts between numeric values and their textual currency representations.
public struct CurrencyFormatter {
    private let formatter: NumberFormatter
    
    public init(from locale: Locale = .current, fractionDigits: Int = 2) {
        self.formatter = NumberFormatter().with {
            $0.locale = locale
            $0.numberStyle = .currency
            $0.currencyCode = locale.currencyCode
            $0.minimumFractionDigits = fractionDigits
            $0.maximumFractionDigits = fractionDigits
        }
    }
}

public extension CurrencyFormatter {
    
    /// Returns a string containing the currency formatted value of the provided number object.
    ///
    ///     let amount: Decimal = 123456789.987
    ///
    ///     let formatter = CurrencyFormatter()
    ///     formatter.string(fromAmount: amount) -> "$123,456,789.99"
    ///
    ///     let formatter2 = CurrencyFormatter(from: Locale(identifier: "fr-FR"))
    ///     formatter2.string(fromAmount: amount) -> "123 456 789,99 €"
    ///
    /// - Parameter amount: The amount of the value.
    /// - Returns: A string containing the formatted value of number using the receiver’s current currency settings.
    func string(fromAmount amount: Decimal) -> String {
        return formatter.string(from: amount as NSDecimalNumber) ?? "\(amount)"
    }
    
    /// Returns a string containing the currency formatted value of the provided number object.
    ///
    ///     let cents = 123456789
    ///
    ///     let formatter = CurrencyFormatter()
    ///     formatter.string(fromCents: cents) -> "$1,234,567.89"
    ///
    ///     let formatter2 = CurrencyFormatter(from: Locale(identifier: "fr-FR"))
    ///     formatter2.string(fromCents: cents) -> "1 234 567,89 €"
    ///
    /// - Parameter cents: The cents of the value.
    /// - Returns: A string containing the formatted value of number using the receiver’s current currency settings.
    func string(fromCents cents: Int) -> String {
        let amount = Decimal(cents) / 100
        return string(fromAmount: amount)
    }
}
