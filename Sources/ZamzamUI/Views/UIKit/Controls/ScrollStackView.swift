//
//  ScrollStackView.swift
//  ZamzamUI
//
//  Created by Basem Emara on 2020-04-19.
//  Inspired by: https://github.com/airbnb/AloeStackView
//
//  Copyright © 2020 Zamzam Inc. All rights reserved.
//

import UIKit
import ZamzamCore

/// A simple class for laying out a collection of views with a convenient API, while leveraging the power of Auto Layout.
open class ScrollStackView: UIScrollView {
    private let stackView = UIStackView()
    
    // MARK: - Lifecycle
    
    public init(
        insets: UIEdgeInsets = .zero,
        axis: NSLayoutConstraint.Axis = .vertical,
        alignment: UIStackView.Alignment? = nil,
        distribution: UIStackView.Distribution? = nil,
        spacing: CGFloat? = nil
    ) {
        super.init(frame: .zero)
        addSubview(stackView)
        
        stackView.axis = axis
        stackView.alignment ?= alignment
        stackView.distribution ?= distribution
        stackView.spacing ?= spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -insets.right),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -insets.bottom).with {
                $0.priority = UILayoutPriority(rawValue: UILayoutPriority.required.rawValue - 1)
            }
        ])
        
        axis == .vertical
            ? (stackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true)
            : (stackView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Access Rows

extension ScrollStackView {
    
    /// The first row in the stack view.
    ///
    /// This property is nil if there are no rows in the stack view.
    open var firstRow: UIView? {
        (stackView.arrangedSubviews.first as? CellView)?.contentView
    }
    
    /// The last row in the stack view.
    ///
    /// This property is nil if there are no rows in the stack view.
    open var lastRow: UIView? {
        (stackView.arrangedSubviews.last as? CellView)?.contentView
    }
    
    /// Returns an array containing of all the rows in the stack view.
    ///
    /// The rows in the returned array are in the order they appear visually in the stack view.
    open var rows: [UIView] {
        stackView.arrangedSubviews.compactMap { ($0 as? CellView)?.contentView }
    }
    
    /// Returns `true` if the given row is present in the stack view, `false` otherwise.
    open func contains(row: UIView) -> Bool {
        guard let cell = row.superview as? CellView else { return false }
        return stackView.arrangedSubviews.contains(cell)
    }
}

// MARK: - Add / Remove Rows

extension ScrollStackView {
    
    /// Adds a row to the end of the stack view.
    ///
    /// If `animated` is `true`, the insertion is animated.
    open func add(row: UIView, rowInsets: UIEdgeInsets = .zero, animated: Bool = false) {
        insertCell(withContentView: row, atIndex: stackView.arrangedSubviews.count, rowInsets: rowInsets, animated: animated)
    }
    
    /// Adds multiple rows to the end of the stack view.
    ///
    /// If `animated` is `true`, the insertions are animated.
    open func add(rows: [UIView], rowInsets: UIEdgeInsets = .zero, animated: Bool = false) {
        rows.forEach { add(row: $0, rowInsets: rowInsets, animated: animated) }
    }
    
    /// Adds a row to the beginning of the stack view.
    ///
    /// If `animated` is `true`, the insertion is animated.
    open func prepend(row: UIView, rowInsets: UIEdgeInsets = .zero, animated: Bool = false) {
        insertCell(withContentView: row, atIndex: 0, rowInsets: rowInsets, animated: animated)
    }
    
    /// Adds multiple rows to the beginning of the stack view.
    ///
    /// If `animated` is `true`, the insertions are animated.
    open func prepend(rows: [UIView], rowInsets: UIEdgeInsets = .zero, animated: Bool = false) {
        rows.reversed().forEach { prepend(row: $0, rowInsets: rowInsets, animated: animated) }
    }
    
    /// Inserts a row above the specified row in the stack view.
    ///
    /// If `animated` is `true`, the insertion is animated.
    open func insert(row: UIView, before beforeRow: UIView, rowInsets: UIEdgeInsets = .zero, animated: Bool = false) {
        guard let cell = beforeRow.superview as? CellView,
            let index = stackView.arrangedSubviews.firstIndex(of: cell) else {
                return
        }
        
        insertCell(withContentView: row, atIndex: index, rowInsets: rowInsets, animated: animated)
    }
    
    /// Inserts multiple rows above the specified row in the stack view.
    ///
    /// If `animated` is `true`, the insertions are animated.
    open func insert(rows: [UIView], before beforeRow: UIView, rowInsets: UIEdgeInsets = .zero, animated: Bool = false) {
        rows.forEach { insert(row: $0, before: beforeRow, rowInsets: rowInsets, animated: animated) }
    }
    
    /// Inserts a row below the specified row in the stack view.
    ///
    /// If `animated` is `true`, the insertion is animated.
    open func insert(row: UIView, after afterRow: UIView, rowInsets: UIEdgeInsets = .zero, animated: Bool = false) {
        guard let cell = afterRow.superview as? CellView,
            let index = stackView.arrangedSubviews.firstIndex(of: cell) else {
                return
        }
        
        insertCell(withContentView: row, atIndex: index + 1, rowInsets: rowInsets, animated: animated)
    }
    
    /// Inserts multiple rows below the specified row in the stack view.
    ///
    /// If `animated` is `true`, the insertions are animated.
    open func insert(rows: [UIView], after afterRow: UIView, rowInsets: UIEdgeInsets = .zero, animated: Bool = false) {
        _ = rows.reduce(afterRow) { currentAfterRow, row in
            insert(row: row, after: currentAfterRow, rowInsets: rowInsets, animated: animated)
            return row
        }
    }
    
    /// Removes the given row from the stack view.
    ///
    /// If `animated` is `true`, the removal is animated.
    open func remove(row: UIView, animated: Bool = false) {
        guard let cell = row.superview as? CellView else { return }
        removeCell(cell, animated: animated)
    }
    
    /// Removes the given rows from the stack view.
    ///
    /// If `animated` is `true`, the removals are animated.
    open func remove(rows: [UIView], animated: Bool = false) {
        rows.forEach { remove(row: $0, animated: animated) }
    }
    
    /// Removes all the rows in the stack view.
    ///
    /// If `animated` is `true`, the removals are animated.
    open func removeAllRows(animated: Bool = false) {
        stackView.arrangedSubviews.forEach { view in
            guard let cell = view as? CellView else { return }
            remove(row: cell.contentView, animated: animated)
        }
    }
}

private extension ScrollStackView {
    
    func insertCell(withContentView contentView: UIView, atIndex index: Int, rowInsets: UIEdgeInsets, animated: Bool) {
        let cellToRemove = contains(row: contentView) ? contentView.superview : nil
        
        let cell = CellView(contentView: contentView).with {
            $0.layoutMargins = rowInsets
        }
        
        stackView.insertArrangedSubview(cell, at: index)
        
        if let cellToRemove = cellToRemove as? CellView {
            removeCell(cellToRemove, animated: false)
        }
        
        if animated {
            cell.alpha = 0
            layoutIfNeeded()
            UIView.animate(withDuration: 0.3) {
                cell.alpha = 1
            }
        }
    }
    
    func removeCell(_ cell: CellView, animated: Bool) {
        guard animated else {
            cell.removeFromSuperview()
            return
        }
        
        UIView.animate(
            withDuration: 0.3,
            animations: { cell.isHidden = true },
            completion: { _ in cell.removeFromSuperview() }
        )
    }
}

// MARK: - Show / Hide Rows

extension ScrollStackView {
    
    /// Shows the given row, making it visible.
    ///
    /// If `animated` is `true`, the change is animated.
    open func show(row: UIView, animated: Bool = false) {
        setRowHidden(row, isHidden: false, animated: animated)
    }
    
    /// Shows the given rows, making them visible.
    ///
    /// If `animated` is `true`, the changes are animated.
    open func show(rows: [UIView], animated: Bool = false) {
        rows.forEach { show(row: $0, animated: animated) }
    }
    
    /// Hides the given row, making it invisible.
    ///
    /// If `animated` is `true`, the change is animated.
    open func hide(row: UIView, animated: Bool = false) {
        setRowHidden(row, isHidden: true, animated: animated)
    }
    
    /// Hides the given rows, making them invisible.
    ///
    /// If `animated` is `true`, the changes are animated.
    open func hide(rows: [UIView], animated: Bool = false) {
        rows.forEach { hide(row: $0, animated: animated) }
    }
    
    /// Hides the given row if `isHidden` is `true`, or shows the given row if `isHidden` is `false`.
    ///
    /// If `animated` is `true`, the change is animated.
    open func setRowHidden(_ row: UIView, isHidden: Bool, animated: Bool = false) {
        guard let cell = row.superview as? CellView, cell.isHidden != isHidden else { return }
        
        guard animated else {
            cell.isHidden = isHidden
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            cell.isHidden = isHidden
            cell.layoutIfNeeded()
        }
    }
    
    /// Hides the given rows if `isHidden` is `true`, or shows the given rows if `isHidden` is `false`.
    ///
    /// If `animated` is `true`, the change are animated.
    open func setRowsHidden(_ rows: [UIView], isHidden: Bool, animated: Bool = false) {
        rows.forEach { setRowHidden($0, isHidden: isHidden, animated: animated) }
    }
    
    /// Returns `true` if the given row is hidden, `false` otherwise.
    open func isRowHidden(_ row: UIView) -> Bool {
        (row.superview as? CellView)?.isHidden ?? false
    }
}

// MARK: - Scrollview

extension ScrollStackView {
    
    /// Scrolls the given row onto screen so that it is fully visible.
    ///
    /// If `animated` is `true`, the scroll is animated. If the row is already fully visible, this method does nothing.
    open func scrollRowToVisible(_ row: UIView, animated: Bool = true) {
        guard let superview = row.superview else { return }
        scrollRectToVisible(convert(row.frame, from: superview), animated: animated)
    }
}

// MARK: - Types

extension ScrollStackView {
    
    /// A view that wraps every row in a stack view.
    open class CellView: UIView {
        public let contentView: UIView
        
        public init(contentView: UIView) {
            self.contentView = contentView
            super.init(frame: .zero)
            prepare()
        }
        
        public required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func prepare() {
            insetsLayoutMarginsFromSafeArea = false
            clipsToBounds = true
            backgroundColor = .clear
            addSubview(contentView)
            contentView.edges(to: self)
        }
    }
}
