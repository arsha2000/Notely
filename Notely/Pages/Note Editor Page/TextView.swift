//
//  TextView.swift
//  Notely
//
//  Created by Arsha Hassas on 8/6/19.
//  Copyright © 2019 Olly Taylor. All rights reserved.
//

import UIKit
import SwiftUI

struct TextView: UIViewRepresentable {
    
    typealias UIViewType = UITextView
    
    @Binding var text: String
    
    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UITextView {
        let textView = UITextView()
        context.coordinator.textView = textView
        
        textView.backgroundColor = .clear
        textView.alwaysBounceVertical = true
        textView.showsVerticalScrollIndicator = false
        textView.delegate = context.coordinator
        textView.usesStandardTextScaling = true
        textView.font = UIFont.preferredFont(forTextStyle: .body).withSize(16)
        textView.textContainerInset = .init(top: 8,
                                            left: 12,
                                            bottom: 8,
                                            right: 12)
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<TextView>) {
        uiView.text = text
        
    }
    
    func makeCoordinator() -> TextView.Coordinator {
        return Coordinator(parent: self)
    }
    
    final class Coordinator: NSObject, UITextViewDelegate {
        
        let parent: TextView
        weak var textView: UITextView?
        
        init(parent: TextView) {
            self.parent = parent
            super.init()
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared(_:)), name: UIWindow.keyboardWillHideNotification, object: nil)
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
        }
        
        @objc func keyboardAppeared(_ notification: Notification) {
            let nsValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
            let frame = nsValue as! CGRect
            
            self.textView?.contentInset.bottom = frame.height
            
        }
        
        @objc func keyboardDisappeared(_ notification: Notification) {
            self.textView?.contentInset.bottom = 0
        }
        
    }
}
