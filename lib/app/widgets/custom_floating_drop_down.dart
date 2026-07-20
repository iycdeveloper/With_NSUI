import 'package:flutter/material.dart';
import 'package:iyc/app/core/app_export.dart';
import 'package:iyc/app/core/utils/snackbar.dart';
import 'package:iyc/app/widgets/custom_search_view.dart';
import 'package:iyc/model/data_model/dropdown_item.dart';

class CustomFloatingDropDown extends StatefulWidget {
  ////
  const CustomFloatingDropDown(
      {super.key,
      this.value,
      this.title,
      this.titlestyle,
      this.listValues,
      this.hintstyle,
      this.hintText = '',
      this.dropdownIconColor,
      this.border,
      this.backgroundcolor,
      required this.onChanged,
      this.defaultMargin = true,
      this.readOnly = false,
      this.margin,
      this.borderRadius,
      this.padding,
      this.search = false});

  final String? title;
  final String? value;
  final String? hintText;
  final TextStyle? titlestyle;

  final List<DropdownItem>? listValues;
  final void Function(dynamic v) onChanged;
  final bool defaultMargin;
  final bool readOnly;
  final bool search;

  final TextStyle? hintstyle;
  final BoxBorder? border;
  final Color? dropdownIconColor;
  final EdgeInsetsGeometry? margin;
  final BorderRadiusGeometry? borderRadius;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundcolor;

  @override
  State<CustomFloatingDropDown> createState() => CustomFloatingDropDownState();
}

