import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/shared/icon_button.dart';


class PlatformNotSupportedDialog extends StatelessWidget {
  const PlatformNotSupportedDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 400,
        height: 200,
        child:
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: 
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Platform not supported'),
                  const Divider(),
                  const SizedBox(height: 16,),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sorry, this feature is not supported on this platform.',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16,),
                  const Divider(),
                  const SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildIconButton(
                        text: 'Close',
                        icon: Icons.close,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ],
              ),
          ),
      ),
    );
  }
}



void showPlatformNotSupportedDialog(BuildContext context) {
  print('showPlatformNotSupportedDialog');

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const PlatformNotSupportedDialog();
    }
  );
}




