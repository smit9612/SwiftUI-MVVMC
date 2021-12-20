//
//  UIKitTextField.swift
//  WeatherAppDemo
//
//  Created by smiteshP on 17/12/21.
//

import SwiftUI

struct UIKitTextField: UIViewRepresentable {
    @Binding var searchText: String
    var isFirstResponder: Bool = false
    private let wrappableTextField = WrappableTextField()
    var tag: Int = 0
    var placeholder: String? = ""
    var autocorrectionType: UITextAutocorrectionType = .no
    var returnType: UIReturnKeyType = .default
    var onChangeHandler: ((String) -> Void)?
    var onCommitHandler: (() -> Void)?
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        var didBecomeFirstResponder = false

        init(text: Binding<String>) {
            _text = text
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
    
    func makeCoordinator() -> UIKitTextField.Coordinator {
        return Coordinator(text: $searchText)
    }

    func makeUIView(context _: UIViewRepresentableContext<UIKitTextField>) -> WrappableTextField {
        wrappableTextField.tag = tag
        wrappableTextField.tintColor = .black
        wrappableTextField.delegate = wrappableTextField
        wrappableTextField.placeholder = placeholder
        wrappableTextField.onCommitHandler = onCommitHandler
        wrappableTextField.textFieldChangedHandler = onChangeHandler
        wrappableTextField.returnKeyType = returnType
        wrappableTextField.autocorrectionType = autocorrectionType
        return wrappableTextField
    }

    func updateUIView(_ uiView: WrappableTextField, context: UIViewRepresentableContext<UIKitTextField>) {
        uiView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        uiView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        uiView.text = searchText
        
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }

    class WrappableTextField: UITextField, UITextFieldDelegate {
        var textFieldChangedHandler: ((String) -> Void)?
        var onCommitHandler: (() -> Void)?

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            if let nextField = textField.superview?.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                nextField.becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
            }
            return false
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if let currentValue = textField.text as NSString? {
                let proposedValue = currentValue.replacingCharacters(in: range, with: string)
                textFieldChangedHandler?(proposedValue as String)
            }
            return true
        }

        func textFieldDidEndEditing(_: UITextField) {
            onCommitHandler?()
        }
    }
}

