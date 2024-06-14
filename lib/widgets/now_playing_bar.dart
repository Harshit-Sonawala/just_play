import 'package:flutter/material.dart';

import './custom_card.dart';

class NowPlayingBar extends StatefulWidget {
  const NowPlayingBar({super.key});

  @override
  State<NowPlayingBar> createState() => _NowPlayingBarState();
}

class _NowPlayingBarState extends State<NowPlayingBar> {
  // Offset pos_offset = const Offset(32, 732);
  double _nowPlayingHeight = 80.0;
  bool _nowPlayingClosed = true;
  double _swipeVelocity = 200.0;
  int _finalDuration = 200;
  // double _scaleValue = 1.0;
  double _offsetValueX = 0.0;
  double _offsetValueY = 0.0;
  bool _nowPlayingAudioPlay = false;
  @override
  Widget build(BuildContext context) {
    // debugPrint('Device Height: ${MediaQuery.of(context).size.height}');
    // debugPrint('_nowPlayingClosed: $_nowPlayingClosed');
    var minOpenThreshold = 0.4 * MediaQuery.of(context).size.height;
    var maxHeight = 0.8 * MediaQuery.of(context).size.height;
    var minHeight = 80.0;
    return Positioned(
      // top: pos_offset.dy,
      bottom: 60 + MediaQuery.of(context).size.height * 0.008,
      child: GestureDetector(
        onVerticalDragUpdate: (DragUpdateDetails dragUpdateDetails) => {
          if (dragUpdateDetails.delta.dy < 0) // if upward swipe but not necessary it crosses threshold
            {
              setState(() =>
                  // pos_offset += dragUpdateDetails.delta,
                  _nowPlayingHeight += dragUpdateDetails.delta.dy * -3),
            },
          if (dragUpdateDetails.delta.dy > 0 &&
              _nowPlayingHeight >
                  minHeight) // if downward swipe && height is bigger than min (to avoid renderflex overflow)
            {
              setState(
                () => _nowPlayingHeight += dragUpdateDetails.delta.dy * -3,
                // _nowPlayingClosed = true,
              ),
            }
        },
        onVerticalDragEnd: (DragEndDetails dragEndDetails) => {
          _swipeVelocity = dragEndDetails.primaryVelocity! * 0.1,
          _finalDuration = (600 - _swipeVelocity.round().abs()).toInt(),
          debugPrint('_swipeVelocity: $_swipeVelocity, _finalDuration: $_finalDuration'),
          if (_nowPlayingHeight >
              minOpenThreshold) // on swipe complete, if threshold crossed, open completely, else close
            {
              setState(() {
                _nowPlayingHeight = maxHeight;
                _nowPlayingClosed = false;
                // _scaleValue = 5.0,
                _offsetValueX += 35.0;
                _offsetValueY += 10.0;
              })
            },
          if (_nowPlayingHeight < minOpenThreshold)
            {
              setState(() {
                _nowPlayingHeight = minHeight;
                _nowPlayingClosed = true;
                // _scaleValue = 1.0,
                _offsetValueX -= 35.0;
                _offsetValueY -= 10.0;
              })
            },
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: _finalDuration > 0 ? _finalDuration : 100),
          curve: Curves.ease,
          height: _nowPlayingHeight,
          width: MediaQuery.of(context).size.width,
          child: CustomCard(
            // padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            padding: const EdgeInsets.only(top: 2, left: 10, bottom: 6, right: 10),
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
            color: const Color.fromARGB(248, 40, 40, 40),
            child: Column(
              mainAxisAlignment: _nowPlayingClosed ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                !_nowPlayingClosed
                    ? Icon(
                        Icons.keyboard_arrow_down,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      )
                    : Container(),
                !_nowPlayingClosed
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomCard(
                              padding: const EdgeInsets.all(20),
                              borderRadius: 2,
                              child: SizedBox(
                                height: _nowPlayingHeight * 0.4,
                                child: const Icon(
                                  Icons.album,
                                  size: 40,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Now Playing',
                              style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Now Subtitle',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 20),
                            const LinearProgressIndicator(
                              value: 0.7,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('0:00', style: Theme.of(context).textTheme.bodySmall),
                                Text('3:14', style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () => {},
                                  icon: const Icon(
                                    Icons.shuffle,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => {},
                                  icon: const Icon(
                                    Icons.skip_previous,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  height: 60,
                                  width: 60,
                                  child: CircleAvatar(
                                    backgroundColor: Theme.of(context).colorScheme.surface,
                                    child: IconButton(
                                      onPressed: () => setState(
                                        () => _nowPlayingAudioPlay = !_nowPlayingAudioPlay,
                                      ),
                                      icon: Icon(
                                        _nowPlayingAudioPlay ? Icons.pause : Icons.play_arrow,
                                        size: 40,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => {},
                                  icon: const Icon(
                                    Icons.skip_next,
                                    size: 32,
                                    color: Colors.white,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => {},
                                  icon: const Icon(
                                    Icons.repeat,
                                    size: 24,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Text('Up Next', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      )
                    : Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(3.0),
                            child: LinearProgressIndicator(
                              value: 0.6,
                              minHeight: 2.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    // Transform.scale(
                                    //   scale: _scaleValue,
                                    //   child: Transform.translate(
                                    //     offset: Offset(_offsetValueX, _offsetValueY),
                                    //     child: const CustomCard(
                                    //       padding: EdgeInsets.all(20),
                                    //       borderRadius: 2,
                                    //       child: Icon(Icons.album),
                                    //     ),
                                    //   ),
                                    // ),
                                    const CustomCard(
                                      padding: EdgeInsets.all(18),
                                      borderRadius: 2,
                                      child: Icon(Icons.album),
                                    ),
                                    const SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Now Playing',
                                          style: Theme.of(context).textTheme.displaySmall,
                                        ),
                                        Text(
                                          'Now Subtitle',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => setState(
                                  () => _nowPlayingAudioPlay = !_nowPlayingAudioPlay,
                                ),
                                icon: Icon(
                                  _nowPlayingAudioPlay ? Icons.pause : Icons.play_arrow,
                                  size: 28,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
