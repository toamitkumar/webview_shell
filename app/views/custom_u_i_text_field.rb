class CustomUiTextField < UITextField

  def self.create(frame, placeholder, tag)
    textField = self.alloc.initWithFrame(frame)
    textField.placeholder = placeholder
    textField.layer.cornerRadius = 8
    textField.backgroundColor = UIColor.whiteColor
    textField.tag = tag
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter
    textField.textColor = UIColor.blackColor
    textField.clearButtonMode = UITextFieldViewModeWhileEditing
    textField.borderStyle = UITextBorderStyleRoundedRect
    textField.autocorrectionType = UITextAutocorrectionTypeNo
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone
    textField.keyboardAppearance = UIKeyboardAppearanceAlert

    textField
  end
end