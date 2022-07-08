import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/logic/controllers/profile.dart';
import 'package:user/logic/models/profile.dart';
import 'package:user/ui/widgets/app_bar.dart';
import 'package:user/utilities/colors.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);
  String dateFromater(String ds) {
    DateTime date = DateTime.parse(ds);
    String yr = date.year.toString().substring(2);
    return '${date.day}.${date.month}.$yr';
  }

  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 56),
        child: AppAppBar(title: 'Profile'),
      ),
      body: BlocProvider(
        create: (context) => ProfileCubit(),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: [
                Stack(
                  children: [
                    Image.asset('assets/images/profile.png'),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'welcome',
                              style: TextStyle(
                                color: AppColors.brown3,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ).tr(),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              state.data!['user']['name'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 32,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.black, width: .4))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'name',
                          style:
                              TextStyle(color: AppColors.brown1, fontSize: 18),
                        ).tr(),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          state.data!['user']['name'],
                          style: const TextStyle(
                              color: AppColors.brown2, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.black, width: .4))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Birthday',
                          style:
                              TextStyle(color: AppColors.brown1, fontSize: 18),
                        ).tr(),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          dateFromater(state.data!['birth']),
                          style: const TextStyle(
                              color: AppColors.brown2, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.black, width: .4))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Gender',
                          style:
                              TextStyle(color: AppColors.brown1, fontSize: 18),
                        ).tr(),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          state.data!['gender'] == 'f' ? "Female" : "Male",
                          style: const TextStyle(
                              color: AppColors.brown2, fontSize: 18),
                        ).tr(),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.black, width: .4))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Phone Number',
                          style:
                              TextStyle(color: AppColors.brown1, fontSize: 18),
                        ).tr(),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: state.editing
                                    ? TextField(
                                        controller: phoneController
                                          ..text = state.data!['phone'] ?? '',
                                        decoration: const InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.brown2),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: AppColors.brown2),
                                          ),
                                        ),
                                      )
                                    : Text(
                                        state.data!['phone'] ?? 'Not Set!',
                                        style: const TextStyle(
                                            color: AppColors.brown2,
                                            fontSize: 18),
                                      )),
                            FirebaseAuth.instance.currentUser!.providerData
                                        .first.providerId ==
                                    PhoneAuthProvider.PROVIDER_ID
                                ? const SizedBox()
                                : state.loading
                                    ? const CircularProgressIndicator()
                                    : state.editing
                                        ? IconButton(
                                            onPressed: () => context
                                                .read<ProfileCubit>()
                                                .save(phoneController.text),
                                            icon: const Icon(
                                              Icons.done,
                                              color: AppColors.brown1,
                                            ),
                                          )
                                        : IconButton(
                                            onPressed: () => context
                                                .read<ProfileCubit>()
                                                .startEdit(),
                                            icon: const Icon(
                                              Icons.edit,
                                              color: AppColors.brown1,
                                            ),
                                          )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(color: Colors.black, width: .4))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'City',
                          style:
                              TextStyle(color: AppColors.brown1, fontSize: 18),
                        ).tr(),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          state.data!['city'],
                          style: const TextStyle(
                              color: AppColors.brown2, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
