// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_quill/flutter_quill.dart';
// import 'package:flutter_quill_extensions/embeds/builders.dart';
// import 'package:get/get.dart';

// import '../../models/issue.dart';
// import '../../utils/utils.dart';
// import 'config/config.dart';
// import 'customize_widget.dart';
// import 'issue/issue_label.dart';
// import 'operate_botton.dart';
// import '../issue_details/components/custom_quill_edit.dart';
// import '../issue_details/components/custom_tool_tip.dart';

// class OperateModel {
//   final String tooltip;
//   final IconData icon;
//   final void Function() onTap;
//   const OperateModel({
//     required this.tooltip,
//     required this.icon,
//     required this.onTap,
//   });
// }

// abstract class EditController {
//   List<IssueTagModel>? tags;
//   EditController({this.tags});
//   String get content;
//   set content(String text);
//   get controller;
//   void clear();
// }

// class EditTextController extends EditController {
//   final TextEditingController _controller;
//   EditTextController(this._controller, {super.tags});

//   @override
//   String get content => _controller.text;
//   @override
//   set content(String text) => _controller.text = text;
//   @override
//   get controller => _controller;
//   @override
//   void clear() => _controller.clear();
// }

// class EditQuillController extends EditController {
//   final QuillController _controller;
//   EditQuillController(this._controller, {super.tags});

//   @override
//   String get content => jsonEncode(_controller.document.toDelta().toJson());
//   @override
//   set content(String text) => _controller.document = text.isEmpty
//       ? (Document()..insert(0, ''))
//       : Document.fromJson(jsonDecode(text));
//   @override
//   get controller => _controller;
//   @override
//   void clear() => _controller.clear();
// }

// List<Widget> defaultActions({
//   // 控制器
//   required EditController controller,
//   // 操作
//   required void Function(String content) operate,
//   // 只读状态切换
//   required void Function() swap,
//   // 最开始内容
//   required String content,
// }) =>
//     [
//       creatCancelButton(() {
//         controller.content = content;
//         swap();
//       }),
//       const SizedBox(width: 10),
//       creatOkButton(() {
//         operate(controller.content);
//         swap();
//       }),
//     ];

// List<Widget> sendActions({
//   // 控制器
//   required EditController controller,
//   // 操作
//   required void Function(String content) operate,
//   // 只读状态切换
//   required void Function() swap,
//   // 最开始内容
//   required String content,
// }) =>
//     [
//       Builder(builder: (context) {
//         return CustomizeWidget(
//           label: "发送",
//           onTap: () {
//             operate(controller.content);
// //controller.clear();
//           },
//           config: CustomizeWidgetConfig(
//             width: 52,
//             height: 24,
//             backgroundColor: borderColor(context.isDarkMode).withOpacity(.5),
//             hoverBackgroundColor:
//                 borderColor(context.isDarkMode).withOpacity(.7),
//             primaryColor: context.isDarkMode
//                 ? const Color.fromARGB(255, 126, 134, 243)
//                 : Theme.of(context).colorScheme.primary,
//           ),
//           // haveBorder: true,
//         );
//       }),
//     ];
// List<Widget> noneActions({
//   // 控制器
//   required EditController controller,
//   // 操作
//   required void Function(String content) operate,
//   // 只读状态切换
//   required void Function() swap,
//   // 最开始内容
//   required String content,
// }) =>
//     [];

