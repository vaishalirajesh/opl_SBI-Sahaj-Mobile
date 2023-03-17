

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp_text_field/otp_field_style.dart';

import '../utils/helpers/themhelper.dart';

class OTPTextField extends StatefulWidget {
  /// TextField Controller
  final OtpFieldController? controller;

  /// Number of the OTP Fields
  final int length;
  bool isClearOtp;
  /// Total Width of the OTP Text Field
  final double width;

  /// Width of the single OTP Field
  final double fieldWidth;



  /// Callback function, called when pin is completed.
  final ValueChanged<String>? onCompleted;

  //callback function, on pin change
  final ValueChanged<String>? onChanged;


   OTPTextField({
    Key? key,
    this.length = 4,
    this.width = 10,
    this.isClearOtp = false,
    this.controller,
    this.fieldWidth = 30,
    this.onCompleted,
    this.onChanged, required OtpFieldStyle otpFieldStyle, required TextStyle style,
  })  : assert(length > 1),
        super(key: key);

  @override
  _OTPTextFieldState createState() => _OTPTextFieldState();
}

class _OTPTextFieldState extends State<OTPTextField> {
  late List<FocusNode?> _focusNodes;
  late List<TextEditingController?> _textControllers;

  late List<String> _pin;

  @override
  void initState() {
    handleLeyEvent();
    if (widget.controller != null) {
      widget.controller!.setOtpTextFieldState(this);
    }


    _focusNodes = List<FocusNode?>.filled(widget.length, null, growable: false);
    _textControllers = List<TextEditingController?>.filled(widget.length, null,
        growable: false);

    _pin = List.generate(widget.length, (int i) {
      return '';
    });
    super.initState();

  }

  @override
  void didUpdateWidget(covariant OTPTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(/*oldWidget.isClearOtp != widget.isClearOtp && */widget.isClearOtp == true)
    {
      for(var controller in _textControllers)
      {
        controller?.clear();
      }
      _pin = List<String>.filled(widget.length, '');
      setState((){
        widget.isClearOtp = false;
      });
    }
  }
  @override
  void dispose() {
    _textControllers.forEach((controller) => controller?.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.length, (index) {
          return buildTextField(context, index);
        }),
      ),
    );
  }

  /// This function Build and returns individual TextField item.
  ///
  /// * Requires a build context
  /// * Requires Int position of the field
  Widget buildTextField(BuildContext context, int index) {
    FocusNode? focusNode = _focusNodes[index];
    TextEditingController? textEditingController = _textControllers[index];

    // if focus node doesn't exist, create it.
    if (focusNode == null) {
      _focusNodes[index] = FocusNode();
      focusNode = _focusNodes[index];
      focusNode?.addListener((() => handleFocusChange(index)));
    }
    if (textEditingController == null) {
      _textControllers[index] = TextEditingController();
      textEditingController = _textControllers[index];
    }

    final isLast = index == widget.length - 1;

    InputBorder _getBorder() {
      return UnderlineInputBorder(borderSide: BorderSide(width: 2, color: ThemeHelper.getInstance()!.colorScheme.onSurface));
    }



    return Container(
      width: widget.fieldWidth,
      margin: EdgeInsets.only(
        right: isLast ? 0 : 0,
      ),
      child: TextField(
        autofocus: true,
        controller: _textControllers[index],
        keyboardType: TextInputType.phone,
        textAlign: TextAlign.center,
        style: ThemeHelper.getInstance()?.textTheme.bodyText1,
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        focusNode: _focusNodes[index],
        obscureText: false,
        decoration: InputDecoration(
          counterText: "",
          border: _getBorder(),
          focusedBorder: _getBorder(),
          enabledBorder: _getBorder(),
          disabledBorder: _getBorder(),
          errorBorder: _getBorder(),
          focusedErrorBorder: _getBorder(),
          errorText: null,
          errorStyle:  TextStyle(height: 0, fontSize: 0),
        ),
        onChanged: (String str) {
          if (str.length > 1) {
            _handlePaste(str);
            return;
          }
          if(widget.isClearOtp)
          {
            setState(() {
              _pin.forEach((element) {element = '';});
            });
          }
          // Check if the current value at this position is empty
          // If it is move focus to previous text field.
          if (str.isEmpty &&  _focusNodes[index]?.hasFocus == true) {
            if (index == 0) return;
            _focusNodes[index]!.unfocus();
            _focusNodes[index - 1]!.requestFocus();
            widget.onChanged?.call(str);
          }


          // Update the current pin
          setState(() {
            _pin[index] = str;
          });

          // Remove focus
          if (str.isNotEmpty) _focusNodes[index]!.unfocus();
          // Set focus to the next field if available
          if (index + 1 != widget.length && str.isNotEmpty) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);

          }

          String currentPin = _getCurrentPin();

          // if there are no null values that means otp is completed
          // Call the `onCompleted` callback function provided
          if (!_pin.contains(null) && !_pin.contains('') &&
              currentPin.length == widget.length) {
            widget.onCompleted?.call(currentPin);
          }


        },
      ),
    );
  }

  void handleFocusChange(int index) {
    FocusNode? focusNode = _focusNodes[index];
    TextEditingController? controller = _textControllers[index];

    if (focusNode == null || controller == null) return;

    if (focusNode.hasFocus) {
      controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
    }
  }

  void handleLeyEvent()
  {

  }

  String _getCurrentPin() {
    String currentPin = "";
    _pin.forEach((String value) {
      currentPin += value;
    });
    return currentPin;
  }

  void _handlePaste(String str) {
    if (str.length > widget.length) {
      str = str.substring(0, widget.length);
    }

    for (int i = 0; i < str.length; i++) {
      String digit = str.substring(i, i + 1);
      _textControllers[i]!.text = digit;
      _pin[i] = digit;
    }

    FocusScope.of(context).requestFocus(_focusNodes[widget.length - 1]);

    String currentPin = _getCurrentPin();

    // if there are no null values that means otp is completed
    // Call the `onCompleted` callback function provided
    if (!_pin.contains(null) &&
        !_pin.contains('') &&
        currentPin.length == widget.length) {
      widget.onCompleted?.call(currentPin);
    }

  }

  void clearOtp()
  {
    if(widget.isClearOtp)
    {
      setState(() {
        _pin.forEach((element) {element = '';});
        _textControllers.forEach((element) {element?.text = '';});
      });
    }

  }
}

