import 'package:flutter/material.dart';

class IncomingCallScreen extends StatefulWidget {
  final String callerName;
  final String callerImage;

  const IncomingCallScreen({
    Key? key,
    required this.callerName,
    required this.callerImage,
  }) : super(key: key);

  @override
  _IncomingCallScreenState createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen>
    with TickerProviderStateMixin {
  late AnimationController _swipeGuideController;
  late Animation<double> _swipeGuideAnimation;
  late AnimationController _arrowAnimation;
  late List<Animation<double>> _animations;
  final int numArrows = 4;

  final List<int> _animationDelays = [1, 2, 3, 4];
  Map<String, double> _dragPositions = {
    'accept': 0.0,
    'reject': 0.0,
    'message': 0.0,
  };
  String? _activeDragButton;
  bool _isDragging = false;

  @override
  void initState() {
    super.initState();

    _arrowAnimation = AnimationController(
      vsync: this,
      duration:
          const Duration(milliseconds: 2400), // Control animation duration
    );

    // Create a list of animations for the opacity of each arrow
    _animations = List.generate(numArrows, (index) {
      final invertedIndex = numArrows - 1 - index;

      return Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(
        parent: _arrowAnimation,
        curve: Interval(
          invertedIndex / numArrows,
          (invertedIndex + 1) / numArrows,
          curve: Curves.easeInOut,
        ),
      ));
    });

    // Start the animation cycle
    _startAnimationCycle();

    // Swipe guide animation for accept button
    _swipeGuideController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _swipeGuideAnimation = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: -15)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -15, end: 0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
    ]).animate(_swipeGuideController);
  }

  @override
  void dispose() {
    _swipeGuideController.dispose();
    _arrowAnimation.dispose();
    super.dispose();
  }

  void _startAnimationCycle() async {
    if (_isDragging) {
      _arrowAnimation.stop();
    }
    while (true) {
      for (int i = 0; i < numArrows; i++) {
        await _arrowAnimation.forward();
        // Each arrow fades in, then out after 1 second
        await Future.delayed(const Duration(milliseconds: 500));
        await _arrowAnimation.repeat();
      }
    }
  }

  void _handleDragUpdate(DragUpdateDetails details, String buttonType) {
    setState(() {
      if (_activeDragButton == buttonType || _activeDragButton == null) {
        _activeDragButton = buttonType;
        if (!_isDragging) {
          _isDragging = true;
          _swipeGuideController.stop();
        }
        _dragPositions[buttonType] =
            _dragPositions[buttonType]! + (details.primaryDelta ?? 0);
        _dragPositions[buttonType] =
            _dragPositions[buttonType]!.clamp(-100.0, 100.0);
      }
    });
  }

  void _handleDragEnd(DragEndDetails details, String buttonType) {
    if (_dragPositions[buttonType]!.abs() > 50) {
      switch (buttonType) {
        case 'accept':
          Navigator.pop(context, 'accept');
          break;
        case 'reject':
          Navigator.pop(context, 'reject');
          break;
        case 'message':
          Navigator.pop(context, 'message');
          break;
      }
    }

    setState(() {
      _dragPositions[buttonType] = 0;
      _activeDragButton = null;
      _isDragging = false;
      _swipeGuideController.repeat();
    });
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String type,
    required String label,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onVerticalDragUpdate: (details) =>
                  _handleDragUpdate(details, type),
              onVerticalDragEnd: (details) => _handleDragEnd(details, type),
              child: Transform.translate(
                offset: Offset(0, _dragPositions[type]!),
                child: type == 'accept' && !_isDragging
                    ? AnimatedBuilder(
                        animation: _swipeGuideAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _swipeGuideAnimation.value),
                            child: Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Icon(
                                icon,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          );
                        },
                      )
                    : Container(
                        width: 65,
                        height: 65,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
              ),
            )
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
        if (type == 'accept')
          Text(
            'Swipe up to accept',
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 10,
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            // Caller info
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(widget.callerImage),
            ),
            const SizedBox(height: 20),
            Text(
              widget.callerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Incoming call...',
              style: TextStyle(color: Colors.white70),
            ),
            const Spacer(),
            Column(
                children: // Action buttons
                    List.generate(numArrows, (index) {
              return AnimatedBuilder(
                animation: _animations[index],
                builder: (context, child) {
                  return Opacity(
                    opacity: _animations[index].value,
                    child: const Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: Colors.white,
                      size: 15,
                    ),
                  );
                },
              );
            })),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    icon: Icons.message,
                    color: Colors.blue,
                    type: 'message',
                    label: 'Message',
                  ),
                  _buildActionButton(
                    icon: Icons.call,
                    color: Colors.green,
                    type: 'accept',
                    label: 'Accept',
                  ),
                  _buildActionButton(
                    icon: Icons.call_end,
                    color: Colors.red,
                    type: 'reject',
                    label: 'Reject',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
