//
//  AppRoutable.swift
//  ZamzamKit iOS
//
//  Created by Basem Emara on 2018-02-04.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit
#elseif os(watchOS)
import WatchKit
#endif

public protocol AppRoutable {
    #if os(iOS)
    var viewController: UIViewController? { get set }
    #elseif os(watchOS)
    var viewController: WKInterfaceController? { get set }
    #endif
    
    func dismiss(animated: Bool, completion: (() -> Void)?)
    func dismissOrPop(animated: Bool, completion: (() -> Void)?)
    func close(animated: Bool, completion: (() -> Void)?)
}