class CustomFloatingDropDownState extends State<CustomFloatingDropDown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _toggleDropdown() {
    if (filterlistValues == null) {
      CustomSnackBar.showWarningSnackBar("No item to select");
    } else {
      if (_overlayEntry == null) {
        _overlayEntry = _createOverlayEntry();
        Overlay.of(context).insert(_overlayEntry!);
      } else {
        _overlayEntry?.remove();
        _overlayEntry = null;
      }
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: Material(
            elevation: 0,
            color: Colors.transparent,
            // borderRadius: BorderRadius.circular(8),
            child: Container(
              margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
              constraints: const BoxConstraints(maxHeight: 326),
              height: 49.0 *
                      (filterlistValues == null
                          ? 0
                          : filterlistValues!.length) +
                  2,
              // width: double.maxFinite,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey[200]!,
                  // width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, 10),
                  ),
                ],
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 20.h,
                  top: 13.v,
                  bottom: 13.v,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        filterlistValues!.length,
                        (index) => GestureDetector(
                              onTap: () {
                                _overlayEntry?.remove();
                                _overlayEntry = null;
                                widget
                                    .onChanged(filterlistValues![index].value);
                                // Get.back();
                              },
                              child: Column(
                                // crossAxisAlignment:
                                //     CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.all(4.0),
                                    width: double.maxFinite,
                                    child: Row(
                                      children: [
                                        Text(
                                          filterlistValues![index].name,
                                          style: theme.textTheme.bodyMedium!
                                              .copyWith(color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey[200],
                                    endIndent: 20,
                                  ),
                                  if (!(index ==
                                      (filterlistValues!.length - 1)))
                                    SizedBox(height: 16.v),
                                ],
                              ),
                            )),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    inttmethod();
  }

  List<DropdownItem>? filterlistValues = [];

  Future inttmethod()async {
    // Future.delayed(Duration(milliseconds: 2000));
    if (!mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        filterlistValues = widget.listValues;
      });
    });
  }

  // searchmethod(String value) {
  //   if (value.isNotEmpty) {
  //     setState(() {
  //       filterlistValues = widget.listValues!
  //           .where(
  //               (test) => test.name.toLowerCase().contains(value.toLowerCase()))
  //           .toList();
  //     });
  //   } else {
  //     setState(() {
  //       filterlistValues = widget.listValues;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (!widget.readOnly) {
          FocusScope.of(context).requestFocus(FocusNode());
          // Sync the list from the current source of truth. NOTE: inttmethod()
          // updates filterlistValues only in a post-frame callback, so it is
          // STALE if read immediately — assign directly so the guard and the
          // dialog below see the real, current data.
          filterlistValues = widget.listValues;
          // Opening the dialog dereferences filterlistValues! (non-null
          // assertion). If there's nothing to show, bail out with a message
          // instead of crashing "Null check operator used on a null value".
          // Use ScaffoldMessenger (not the GetX snackbar) to avoid the
          // "No Overlay widget found" error during this transition.
          if (filterlistValues == null || filterlistValues!.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No item to select")));
            return;
          }
          Get.dialog(StatefulBuilder(builder: (context, setState) {
            searchmethod(String value) {
              setState(() {
                filterlistValues = widget.listValues;
              });
              if (value.isNotEmpty) {
                setState(() {
                  filterlistValues = widget.listValues!
                      .where((test) =>
                          test.name.toLowerCase().contains(value.toLowerCase()))
                      .toList();
                });
              } else {
                setState(() {
                  filterlistValues = widget.listValues;
                });
              }
            }

            return Material(
              type: MaterialType.transparency,
              child: Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  constraints: const BoxConstraints(maxHeight: 326),
                  height: filterlistValues!.isEmpty
                      ? mediaQueryData.size.height
                      : 200.0 *
                              (filterlistValues == null
                                  ? 2
                                  : filterlistValues!.length) +
                          2,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.blue,
                      // width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 20.h,
                      top: 13.v,
                      bottom: 13.v,
                    ),
                    child: Column(
                      children: [
                        if (widget.search) ...[
                          CustomSearchView(
                            margin:
                                EdgeInsets.only(top: 10, bottom: 15, right: 15),
                            autofocus: false,
                            onChanged: (str) {
                              searchmethod(str);
                            },
                            // focusNode: logic.focusNode,
                            width: mediaQueryData.size.width,
                            // controller: logic.searchController,
                            hintText: "lbl_search".tr,
                            suffix: Container(
                              margin:
                                  EdgeInsets.fromLTRB(30.h, 13.v, 12.h, 13.v),
                              child: CustomImageView(
                                svgPath: ImageConstant.imgSearchBlueGray300,
                                color: Colors.black,
                              ),
                            ),
                            borderDecoration: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide:
                                    BorderSide(color: Colors.grey[300]!)),
                            // suffixConstraints: BoxConstraints(
                            //   maxHeight: 42.v,
                            // ),
                            contentPadding: EdgeInsets.only(
                              left: 10.h,
                              top: 10.v,
                              right: 10,
                              bottom: 12.v,
                            ),
                          ),
                        ],

                        if (filterlistValues!.isEmpty) ...[
                          SizedBox(
                            height: 80,
                          ),
                          Text('No data Found')
                        ],

                        // Text('data'),
                        Expanded(
                          child: ListView(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: List.generate(
                                filterlistValues!.length,
                                (index) => GestureDetector(
                                      onTap: () {
                                        widget.onChanged(
                                            filterlistValues![index].value);
                                        // Use Navigator.pop, not Get.back():
                                        // Get.back() routes through GetX
                                        // closeCurrentSnackbar() which throws a
                                        // LateInitializationError (uninitialized
                                        // snackbar _controller) and leaves the
                                        // dropdown dialog stuck open.
                                        Navigator.of(context).pop();
                                      },
                                      child: Column(
                                        // crossAxisAlignment:
                                        //     CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            color: Colors.transparent,
                                            padding: const EdgeInsets.all(4.0),
                                            width: double.maxFinite,
                                            child: Row(
                                              children: [
                                                Text(
                                                  filterlistValues![index].name,
                                                  style: theme
                                                      .textTheme.bodyLarge!
                                                      .copyWith(
                                                          color: Colors.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            color: Colors.grey[300],
                                            endIndent: 20,
                                          ),
                                          if (!(index ==
                                              (filterlistValues!.length - 1)))
                                            SizedBox(height: 16.v),
                                        ],
                                      ),
                                    )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }), barrierColor: Colors.transparent, barrierDismissible: true);
        }
      },
      child:
          //  CompositedTransformTarget(
          //   link: _layerLink,
          // child:
          //  GestureDetector(
          //   onTap: () {
          //     if (!widget.readOnly) {
          //       FocusScope.of(context).requestFocus(new FocusNode());
          //       _toggleDropdown();
          //     }
          //   },
          // child:
          Container(
        margin: widget.margin ??
            (widget.defaultMargin
                ? EdgeInsets.only(left: 20.h, top: 20.v, right: 20.h)
                : EdgeInsets.only(left: 20.h, top: 5.v, right: 20.h)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.title!.isNotEmpty) ...[
              Text(
                '${widget.title}',
                style:
                    widget.titlestyle ?? theme.textTheme.bodyLarge!.copyWith(),
              ),
            ],
            const SizedBox(
              height: 5,
            ),
            Container(
                padding: widget.padding ??
                    EdgeInsets.symmetric(horizontal: 17.h, vertical: 17.v),
                decoration: BoxDecoration(
                  color: widget.backgroundcolor ?? Colors.white,
                  borderRadius:
                      widget.borderRadius ?? BorderRadius.circular(12.h),
                  border: widget.border ??
                      Border.all(
                        // color: appTheme.blue10001,
                        color: const Color(0xFFB1C9E2),

                        // width: 1,
                      ),
                ),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // SizedBox(height: 3.v),
                                // Text(
                                //   title!,
                                //   style: theme.textTheme.bodyLarge,
                                //   overflow: TextOverflow.ellipsis,
                                // ),
                                // SizedBox(height: 3.v),
                                Padding(
                                    padding: EdgeInsets.only(top: 0.v),
                                    child: (widget.value != null &&
                                            filterlistValues!.isNotEmpty)
                                        ? Text(
                                            filterlistValues!
                                                .firstWhere((element) =>
                                                    element.value ==
                                                    widget.value)
                                                .name,
                                            style: theme.textTheme.bodyLarge)
                                        : SizedBox(
                                            width:
                                                mediaQueryData.size.width * 0.5,
                                            child: Text("${widget.hintText}",
                                                overflow: TextOverflow.ellipsis,
                                                style: widget.hintstyle ??
                                                    theme.textTheme.bodyLarge!
                                                        .copyWith(
                                                      color: const Color(
                                                          0xFFB1C9E2),
                                                    )),
                                          )),
                              ],
                            ),
                            CustomImageView(
                                svgPath: ImageConstant.imgArrowupBlueGray300,
                                height: 20.adaptSize,
                                width: 20.adaptSize,
                                color: widget.dropdownIconColor,
                                margin: EdgeInsets.only(bottom: 4.v))
                          ])
                    ])),
          ],
        ),
      ),
      //   ),
      // )
    );
  }
}
