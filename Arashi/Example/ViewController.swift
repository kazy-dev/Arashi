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
    
    private var arashi: Arashi?
    
    @IBOutlet weak var innerTextView: UITextView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var innerTextViewTop: NSLayoutConstraint!
    @IBOutlet weak var textViewHorizontal: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        arashi = Arashi(parentView: view, targetView: innerTextView, delegate: self)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped(_:)))
        self.view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    /// 画面タップ時。
    @objc func tableTapped(_ recognizer: UITapGestureRecognizer) {
        if textView.isFirstResponder {
            textView.resignFirstResponder()
        } else if innerTextView.isFirstResponder {
            innerTextView.resignFirstResponder()
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

extension ViewController: ArashiDelegate {
    func arashiKeyboardWillShow(notification: Notification, diff: CGFloat?) {
        print("😄 \(#function)")
        if let diff = diff {
            innerTextViewTop.constant -= diff
//            textViewHorizontal.constant -= diff
            UIView.animate(withDuration: 1, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func arashiKeyboardDidShow(notification: Notification, diff: CGFloat?) {
        
    }
    
    func arashiKeyboardWillHide(notification: Notification) {
        print("😄 \(#function)")
//        textViewHorizontal.constant = 0
        innerTextViewTop.constant = 8
        UIView.animate(withDuration: 1, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    func arashiKeyboardDidHide(notification: Notification) {
        
    }
}
