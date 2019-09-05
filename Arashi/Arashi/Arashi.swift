//
//  Arashi.swift
//  Arashi
//
//  Created by Yoshikazu on 2019/09/05.
//  Copyright © 2019 kazy. All rights reserved.
//

import Foundation
import UIKit

public protocol ArashiDelegate: class {
    func arashiKeyboardWillShow(notification: Notification, diff: CGFloat?)
    func arashiKeyboardDidShow(notification: Notification, diff: CGFloat?)
    func arashiKeyboardWillHide(notification: Notification)
    func arashiKeyboardDidHide(notification: Notification)
}

public class Arashi: NSObject {
    
    private(set) public var parentView: UIView
    private(set) public var targetView: UIView
    public var delegate: ArashiDelegate?
    
    public init(parentView: UIView, targetView: UIView, delegate: ArashiDelegate? = nil) {
        self.parentView = parentView
        self.targetView = targetView
        self.delegate = delegate
        super.init()
        commonInit()
    }
    
    public func setTarget(_ targetView: UIView) {
        self.targetView = targetView
    }
    
    public func reSubscribe() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidShow(_:)),
            name: UIResponder.keyboardDidShowNotification,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidHide(_:)),
            name: UIResponder.keyboardDidHideNotification,
            object: nil)
    }
    
    public func dispose() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func commonInit() {
        reSubscribe()
    }
    
    private func getDiff(_ keyboardFrame: CGRect) -> CGFloat? {
        let convertTargetFrame = parentView.convert(targetView.bounds, from: targetView)
        let targetYAndHeight = convertTargetFrame.origin.y + convertTargetFrame.height
        
        var diff: CGFloat?
        if targetYAndHeight > keyboardFrame.origin.y {
            diff = targetYAndHeight - keyboardFrame.origin.y
        }
        return diff
    }
    
    /// キーボード表示時。
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        delegate?.arashiKeyboardWillShow(notification: notification, diff: getDiff(keyboardFrame))
    }
    
    /// キーボード非表示表示時。
    @objc private func keyboardWillHide(_ notification: Notification) {
        delegate?.arashiKeyboardWillHide(notification: notification)
    }
    
    /// キーボード表示時。
    @objc private func keyboardDidShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        delegate?.arashiKeyboardDidShow(notification: notification, diff: getDiff(keyboardFrame))
    }
    
    /// キーボード非表示表示時。
    @objc private func keyboardDidHide(_ notification: Notification) {
        delegate?.arashiKeyboardDidHide(notification: notification)
    }
    
    
}
