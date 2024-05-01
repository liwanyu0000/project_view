// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../models/user.dart';
// import '../issue_details/components/style_text.dart';
// import 'config/config.dart';

// class CustomCircleAvatar extends StatelessWidget {
//   const CustomCircleAvatar({
//     super.key,
//     this.text = ' ',
//     this.isAvatar = false,
//     this.radius = 1,
//     this.backgroundColor,
//     this.fontSize,
//     this.tooltip,
//     this.avatarImageUrl,
//     this.padding,
//     this.onTap,
//     this.user,
//     this.cursor = SystemMouseCursors.click,
//   });

//   final bool isAvatar;
//   final double radius;
//   final Color? backgroundColor;
//   final String text;
//   final double? fontSize;
//   final String? tooltip;
//   final String? avatarImageUrl;
//   final EdgeInsets? padding;
//   final UserBaseModel? user;
//   final void Function()? onTap;
//   final MouseCursor cursor;

//   factory CustomCircleAvatar.avatar(
//           {double? radius,
//           Color? backgroundColor,
//           double? fontSize,
//           required UserBaseModel user,
//           void Function()? onTap}) =>
//       CustomCircleAvatar(
//         text: user.name,
//         user: user,
//         isAvatar: true,
//         tooltip:
//             '${user.organization == null ? '' : '${user.organization}'} ${user.department == null || user.department == '/' ? '' : '${user.department}'}',
//         avatarImageUrl: user.avatar,
//         radius: radius ?? (iconSizeConfig.assistIconSize / 2),
//         fontSize: fontSize,
//         backgroundColor: backgroundColor,
//         onTap: onTap,
//       );

//   @override
//   Widget build(BuildContext context) {
//     return CustomToolTip(
//       text: isAvatar ? '' : tooltip ?? text,
//       // padding: const EdgeInsets.fromLTRB(3, 1, 3, 3),
//       child: MouseRegion(
//         cursor: MaterialStateMouseCursor.clickable,
//         child: GestureDetector(
//           onTap: onTap,
//           child:CustomToolTip(
//       padding: const EdgeInsets.only(left: 10, right: 20, top: 5, bottom: 5),
//       toolWidget: isAvatar ? Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           CustomCircleAvatar.avatar(
//             user: user!,
//             radius: iconSizeConfig.smallAvatarIconSize,
//             fontSize: textSizeConfig.contentTextSize,
//           ),
//           const SizedBox(
//             width: 8,
//           ),
//           Flexible(
//               child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               StyleText(user!.name),
//               const SizedBox(
//                 height: 3,
//               ),
//               StyleText(
//                 user!.organization == null && user!.department == null
//                     ? '单位信息未知'
//                     : '${user!.organization == null ? '' : '${user!.organization}'} ${user!.department == null || user!.department == '/' ? '' : '${user!.department}'}',
//                 color: labelColor(context.isDarkMode),
//                 fontSize: textSizeConfig.labelTextSize,
//               )
//             ],
//           ))
//         ],
//       ):null,
//       child: avatarImageUrl != null
//               ? CircleAvatar(
//                   radius: radius,
//                   backgroundImage: NetworkImage(avatarImageUrl!),
//                 )
//               : CircleAvatar(
//                   radius: radius,
//                   backgroundColor: backgroundColor ?? getAvatarColor(text),
//                   child: Padding(
//                     padding: padding ??
//                         const EdgeInsets.only(
//                             left: .5),
//                     child: Center(
//                       child: Text(
//                         text
//                             .split(' ')
//                             .where((e) => e.isNotEmpty)
//                             .take(2)
//                             .map((e) => e[0].toUpperCase())
//                             .join(),
//                         style: TextStyle(
//                             fontSize: fontSize ?? textSizeConfig.assistTextSize),
//                       ),
//                     ),
//                   ),
//                 ),
//         ),
//       ),
//     ));
//   }
// }
