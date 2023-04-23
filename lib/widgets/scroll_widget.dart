import 'package:flutter/material.dart';
import 'package:phandelver/model/adventure.dart';
import 'package:phandelver/my_game.dart';

class ScrollWidget extends StatefulWidget {
  final MyGame game;

  const ScrollWidget({
    Key? key,
    required this.game,
  }) : super(key: key);

  @override
  State<ScrollWidget> createState() => _ScrollWidgetState();
}

class _ScrollWidgetState extends State<ScrollWidget> {
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    widget.game.expandScroll.stream.listen((expanded) {
      setState(() {
        isExpanded = expanded;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: FractionallySizedBox(
        heightFactor: 0.4,
        alignment: Alignment.bottomCenter,
        child: AnimatedSlide(
          offset: isExpanded ? const Offset(0, 0) : const Offset(0, 0.8),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/scroll.png"),
                    centerSlice: Rect.fromLTWH(53, 141, 363, 387),
                  ),
                ),
                padding: const EdgeInsets.only(
                  top: 95,
                  left: 30,
                  right: 30,
                ),
                child: StreamBuilder<AdventureScene>(
                    stream: widget.game.currentScene.stream,
                    builder: (context, snapshot) {
                      final scene = snapshot.data;
                      return scene == null ? Container() : buildScene(scene);
                    }),
              ),
              Positioned(
                right: 0,
                child: GestureDetector(
                  onTap: () => setState(() {
                    isExpanded = !isExpanded;
                  }),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: AnimatedRotation(
                      turns: isExpanded ? 0 : 0.5,
                      duration: const Duration(milliseconds: 300),
                      child: Image.asset(
                        "assets/images/collapse.png",
                        width: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildScene(AdventureScene scene) {
    return ListView(
      key: Key(scene.id),
      physics: const BouncingScrollPhysics(),
      children: [
        const SizedBox(height: 25),
        Text(
          scene.text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: "Mentor",
          ),
        ),
        const SizedBox(height: 25),
        ...scene.actions.map((action) {
          return GestureDetector(
            onTap: () => widget.game.onActionTap(action),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/button.webp"),
                  fit: BoxFit.fill,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 40),
              alignment: Alignment.center,
              child: Text(
                action.text,
                style: TextStyle(
                  color: Colors.red[900],
                  fontSize: 20,
                  fontFamily: "Mentor",
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 25),
      ],
    );
  }
}