// class EditWidget extends StatefulWidget {
//   final String content;
//   final String? placeHolder;
//   final bool isQuillEdit;
//   final bool readOnly;
//   final bool isShowOperate;
//   final bool isKeepShowOperate;
//   final bool isShowEdit;
//   final bool isShowTools;
//   final Color? toolsBackgroundColor;
//   final FocusNode? focusNode;
//   final List<Widget> Function({
//     required EditController controller,
//     required void Function(String content) operate,
//     required void Function() swap,
//     required String content,
//   })? actions;
//   final List<OperateModel> operates;
//   final List<Widget> operatesWidget;
//   final List<Widget> tools;
//   final List<Widget> middleWidgets;
//   final EditController? controller;
//   final void Function(String content)? save;
//   final double? minHeight;
//   final double? maxHeight;
//   final double? contentMaxHeight;
//   final double? contentMinHeight;
//   final bool flexible;
//   final bool havaBoder;
//   final bool havaBoxShadow;
//   final BuildContext? parentContext;
//   final EdgeInsets? contentPadding;
//   final String Function(int, String)? getAttachment;
//   final void Function(String path, String uuid,
//       {void Function(int received, int total)? process})? uploadResources;
//   final Future<dynamic> Function(ResourceType type, String src,
//       {int? commentId})? downloadResources;
//   final Future<String> Function(String url)? getReName;
//   final void Function()? onReadOnly;
//   final void Function()? onEdit;

//   const EditWidget({
//     this.content = "",
//     this.placeHolder,
//     this.isQuillEdit = false,
//     this.readOnly = true,
//     this.isShowOperate = true,
//     this.isKeepShowOperate = false,
//     this.isShowEdit = false,
//     this.isShowTools = true,
//     this.toolsBackgroundColor,
//     this.focusNode,
//     this.actions,
//     this.operates = const [],
//     this.operatesWidget = const [],
//     this.tools = const [],
//     this.middleWidgets = const [],
//     this.controller,
//     this.save,
//     super.key,
//     this.minHeight,
//     this.maxHeight,
//     this.contentMaxHeight,
//     this.contentMinHeight,
//     this.flexible = false,
//     this.havaBoder = true,
//     this.havaBoxShadow = true,
//     this.parentContext,
//     this.contentPadding,
//     this.getAttachment,
//     this.downloadResources,
//     this.uploadResources,
//     this.getReName,
//     this.onReadOnly,
//     this.onEdit,
//   });

//   @override
//   State<EditWidget> createState() => _EditWidgetState();
// }

// class _EditWidgetState extends State<EditWidget> {
//   late EditController controller;
//   late final StreamController hoverController;
//   List<OperateModel> operate = [];
//   List<Widget> tools = [];

//   late StreamController actionController;

//   bool beforeContentEmpty = true;

//   @override
//   void initState() {
//     super.initState();
//     hoverController = StreamController<bool>.broadcast();
//     actionController = StreamController<bool>.broadcast();

//     if (Adaptive.isMobile || !widget.isShowOperate || !widget.isShowEdit) {
//       operate = [];
//     } else {
//       operate.add(OperateModel(
//           tooltip: "edit".tr,
//           icon: Icons.edit_outlined,
//           onTap: () => widget.onEdit?.call()));
//       operate.addAll(widget.operates);
//     }

//     controller = widget.controller ??
//         (widget.isQuillEdit
//             ? EditQuillController(() {
//                 try {
//                   return QuillController(
//                     document: Document.fromJson(jsonDecode(widget.content)),
//                     selection: const TextSelection.collapsed(offset: 0),
//                   );
//                 } catch (error) {
//                   return QuillController(
//                       document: Document()..insert(0, ''),
//                       selection: const TextSelection.collapsed(offset: 0));
//                 }
//               }(), tags: [])
//             : EditTextController(
//                 TextEditingController(text: widget.content),
//               ));
//     tools = widget.tools;

