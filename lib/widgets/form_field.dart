// import 'package:flutter/material.dart';
// import 'package:go_perak/constants/color.dart';

// class AppFormField extends StatelessWidget {
//   final IconData icon;
//   final String labelText;
//   final TextInputType keyboardType;
//   final int? maxLines;
//   final Color focusedBorderColor;
//   final Color errorBorderColor;
//   final bool invisible;
//   final FormFieldValidator<String>? validator;
//   final AutovalidateMode autovalidateMode;
//   final TextEditingController controller;
//   final bool enabled;

//   const AppFormField(
//       {super.key,
//       required this.icon,
//       required this.labelText,
//       this.keyboardType = TextInputType.text,
//       this.maxLines = 1,
//       this.invisible = false,
//       this.focusedBorderColor = AppColor.mainBlack,
//       this.errorBorderColor = AppColor.errorColor,
//       this.validator,
//       this.autovalidateMode = AutovalidateMode.onUserInteraction,
//       required this.controller,
//       this.enabled = true});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6.0),
//       child: TextFormField(
//         controller: controller,
//         enabled: enabled,
//         obscureText: invisible,
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         decoration: InputDecoration(
//           prefixIcon: Icon(
//             icon,
//             color: AppColor.mainBlack,
//           ),
//           labelText: labelText,
//           labelStyle: const TextStyle(color: Color.fromARGB(255, 66, 66, 66)),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: focusedBorderColor, width: 1.2),
//           ),
//           focusedErrorBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: errorBorderColor, width: 1.2),
//           ),
//           errorBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: errorBorderColor, width: 1.2),
//           ),
//         ),
//         validator: validator,
//         autovalidateMode: autovalidateMode,
//         style: TextStyle(
//           color: enabled
//               ? AppColor.mainBlack
//               : AppColor.mainBlack, // Change text color
//         ),
//       ),
//     );
//   }
// }


