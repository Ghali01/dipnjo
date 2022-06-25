import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:location/location.dart';

import 'package:user/logic/controllers/locations.dart';
import 'package:user/logic/models/locations.dart';
import 'package:user/ui/widgets/app_bar.dart';
import 'package:user/utilities/colors.dart';

enum LocationsIntent {
  select,
  normal;
}

class LocationsArgs {
  LocationsIntent intent;
  LocationsArgs({
    required this.intent,
  });
}

class LocationsPage extends StatefulWidget {
  LocationsArgs args;
  LocationsPage({Key? key, required this.args}) : super(key: key);

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
  Future<bool> _chekckLocation(BuildContext context) async {
    Location location = Location();
    PermissionStatus status = await location.hasPermission();
    print(status);
    if (status == PermissionStatus.denied) {
      showModalBottomSheet(
          context: context, builder: (_) => const _LocationPermSheet());
    } else {
      if (await location.serviceEnabled()) {
        return true;
      } else {
        await location.requestService();
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LocationsCubit(),
      child: Scaffold(
        appBar: const PreferredSize(
          preferredSize: Size(double.infinity, 65),
          child: AppAppBar(title: 'Locations'),
        ),
        body: BlocBuilder<LocationsCubit, LocationsState>(
          builder: (context, state) {
            if (state.locations == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: state.locations!.length,
                itemBuilder: (context, index) => Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        splashColor: AppColors.brown1.withOpacity(.1),
                        onTap: () {
                          context
                              .read<LocationsCubit>()
                              .setCurrentLocation(state.locations![index]);

                          if (widget.args.intent == LocationsIntent.select) {
                            Navigator.of(context).pop(state.locations![index]);
                          }
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: 40,
                              height: 40,
                              child: Center(
                                child: SvgPicture.asset(
                                  'assets/svg/location.svg',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state.locations![index]['name'],
                                  style: const TextStyle(
                                      color: AppColors.brown4,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  state.locations![index]['details'],
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Radio<int>(
                        value: state.locations![index]['id'],
                        groupValue: state.currentId,
                        onChanged: (v) {
                          context
                              .read<LocationsCubit>()
                              .setCurrentLocation(state.locations![index]);
                          if (widget.args.intent == LocationsIntent.select) {
                            Navigator.of(context).pop(state.locations![index]);
                          }
                        },
                        fillColor: MaterialStateProperty.all(AppColors.brown1),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            child: const Icon(Icons.add),
            backgroundColor: AppColors.brown2,
            onPressed: () async {
              if (await _chekckLocation(context)) {
                Map? data = await showDialog(
                    context: context, builder: (_) => _LocationDialog());
                if (data != null) {
                  context.read<LocationsCubit>().addLocation(data);
                }
              }
            },
          );
        }),
      ),
    );
  }
}

class _LocationPermSheet extends StatelessWidget {
  const _LocationPermSheet({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomSheet(
        enableDrag: false,
        onClosing: () {},
        builder: (_) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox.square(
                    dimension: 128,
                    child: Image.asset(
                      'assets/images/map.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Text(
                    'Allow Location Access',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Center(
                    child: SizedBox(
                      width: 330,
                      child: Text(
                        'locationPermText',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 18,
                        ),
                      ).tr(),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  TextButton(
                    onPressed: () async {
                      Location location = Location();
                      PermissionStatus status =
                          await location.requestPermission();
                      if (status == PermissionStatus.granted) {
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text(
                      'yes',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ).tr(),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          AppColors.brown1.withOpacity(.3)),
                      backgroundColor:
                          MaterialStateProperty.all(AppColors.brown4),
                      foregroundColor: MaterialStateProperty.all(Colors.white),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(16),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Not Now',
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ).tr(),
                    style: ButtonStyle(
                      overlayColor: MaterialStateProperty.all(
                          AppColors.brown1.withOpacity(.3)),
                      backgroundColor:
                          MaterialStateProperty.all(const Color(0xffF1F1F3)),
                      foregroundColor:
                          MaterialStateProperty.all(AppColors.brown1),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.all(16),
                      ),
                    ),
                  )
                ],
              ),
            ));
  }
}

class _LocationDialog extends StatelessWidget {
  _LocationDialog({Key? key}) : super(key: key);
  TextEditingController name = TextEditingController(),
      address = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  String? isNotEmpty(String? text) {
    if (text == null || text.isEmpty) {
      return tr("this field is empty");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: BlocProvider(
        create: (context) => AddLocationCubit(),
        child: BlocListener<AddLocationCubit, AddLocationState>(
          listenWhen: (previous, current) => current.done,
          listener: (context, state) => Navigator.of(context).pop(state.data),
          child: SizedBox(
            height: 320,
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextFormField(
                      validator: isNotEmpty,
                      controller: name,
                      cursorColor: AppColors.brown2,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.brown2),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.brown2),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.brown2),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.brown2),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.brown2),
                        ),
                        hintText: tr("location name"),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      validator: isNotEmpty,
                      maxLines: 2,
                      minLines: 2,
                      controller: address,
                      cursorColor: AppColors.brown2,
                      decoration: InputDecoration(
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.brown2),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.brown2),
                        ),
                        focusedErrorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.brown2),
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.brown2),
                        ),
                        errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.brown2),
                        ),
                        hintText: tr("address"),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    BlocSelector<AddLocationCubit, AddLocationState, String>(
                      selector: (state) => state.error,
                      builder: (context, state) {
                        return Text(
                          state,
                          style: const TextStyle(color: Colors.red),
                        );
                      },
                    ),
                    Builder(builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context
                                .read<AddLocationCubit>()
                                .save(name.text, address.text);
                          }
                        },
                        child: Text("Add").tr(),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(AppColors.brown4),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                      );
                    }),
                    BlocSelector<AddLocationCubit, AddLocationState, bool>(
                      selector: (state) => state.loading,
                      builder: (context, state) {
                        return state
                            ? const CircularProgressIndicator()
                            : const SizedBox();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