class OtpFieldController {
  late _OTPTextFieldState _otpTextFieldState;

  void setOtpTextFieldState(_OTPTextFieldState state) {
    _otpTextFieldState = state;
  }

  void clear() {
    final textFieldLength = _otpTextFieldState.widget.length;
    _otpTextFieldState._pin = List.generate(textFieldLength, (int i) {
      return '';
    });

    final textControllers = _otpTextFieldState._textControllers;
    textControllers.forEach((textController) {
      if (textController != null) {
        textController.text = '';
      }
    });

    final firstFocusNode = _otpTextFieldState._focusNodes[0];
    if (firstFocusNode != null) {
      firstFocusNode.requestFocus();
    }
  }

  void set(List<String> pin) {
    final textFieldLength = _otpTextFieldState.widget.length;
    if (pin.length < textFieldLength) {
      throw Exception(
          "Pin length must be same as field length. Expected: $textFieldLength, Found ${pin.length}");
    }

    _otpTextFieldState._pin = pin;
    String newPin = '';

    final textControllers = _otpTextFieldState._textControllers;
    for (int i = 0; i < textControllers.length; i++) {
      final textController = textControllers[i];
      final pinValue = pin[i];
      newPin += pinValue;

      if (textController != null) {
        textController.text = pinValue;
      }
    }

    final widget = _otpTextFieldState.widget;


    widget.onCompleted?.call(newPin);
  }

  void setValue(String value, int position) {
    final maxIndex = _otpTextFieldState.widget.length - 1;
    if (position > maxIndex) {
      throw Exception(
          "Provided position is out of bounds for the OtpTextField");
    }

    final textControllers = _otpTextFieldState._textControllers;
    final textController = textControllers[position];
    final currentPin = _otpTextFieldState._pin;

    if (textController != null) {
      textController.text = value;
      currentPin[position] = value;
    }

    String newPin = "";
    currentPin.forEach((item) {
      newPin += item;
    });

    final widget = _otpTextFieldState.widget;

  }

  void setFocus(int position) {
    final maxIndex = _otpTextFieldState.widget.length - 1;
    if (position > maxIndex) {
      throw Exception(
          "Provided position is out of bounds for the OtpTextField");
    }

    final focusNodes = _otpTextFieldState._focusNodes;
    final focusNode = focusNodes[position];

    if (focusNode != null) {
      focusNode.requestFocus();
    }
  }


}