//
//  ViewController.swift
//  Example
//
//  Created by Yoshikazu on 2019/09/05.
//  Copyright © 2019 kazy. All rights reserved.
//

import UIKit
import Arashi

class ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var textViewHorizontal: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        TestFunc.testLog()
        
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped(_:)))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
    }

    /// キーボード表示時。
    @objc func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        let noteViewYAndHeight = textView.frame.origin.y + textView.frame.height
        if noteViewYAndHeight > keyboardFrame.origin.y {
            print("\(noteViewYAndHeight - (keyboardFrame.origin.y - 20.0))")
            textViewHorizontal.constant -= noteViewYAndHeight - (keyboardFrame.origin.y - 20.0)
        }
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    /// キーボード非表示表示時。
    @objc func keyboardWillHide(_ notification: Notification) {
        print("😄閉じた")
        textViewHorizontal.constant = 0
//        UIView.animate(withDuration: 0.1, animations: {
//            self.view.layoutIfNeeded()
//        })
    }
    
    /// 画面タップ時。
    @objc func tableTapped(_ recognizer: UITapGestureRecognizer) {
        if textView.isFirstResponder {
            //キーボードを閉じる
            textView.resignFirstResponder()
        }
    }
}

extension ViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let isValid = touch.view?.isDescendant(of: textView) else {
            return true
        }
        return !isValid
    }
}
