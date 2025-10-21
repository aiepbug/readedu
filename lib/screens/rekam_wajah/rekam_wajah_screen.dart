import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'rekam_wajah_controller.dart';
import 'components/start_screen.dart';
import 'components/error_screen.dart';
import 'components/lines_view.dart';
import 'components/feedback_buttons.dart';
import 'components/finish_screen.dart';

class RekamWajahScreen extends StatelessWidget {
  const RekamWajahScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RekamWajahController()..initialize(),
      child: const RekamWajahView(),
    );
  }
}

class RekamWajahView extends StatelessWidget {
  const RekamWajahView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<RekamWajahController>();

    if (controller.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (controller.errorMessage != null) {
      return Scaffold(
        body: ErrorScreen(
          message: controller.errorMessage,
          onRetry: controller.retryLoad,
        ),
      );
    }

    if (controller.finishedAll) {
      return Scaffold(body: FinishScreen(userName: controller.userName));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: !controller.started
            ? StartScreen(
                onStart: (name, mode) {
                  controller.userName = name;
                  controller.selectedType = mode;
                  controller.started = true;
                  controller.initialize();
                  controller.startCountdown();
                },
              )
            : Stack(
                alignment: Alignment.center,
                children: [
                  if (controller.showCountdown)
                    Center(
                      child: Text(
                        "${controller.countdown}",
                        style: GoogleFonts.lexendDeca(
                          fontSize: 96,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                  if (controller.showText && !controller.showEncouragement)
                    LinesView(
                      reading:
                          controller.readings![controller.currentReadingIndex],
                      currentLineIndex: controller.currentLineIndex,
                    ),
                  if (controller.showFeedbackButtons)
                    FeedbackButtons(onFeedback: controller.handleFeedback),
                  if (controller.showEncouragement)
                    Center(
                      child: Text(
                        "Kamu hebat! 🎉",
                        style: GoogleFonts.lexendDeca(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
