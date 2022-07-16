import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:user/logic/controllers/cart_item.dart';
import 'package:user/logic/models/cart_item.dart';
import 'package:user/utilities/colors.dart';
import 'package:user/utilities/server.dart';

enum CartItemStatus {
  free('f'),
  paid('p');

  const CartItemStatus(this.code);
  final String code;
}

class CartItem extends StatelessWidget {
  final int id;
  final CartItemStatus status;
  const CartItem({Key? key, required this.id, required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CartItemCubit(id, status),
      child: BottomSheet(
        elevation: 40,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(19))),
        onClosing: () {},
        builder: (contxt) => SizedBox(
          height: MediaQuery.of(contxt).size.height * .7,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocConsumer<CartItemCubit, CartItemState>(
              listenWhen: (previous, current) => current.done,
              listener: (context, state) => Navigator.of(context).pop(),
              buildWhen: (previous, current) => previous.food != current.food,
              builder: (context, state) {
                print(state);
                if (state.food == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  children: [
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          Server.getAbsluteUrl(state.food!['imageUrl']),
                          fit: BoxFit.cover,
                          loadingBuilder: (_, child, chunk) {
                            if (chunk == null ||
                                chunk.cumulativeBytesLoaded ==
                                    chunk.expectedTotalBytes) {
                              return child;
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.food!['name'],
                              style: const TextStyle(
                                color: AppColors.brown4,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              state.food!['desc'],
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.only(end: 10),
                          child: BlocBuilder<CartItemCubit, CartItemState>(
                            buildWhen: (previous, current) =>
                                previous.fav != current.fav ||
                                previous.favLoading != current.favLoading,
                            builder: (context, state) => state.favLoading
                                ? const Center(
                                    child: SizedBox.square(
                                      dimension: 24,
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                : state.fav!
                                    ? IconButton(
                                        onPressed: () => context
                                            .read<CartItemCubit>()
                                            .removeFromFav(),
                                        icon: Icon(
                                          Icons.favorite,
                                          size: 23,
                                          color: Colors.grey.shade700,
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () => context
                                            .read<CartItemCubit>()
                                            .addToFav(),
                                        icon: Icon(
                                          Icons.favorite_outline,
                                          size: 23,
                                          color: Colors.grey.shade700,
                                        ),
                                      ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        BlocSelector<CartItemCubit, CartItemState, int>(
                          selector: (state) => state.count,
                          builder: (context, state) {
                            return Row(
                              children: [
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: RawMaterialButton(
                                    shape: const CircleBorder(),
                                    elevation: 4,
                                    fillColor: Colors.white,
                                    child: SvgPicture.asset(
                                      'assets/svg/min.svg',
                                      width: 25,
                                      color: AppColors.brown1,
                                      fit: BoxFit.contain,
                                    ),
                                    onPressed: () =>
                                        context.read<CartItemCubit>().dec(),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  state.toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: RawMaterialButton(
                                    shape: const CircleBorder(),
                                    elevation: 4,
                                    fillColor: AppColors.brown1,
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    onPressed: () =>
                                        context.read<CartItemCubit>().inc(),
                                  ),
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                              ],
                            );
                          },
                        ),
                        Row(
                          children: [
                            state.food!['offer'] != null
                                ? Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        end: 8),
                                    child: Text(
                                      state.food!['price'].toString(),
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const Text(
                              'amount',
                              style: TextStyle(
                                // color: AppColors.gold1,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ).tr(args: [state.price.toString()]),
                            state.food!['offer'] != null &&
                                    state.food!['offer']['type'] == '1'
                                ? Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 8),
                                    child: Text(
                                      '-${state.food!["offer"]["value"].toInt()}%',
                                      overflow: TextOverflow.fade,
                                      style: TextStyle(
                                        color: Colors.red.shade900,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20,
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      'Additions ?',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                      ),
                    ).tr(),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 100),
                      child: SingleChildScrollView(
                        child: BlocSelector<CartItemCubit, CartItemState, List>(
                          selector: (state) => state.addtions!,
                          builder: (context, state) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                ...(state)
                                    .map(
                                      (e) => Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                  value: e['value'],
                                                  fillColor:
                                                      MaterialStateProperty.all(
                                                          AppColors.brown1),
                                                  shape: const CircleBorder(),
                                                  onChanged: (v) => context
                                                      .read<CartItemCubit>()
                                                      .setAddtionVal(e, v!)),
                                              Text(
                                                e['name'],
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            'additionPrice',
                                            style: TextStyle(
                                              color: Colors.grey.shade700,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                            ),
                                          ).tr(args: [e['price'].toString()]),
                                        ],
                                      ),
                                    )
                                    .toList()
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/note.svg',
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: const Text(
                                  'Any Special Request',
                                  softWrap: true,
                                  style: TextStyle(
                                    color: AppColors.brown4,
                                    fontSize: 20,
                                  ),
                                ).tr(),
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            String? note = await showDialog(
                                context: context,
                                builder: (_) => _NoteDialog(
                                    text: context
                                        .read<CartItemCubit>()
                                        .state
                                        .note));
                            if (note != null) {
                              context.read<CartItemCubit>().setNote(note);
                            }
                          },
                          child: const Text(
                            'Add Note',
                            style: TextStyle(
                              color: AppColors.gold1,
                              fontSize: 16,
                            ),
                          ).tr(),
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  AppColors.brown2.withOpacity(.3))),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    BlocSelector<CartItemCubit, CartItemState, String>(
                      selector: (state) => state.error,
                      builder: (context, state) => Text(
                        state,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    InkWell(
                      onTap: () => context.read<CartItemCubit>().addToCart(),
                      child: SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: Stack(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: SvgPicture.asset(
                                  'assets/svg/btn_bg.svg',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Add To Cart",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ).tr(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          BlocSelector<CartItemCubit,
                                              CartItemState, double>(
                                            selector: (state) => state.total!,
                                            builder: (context, state) {
                                              return state > 0
                                                  ? const Text(
                                                      "amount",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ).tr(
                                                      args: [state.toString()])
                                                  : const SizedBox();
                                            },
                                          ),
                                          BlocBuilder<CartItemCubit,
                                              CartItemState>(
                                            buildWhen: (previous, current) =>
                                                previous.freeItems !=
                                                current.freeItems,
                                            builder: (context, state) {
                                              return state.freeItems > 0
                                                  ? const Text(
                                                      "invoicePoints",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ).tr(args: [
                                                      (state.freeItems *
                                                              state.food![
                                                                  'points'])
                                                          .toString()
                                                    ])
                                                  : const SizedBox();
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    BlocSelector<CartItemCubit, CartItemState, bool>(
                      selector: (state) => state.loading,
                      builder: (context, state) {
                        return Container();
                      },
                    )
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NoteDialog extends StatelessWidget {
  TextEditingController controller = TextEditingController();
  _NoteDialog({Key? key, required String text}) : super(key: key) {
    controller.text = text;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SingleChildScrollView(
                child: TextField(
                  cursorColor: AppColors.brown2,
                  controller: controller,
                  minLines: 8,
                  maxLines: 50,
                  decoration: InputDecoration(
                    hintText: tr('Write Note'),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.brown2),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(controller.text),
                    child: const Text('Add Note').tr(),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(AppColors.brown2)),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
