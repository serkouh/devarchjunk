import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String url;

  const AudioPlayerWidget({super.key, required this.url});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _player;
  double speed = 1.0;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.setUrl(widget.url);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.7,
      child: Container(
        //padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: StreamBuilder<PlayerState>(
          stream: _player.playerStateStream,
          builder: (context, snapshot) {
            final isPlaying = snapshot.data?.playing ?? false;

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(
                    isPlaying
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    size: 40,
                    color: Colors.white,
                  ),
                  onTap: () {
                    isPlaying ? _player.pause() : _player.play();
                  },
                  // tooltip: isPlaying ? "Pause" : "Lecture",
                ),
                StreamBuilder<Duration>(
                  stream: _player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    final total = _player.duration ?? Duration.zero;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6,
                            ),
                          ),
                          child: Slider(
                            value: position.inMilliseconds
                                .clamp(0, total.inMilliseconds)
                                .toDouble(),
                            max: total.inMilliseconds > 0
                                ? total.inMilliseconds.toDouble()
                                : 1,
                            onChanged: (value) {
                              _player
                                  .seek(Duration(milliseconds: value.toInt()));
                            },
                            activeColor: Colors.blueAccent,
                            inactiveColor: Colors.grey.shade300,
                          ),
                        ),
                        /*   Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDuration(position),
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              _formatDuration(total),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),*/
                      ],
                    );
                  },
                ),
                /*  const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                     IconButton(
                  icon: const Icon(Icons.replay_5),
                  onPressed: () {
                    final newPos =
                        _player.position - const Duration(seconds: 5);
                    _player
                        .seek(newPos > Duration.zero ? newPos : Duration.zero);
                  },
                  tooltip: "Reculer 5s",
                ),
                    IconButton(
                      icon: const Icon(Icons.forward_5),
                      onPressed: () {
                        final newPos =
                            _player.position + const Duration(seconds: 5);
                        _player.seek(newPos);
                      },
                      tooltip: "Avancer 5s",
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<double>(
                        value: speed,
                        icon: const Icon(Icons.speed),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => speed = val);
                            _player.setSpeed(val);
                          }
                        },
                        items: [0.5, 1.0, 1.5, 2.0].map((s) {
                          return DropdownMenuItem(
                            value: s,
                            child: Text("${s}x",
                                style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),*/
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
