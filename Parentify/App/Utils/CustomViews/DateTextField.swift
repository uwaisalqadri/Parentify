//
//  DateTextField.swift
//  Celengan
//
//  Created by Uwais Alqadri on 1/21/22.
//

import SwiftUI

struct DateTextField: View {

  var placeholder: String = ""
  @Binding var date: Date
  var image: UIImage?

  var clickHandler: (() -> Void)? = nil

  var body: some View {
    HStack {
      Button(action: {
        clickHandler?()
      }) {
        Image(uiImage: image!)
          .resizable()
          .foregroundColor(.black)
          .frame(width: 25, height: 25, alignment: .center)
          .padding()
          .padding(.horizontal, 5)
          .overlay(
            RoundedRectangle(cornerRadius: 0)
              .stroke(Color.gray.opacity(0.3), lineWidth: 1)
              .cornerRadius(13, corners: [.bottomLeft, .topLeft])
          )
      }

      UIDateTextField(date: $date, didChange: { _ in})
        .font(.systemFont(ofSize: 16, weight: .semibold))
        .foregroundColor(.black)
        .padding(.leading, 10)
        .autocapitalization(.none)
        .disableAutocorrection(true)
    }
    .cardShadow(cornerRadius: 13)
  }
}

struct UIDateTextField: UIViewRepresentable {

  @Binding var date: Date
  var didChange: ((Date) -> Void)?

  private var minimumDate: Date? = Date()
  private var maximumDate: Date? = nil
  private var placeholder: String? = "Select a date"
  private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "dd MMMM yyyy"
    return formatter
  }()

  private var font: UIFont?
  private var foregroundColor: UIColor?
  private var accentColor: UIColor?
  private var textAlignment: NSTextAlignment?
  private var contentType: UITextContentType?

  private var autocorrection: UITextAutocorrectionType = .default
  private var autocapitalization: UITextAutocapitalizationType = .sentences
  private var keyboardType: UIKeyboardType = .default
  private var returnKeyType: UIReturnKeyType = .default

  private var isSecure: Bool = false
  private var isUserInteractionEnabled: Bool = true
  private var clearsOnBeginEditing: Bool = false

  @Environment(\.layoutDirection) private var layoutDirection: LayoutDirection

  init(date: Binding<Date>, didChange: ((Date) -> Void)? = nil) {
    self._date = date
    self.didChange = didChange
  }

  func makeUIView(context: Context) -> UITextField {
    let textField = UITextField()

    textField.delegate = context.coordinator

    textField.text = dateFormatter.string(from: date)
    textField.font = font
    textField.textColor = foregroundColor
    if let textAlignment = textAlignment {
      textField.textAlignment = textAlignment
    }
    if let contentType = contentType {
      textField.textContentType = contentType
    }
    if let accentColor = accentColor {
      textField.tintColor = accentColor
    }
    textField.autocorrectionType = autocorrection
    textField.autocapitalizationType = autocapitalization
    textField.keyboardType = keyboardType
    textField.returnKeyType = returnKeyType

    textField.clearsOnBeginEditing = clearsOnBeginEditing
    textField.isSecureTextEntry = isSecure
    textField.isUserInteractionEnabled = isUserInteractionEnabled

    textField.setContentHuggingPriority(.defaultHigh, for: .vertical)
    textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

    let datePickerView = UIDatePicker()
    datePickerView.datePickerMode = .date
    datePickerView.maximumDate = minimumDate
    datePickerView.maximumDate = maximumDate
    textField.inputView = datePickerView
    datePickerView.addTarget(context.coordinator, action: #selector(Coordinator.handleDatePicker(sender:)), for: .valueChanged)

    if #available(iOS 14, *) {
      datePickerView.preferredDatePickerStyle = .wheels
    }

    addDoneButtonToKeyboard(textField)
    return textField
  }

  func updateUIView(_ uiView: UITextField, context: Context) {
    uiView.text = dateFormatter.string(from: date)
  }

  private func addDoneButtonToKeyboard(_ view: UITextField) {
    let doneToolbar: UIToolbar = UIToolbar()
    doneToolbar.barStyle = .default
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: view, action: #selector(UITextField.resignFirstResponder))
    done.setTitleTextAttributes([NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)], for: .normal)

    var items = [UIBarButtonItem]()
    items.append(flexSpace)
    items.append(done)

    doneToolbar.items = items
    doneToolbar.sizeToFit()

    view.inputAccessoryView = doneToolbar
  }

  func makeCoordinator() -> Coordinator {
    return Coordinator(date: $date, didChange: didChange)
  }

  final class Coordinator: NSObject, UITextFieldDelegate {
    @Binding var date: Date
    var didChange: ((Date) -> Void)?

    init(date: Binding<Date>, didChange: ((Date) -> Void)?) {
      self._date = date
      self.didChange = didChange
    }

    @objc func handleDatePicker(sender: UIDatePicker) {
      date = sender.date
      didChange?(date)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      return false
    }
  }
}


extension UIDateTextField {
  func dateFormatter(_ formatter: DateFormatter) -> some View {
    var view = self
    view.dateFormatter = formatter
    return view
  }

  func font(_ font: UIFont?) -> some View {
    var view = self
    view.font = font
    return view
  }
}
