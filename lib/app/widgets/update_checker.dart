import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/update_controller.dart';
import '../../shared/widgets/force_update_dialog.dart';

/// Widget that checks for app updates on init
class UpdateChecker extends StatefulWidget {
  final Widget child;

  const UpdateChecker({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<UpdateChecker> createState() => _UpdateCheckerState();
}

class _UpdateCheckerState extends State<UpdateChecker> {
  final UpdateController _updateController = Get.find<UpdateController>();
  bool _hasChecked = false;

  @override
  void initState() {
    super.initState();
    // Check for update after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForUpdate();
    });
  }

  Future<void> _checkForUpdate() async {
    if (_hasChecked) return;
    _hasChecked = true;

    try {
      final needsUpdate = await _updateController.checkForUpdate();
      
      if (needsUpdate && mounted) {
        final isForceUpdate = _updateController.forceUpdate.value;
        
        // Show update dialog
        showDialog(
          context: context,
          barrierDismissible: !isForceUpdate, // Can't dismiss if force update
          builder: (context) => ForceUpdateDialog(
            isForceUpdate: isForceUpdate,
            message: _updateController.updateInfo.value?.updateMessage,
          ),
        );
      }
    } catch (e) {
      debugPrint('Error checking for update: $e');
      // On error, don't block the app
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}


