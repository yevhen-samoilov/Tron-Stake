// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:tron_stake/templates/default_templates.dart';
// import 'package:tron_stake/themes/theme_colors.dart';
// import 'package:tron_stake/themes/themes_fonts.dart';
// import 'package:unicons/unicons.dart';

// class MenuTemplateScreen extends StatelessWidget {
//   const MenuTemplateScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTemplates(
//       isScroll: false,
//       body: Column(
//         children: [
//           Row(
//             children: [
//               Container(
//                 height: 40,
//                 margin: EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: ThemesColors.primary.withOpacity(0.1),
//                 ),
//                 child: Row(
//                   children: [
//                     Container(
//                       width: 40,
//                       height: double.infinity,
//                       decoration: BoxDecoration(
//                         border: Border(
//                             right: BorderSide(
//                               width: 3,
//                               color: ThemesColors.black,
//                             ),
//                             left: BorderSide.none),
//                         borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10),
//                             bottomLeft: Radius.circular(10)),
//                         color: ThemesColors.primary.withOpacity(0.1),
//                       ),
//                       child: Icon(
//                         UniconsLine.wallet,
//                         color: ThemesColors.black,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                       child: Text(
//                         'TRX 0.000',
//                         style: ThemesFonts.smallBold(),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Spacer(),
//               Container(
//                 height: 40,
//                 margin: EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   color: ThemesColors.primary.withOpacity(0.1),
//                 ),
//                 child: Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                       child: Text(
//                         'TRX 0.000',
//                         style: ThemesFonts.smallBold(),
//                       ),
//                     ),
//                     Container(
//                       width: 40,
//                       height: double.infinity,
//                       decoration: BoxDecoration(
//                         border: Border(
//                             left: BorderSide(
//                               width: 3,
//                               color: ThemesColors.black,
//                             ),
//                             right: BorderSide.none),
//                         borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(10),
//                             bottomRight: Radius.circular(10)),
//                         color: ThemesColors.primary.withOpacity(0.1),
//                       ),
//                       child: Icon(
//                         UniconsLine.coins,
//                         color: ThemesColors.black,
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
