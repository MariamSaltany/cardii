import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:saees_cards/helpers/consts.dart';
import 'package:saees_cards/helpers/functions_helper.dart';
import 'package:saees_cards/providers/invoices_provider.dart';
import 'package:saees_cards/widgets/cickables/main_button.dart';
import 'package:saees_cards/widgets/dialogs/flush_bar.dart';
import 'package:saees_cards/widgets/inputs/text_field_widget.dart';
import 'package:saees_cards/widgets/statics/shimmer_widget.dart';

class PlaceInvoiceSheet extends StatefulWidget {
  const PlaceInvoiceSheet({super.key, required this.cardUid});
  final String cardUid;
  @override
  State<PlaceInvoiceSheet> createState() => _PlaceInvoiceSheetState();
}

class _PlaceInvoiceSheetState extends State<PlaceInvoiceSheet> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Consumer<InvoicesProvider>(
      builder: (context, invoicesConsumer, _) {
        return BottomSheet(
          showDragHandle: true,
          onClosing: () {},

          builder: (context) {
            return Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text("Add Invoice", style: displaySmall),
                  ),
                  TextFieldWidget(
                    label: "Amount",
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    controller: amountController,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Amount is Required";
                      }

                      if (int.parse(v) <= 0) {
                        return "Amount must be postive value";
                      }
                      return null;
                    },
                  ),
                  TextFieldWidget(
                    label: "Description",

                    controller: descriptionController,
                    validator: (v) {
                      if (v!.isEmpty) {
                        return "Description is Required";
                      }

                      return null;
                    },
                  ),

                  ImageInput(
                    imgUrl: imageUrl,
                    onTap: () async {
                      final pickedFile = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile == null) {
                        return;
                      }

                      final uploadResponse = await invoicesConsumer.api.upload(
                        File(pickedFile.path),
                      );

                      if (uploadResponse.statusCode != 200) {
                        if (!context.mounted) {
                          return;
                        }
                        showCustomFlushBar(
                          context,
                          "Upload Failed",
                          "Please try again.",
                          false,
                        );
                        return;
                      } else {
                        setState(() {
                          imageUrl = json.decode(
                            uploadResponse.body,
                          )["full_path"];
                        });
                      }
                    },
                  ),

                  MainButton(
                    busy: invoicesConsumer.busy,
                    onTap: () {
                      if (formKey.currentState!.validate()
                      //  &&
                      //     imageUrl != null
                      ) {
                        invoicesConsumer
                            .placeInvoice({
                              "amount": amountController.text,
                              "wallet_uuid": widget.cardUid,
                              "image": imageUrl.toString(),
                              "description": descriptionController.text,
                            })
                            .then((addResponse) {
                              if (context.mounted) {
                                showCustomFlushBar(
                                  context,
                                  addResponse.first ? "Success" : "Failed",
                                  addResponse.last,
                                  addResponse.first,
                                );
                              }
                              if (addResponse.first) {
                                Timer(Duration(seconds: 3), () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              }
                            });
                      } else {
                        showCustomFlushBar(
                          context,
                          "Missed Data",
                          "Fill the form and add image",
                          false,
                        );
                      }
                    },
                    title: "Add",
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ImageInput extends StatelessWidget {
  const ImageInput({super.key, this.imgUrl, required this.onTap});
  final String? imgUrl;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          height: getSize(context).height * 0.1,
          child: imgUrl != null
              ? CachedNetworkImage(
                  imageUrl: "$imgUrl",

                  placeholder: (context, url) {
                    return SizedBox(
                      height: getSize(context).height * 0.1,
                      width: getSize(context).width,
                      child: ShimmerWidget(),
                    );
                  },

                  errorWidget: (context, url, error) {
                    return Container(
                      height: getSize(context).height * 0.1,
                      width: getSize(context).width,

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: redColor.withValues(alpha: 0.33),
                        ),
                        color: redColor.withValues(alpha: 0.1),
                      ),

                      child: Center(
                        child: Text(
                          "Image Error",
                          style: labelMedium.copyWith(color: redColor),
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.33),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    color: primaryColor.withValues(alpha: 0.1),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        color: primaryColor.withValues(alpha: 0.33),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
