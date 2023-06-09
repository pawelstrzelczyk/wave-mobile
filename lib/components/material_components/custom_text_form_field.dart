import 'package:flutter/cupertino.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class CustomTextFormField extends StatelessWidget {
  final String name;
  final bool enabled;
  final String Function(String?) validator;
  final Function() onTap;
  final FocusNode focusNode;
  final TextEditingController textEditingController;

  const CustomTextFormField(
      {super.key,
      required this.name,
      required this.enabled,
      required this.validator,
      required this.onTap,
      required this.focusNode,
      required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return FormBuilderTextField(name: name);
  }
}
