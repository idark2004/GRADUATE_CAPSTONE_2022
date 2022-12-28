import 'package:apms_mobile/bloc/profile_bloc.dart';
import 'package:apms_mobile/presentation/screens/authen/change_password.dart';
import 'package:apms_mobile/presentation/screens/authen/sign_in.dart';
import 'package:apms_mobile/presentation/screens/profile/feedback.dart';
import 'package:apms_mobile/presentation/screens/profile/topup.dart';
import 'package:apms_mobile/presentation/screens/profile/transaction_history.dart';
import 'package:apms_mobile/themes/colors.dart';
import 'package:apms_mobile/themes/fonts.dart';
import 'package:apms_mobile/themes/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileBloc _profileBloc = ProfileBloc();

  @override
  void initState() {
    _profileBloc.add(FetchProfileInformation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: _buildProfileAppBar()),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildBriefAccountInformationCard(),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.06,
            ),
            _buildProfileOptionsList(),
            _logOutButton()
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAppBar() {
    return AppBar(
      title: const Text('Profile', style: TextStyle(color: deepBlue)),
      backgroundColor: lightBlue,
    );
  }

  Widget _buildBriefAccountInformationCard() {
    return BlocProvider(
      create: (_) => _profileBloc,
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileFetchedSuccessfully) {
            return Card(
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text(state.profile.fullName, style: titleTextStyle),
                ),
                subtitle: Row(
                  children: [
                    Text(
                        "Account balance: ${state.profile.accountBalance.toStringAsFixed(0)} VND"),
                    const Spacer(),
                    IconButton(
                        icon: addIcon,
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const TopUp())).then((value) =>
                            {_profileBloc.add(FetchProfileInformation())}))
                  ],
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              ),
            );
          } else {
            return const Card();
          }
        },
      ),
    );
  }

  Widget _buildProfileOptionsList() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const TransactionHistory(),
              )),
              child: SizedBox(
                width: screenWidth,
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.1),
                        child: const Icon(Icons.account_balance_outlined)),
                    Padding(
                        padding: EdgeInsets.only(left: screenWidth * 0.04),
                        child: const Text('Transaction History')),
                    Padding(
                        padding: EdgeInsets.only(right: screenWidth * 0.1),
                        child: const Icon(Icons.arrow_forward_ios_rounded))
                  ],
                ),
              ),
            ),
          ],
        ),
        const Divider(
          height: 20,
          thickness: 1,
        ),
        InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const SendFeedback(),
          )),
          child: SizedBox(
            height: 40,
            width: screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.1),
                    child: const Icon(Icons.comment_bank_rounded)),
                Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.04),
                    child: const Text('Feedback')),
                Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.1),
                    child: const Icon(Icons.arrow_forward_ios_rounded))
              ],
            ),
          ),
        ),
        const Divider(
          height: 20,
          thickness: 1,
        ),
        InkWell(
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ChangePassword(),
          )),
          child: SizedBox(
            height: 40,
            width: screenWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.1),
                    child: const Icon(Icons.password_rounded)),
                Padding(
                    padding: EdgeInsets.only(left: screenWidth * 0.04),
                    child: const Text('Change password')),
                Padding(
                    padding: EdgeInsets.only(right: screenWidth * 0.1),
                    child: const Icon(Icons.arrow_forward_ios_rounded))
              ],
            ),
          ),
        ),
        const Divider(
          height: 40,
        ),
      ],
    );
  }

  Widget _logOutButton() {
    final navigator = Navigator.of(context, rootNavigator: true);
    return OutlinedButton.icon(
      onPressed: () async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await pref.clear();
        navigator.pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SignIn()),
            (route) => false);
      },
      icon: const Icon(Icons.login),
      label: const Text('Log out'),
    );
  }
}