//     if (widget.isQuillEdit) {
//       controller.controller.addListener(() {
//         bool nowContentEmpty = controller.controller.document
//             .toPlainText()
//             .trim()
//             .toString()
//             .isEmpty;
//         if (nowContentEmpty != beforeContentEmpty) {
//           actionController.add(true);
//         }
//         beforeContentEmpty = nowContentEmpty;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return KeyboardListener(
//         focusNode: FocusNode(),
//         onKeyEvent: (KeyEvent event) {
//           if (event is KeyUpEvent && !widget.readOnly) {
//             if (event.logicalKey == LogicalKeyboardKey.escape) {
//               widget.onReadOnly?.call();
//             }
//           }
//         },
//         child: GestureDetector(
//           child: Container(
//               constraints: BoxConstraints(
//                 minHeight: widget.minHeight ?? 0,
//                 maxHeight: widget.maxHeight ?? double.infinity,
//               ),
//               decoration: widget.readOnly
//                   ? null
//                   : BoxDecoration(
//                       boxShadow: widget.havaBoxShadow
//                           ? boxShadowConfig(
//                               offset: const Offset(0, 0),
//                               num: 15,
//                               a: 1,
//                               color: context.isDarkMode
//                                   ? Colors.black
//                                   : const Color.fromARGB(255, 204, 204, 204))
//                           : null,
//                       color: context.isDarkMode
//                           ? const Color(0xff20212e)
//                           : Theme.of(context).colorScheme.background,
//                       border: widget.havaBoder
//                           ? Border.all(
//                               width: 1, color: borderColor(context.isDarkMode))
//                           : null,
//                       borderRadius: BorderRadius.circular(3),
//                     ),
//               child: MouseRegion(
//                 onEnter: (event) => hoverController.add(widget.readOnly),
//                 onExit: (event) => hoverController.add(false),
//                 child: Stack(
//                   children: [
//                     const SizedBox(width: double.infinity),
//                     Padding(
//                         padding: widget.readOnly
//                             ? const EdgeInsets.all(0)
//                             : const EdgeInsets.only(bottom: 10),
//                         child: Column(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             widget.readOnly || widget.isQuillEdit
//                                 ? const SizedBox()
//                                 : Row(
//                                     mainAxisAlignment: MainAxisAlignment.end,
//                                     children: tools),
//                             widget.isQuillEdit
//                                 ? Flexible(
//                                     child: LayoutBuilder(
//                                       builder: (context, constraints) =>
//                                           CustomQuillEdit(
//                                         controller: controller.controller,
//                                         readOnly: widget.readOnly,
//                                         flexible: widget.flexible,
//                                         minHeight: widget.contentMinHeight ??
//                                             constraints.maxHeight,
//                                         maxHeight: widget.contentMaxHeight ??
//                                             constraints.maxHeight,
//                                         placeHolder: widget.placeHolder,
//                                         prefixWidgets: tools,
//                                         isShowTools: widget.isShowTools,
//                                         toolsBackgroundColor:
//                                             widget.toolsBackgroundColor,
//                                         parentContext: widget.parentContext,
//                                         focusNode: widget.focusNode,
//                                         middleWidgets: widget.middleWidgets,
//                                         contentPadding: widget.contentPadding ??
//                                             (widget.readOnly
//                                                 ? const EdgeInsets.all(0)
//                                                 : const EdgeInsets.all(10)),
//                                         getAttachment: widget.getAttachment,
//                                         getReName: widget.getReName,
//                                         uploadResources: widget.uploadResources,
//                                         downloadResources:
//                                             widget.downloadResources,
//                                       ),
//                                     ),
//                                   )
//                                 : (widget.readOnly
//                                     ? StreamBuilder(
//                                         initialData: false,
//                                         stream: hoverController.stream,
//                                         builder: (context, snapshot) => Padding(
//                                             padding: (snapshot.data ||
//                                                     Adaptive.isMobile)
//                                                 ? EdgeInsets.only(
//                                                     right: operate.length *
//                                                             (textSizeConfig
//                                                                     .bigTitleTextSize +
//                                                                 4) +
//                                                         10)
//                                                 : const EdgeInsets.all(0),
//                                             child: CustomToolTip(
//                                               text: widget.content,
//                                               child: Text(
//                                                 widget.content,
//                                                 style: TextStyle(
//                                                   fontSize: textSizeConfig
//                                                       .bigTitleTextSize,
//                                                   fontWeight: FontWeight.bold,
//                                                   overflow:
//                                                       TextOverflow.ellipsis,
//                                                 ),
//                                               ),
//                                             )),
//                                       )
//                                     : Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 10, right: 10),
//                                         child: TextField(
//                                           focusNode: widget.focusNode,
//                                           decoration: noBorderConfig(context),
//                                           controller: controller.controller
//                                               as TextEditingController,
//                                           style: TextStyle(
//                                             fontSize:
//                                                 textSizeConfig.bigTitleTextSize,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                           scrollPadding: EdgeInsets.zero,
//                                           minLines: 1,
//                                           maxLines: 5,
//                                         ),
//                                       )),
//                             controller.tags == null || controller.tags!.isEmpty
//                                 ? const SizedBox()
//                                 : const SizedBox(height: 10),
//                             controller.tags == null || controller.tags!.isEmpty
//                                 ? const SizedBox()
//                                 : Flexible(
//                                   child: Padding(
//                                     padding: const EdgeInsets.only(left: 10),
//                                     child: ConstrainedBox(
//                                       constraints: const BoxConstraints(minWidth: double.infinity,maxHeight: 100),
//                                       child: SingleChildScrollView(
//                                         child: Wrap(
//                                           runAlignment: WrapAlignment.start,
//                                           alignment: WrapAlignment.start,
//                                           runSpacing: 5,
//                                           children: controller.tags!
//                                               .map(
//                                                 (e) => IssueLabel(
//                                                   label: e.name,
//                                                   backgroundColor: e.color,
//                                                   close: widget.readOnly
//                                                       ? null
//                                                       : CustomizeWidget(
//                                                           icon: Icons.close,
//                                                           onTap: () => setState(
//                                                               () => controller
//                                                                   .tags!
//                                                                   .remove(e)),
//                                                         ),
//                                                 ),
//                                               )
//                                               .toList(),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                             widget.readOnly
//                                 ? const SizedBox()
//                                 : const SizedBox(height: 10),
//                             widget.readOnly
//                                 ? const SizedBox()
//                                 : StreamBuilder(
//                                     stream: actionController.stream,
//                                     builder: (context, snapshot) => Row(
//                                       children: [
//                                         const Expanded(child: SizedBox()),
//                                         ...(widget.actions ?? defaultActions)(
//                                             controller: controller,
//                                             operate: widget.save ?? (_) {},
//                                             swap: () =>
//                                                 widget.onReadOnly?.call(),
//                                             content: controller.content),
//                                         const SizedBox(
//                                           width: 10,
//                                         )
//                                       ],
//                                     ),
//                                   )
//                           ],
//                         )),
//                     Positioned(
//                         top: 0,
//                         right: 0,
//                         child: StreamBuilder(
//                           initialData: false,
//                           stream: hoverController.stream,
//                           builder: (context, snapshot) => Offstage(
//                             offstage: !(widget.readOnly &&
//                                 (snapshot.data ||
//                                     Adaptive.isMobile ||
//                                     widget.isKeepShowOperate)),
//                             child: Container(
//                               padding: const EdgeInsets.all(1),
//                               decoration: Adaptive.isMobile
//                                   ? null
//                                   : BoxDecoration(
//                                       color: Theme.of(context)
//                                           .colorScheme
//                                           .background,
//                                       border: Border.all(
//                                         width: 1,
//                                         color: borderColor(context.isDarkMode),
//                                       ),
//                                       borderRadius: BorderRadius.circular(3),
//                                     ),
//                               child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   children: [
//                                     ...widget.operatesWidget,
//                                     ...operate.map(
//                                       (e) => CustomizeWidget(
//                                         config: CustomizeWidgetConfig(
//                                           width:
//                                               textSizeConfig.bigTitleTextSize +
//                                                   4,
//                                           height:
//                                               textSizeConfig.bigTitleTextSize +
//                                                   4,
//                                           iconSize:
//                                               textSizeConfig.bigTitleTextSize,
//                                           hoverColor: Theme.of(context)
//                                               .colorScheme
//                                               .shadow,
//                                           backgroundColor:
//                                               Colors.white.withOpacity(0),
//                                         ),
//                                         tooltip: e.tooltip,
//                                         icon: e.icon,
//                                         onTap: e.onTap,
//                                       ),
//                                     )
//                                   ]),
//                             ),
//                           ),
//                         ))
//                   ],
//                 ),
//               )),
//         ));
//   }
// }
