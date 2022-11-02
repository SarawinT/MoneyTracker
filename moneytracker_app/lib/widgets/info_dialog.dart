import 'package:flutter/material.dart';

class InfoDialog extends StatelessWidget {
  const InfoDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 250,
          width: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.black,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "About this app",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              const Expanded(
                child: Text(
                    "Flutter Project for 517324 Mobile Application Development, "
                    "Silpakorn University  (2022)\n\n"
                    "♥🧡💛💚💙💜"),
              ),
              const Text("Created by Sarawin Thiamthet"),
              const Text("GitHub : github.com/SarawinT"),
              const Text("Email : contact.sarawin@gmail.com")
            ],
          ),
        ),
      ),
    );
  }
}
