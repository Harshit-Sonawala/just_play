import 'package:flutter/material.dart';
// import '../screens/wip_screen.dart';
// import '../screens/user_account_screen.dart';
// import '../screens/test_screen.dart';
import '../custom_card.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        backgroundColor: const Color.fromARGB(241, 30, 30, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: CustomCard(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.headphones,
                              size: 32,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              'Apollo',
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              'Music',
                              style: Theme.of(context).textTheme.displayMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Version 0.1.0',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // ListTile(
            //   onTap: () => {},
            //   leading: const Icon(Icons.home, size: 24),
            //   title: Text(
            //     'Home',
            //     style: Theme.of(context).textTheme.bodyMedium,
            //   ),
            // ),
            // ListTile(
            //   onTap: () => {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const UserAccountScreen(),
            //       ),
            //     ),
            //   },
            //   leading: const Icon(Icons.accessibility, size: 24.0),
            //   title: Text(
            //     'My Exercises',
            //     style: Theme.of(context).textTheme.bodyMedium,
            //   ),
            // ),
            ListTile(
              onTap: () => {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const TestScreen(),
                //   ),
                // ),
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const WipScreen(
                //       screenName: 'Settings Screen',
                //     ),
                //   ),
                // ),
              },
              leading: const Icon(Icons.settings, size: 24.0),
              title: Text(
                'Settings',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            ListTile(
              onTap: () => {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => const WipScreen(
                //       screenName: 'About Screen',
                //     ),
                //   ),
                // ),
              },
              leading: const Icon(Icons.info_outlined, size: 24.0),
              title: Text(
                'About',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
