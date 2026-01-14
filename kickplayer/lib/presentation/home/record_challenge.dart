import 'package:flutter/material.dart';
import 'package:Kaledal/core/theme_colors.dart';
import 'package:Kaledal/presentation/home/capturing.dart';
import 'package:video_player/video_player.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VideoRecord extends StatefulWidget {
  final String videoTitle;

  VideoRecord({required this.videoTitle});

  @override
  _VideoRecordState createState() => _VideoRecordState();
}

class _VideoRecordState extends State<VideoRecord> {
  VideoPlayerController? _controller;
  Map<String, TestData> testDataMap = {
    "9": TestData(
      title: "Pace",
      description:
          "Testing players' ability to quickly reach top speed and maintain it effectively.",
      equipmentImages: ["assets/images/Frame 508.png"],
      playerInstructions: [
        "Mark two points on the ground: Point A (starting line) and Point B (50 meters away).",
        "Start from a stationary position and sprint from Point A to Point B.",
        "Record the video with the camera fixed at the side.",
      ],
      filmingInstructions: [
        "Make sure your camera is facing the goal.",
        "Keep a clear view of yourself and the ball.",
        "Place your phone on a tripod or ask someone to record.",
      ],
    ),
    "16": TestData(
      title: "Juggling Drill",
      description:
          "Testing players' ball control, coordination, and consistency while juggling.",
      equipmentImages: ["x1 ball"],
      playerInstructions: [
        "Stand facing the camera with at least 6 meters of space between you and the camera.",
        "Start juggling the ball using your feet, thighs, and head if needed.",
        "Do not let the ball touch the ground during the 30-second challenge.",
        "Ensure your feet and the ball are fully visible in the frame at all times.",
      ],
      filmingInstructions: [
        "Make sure your camera is positioned 6 meters away, directly facing you.",
        "Keep a clear view of your entire body and the ball throughout the challenge.",
        "Place your phone on a tripod or ask someone to record.",
        "The camera must stay still while recording.",
      ],
    ),
    "3": TestData(
      title: "Pace Drill",
      description:
          "Testing players' ability to accelerate quickly and maintain top speed over a short distance.",
      equipmentImages: ["x4 low plot"],
      playerInstructions: [
        "Mark two gates using the low plots: Gate A (starting point) and Gate B (ending point), with 15 meters between them.",
        "Begin from a stationary position on the right side of Gate A.",
        "Sprint from Gate A to Gate B at your maximum speed.",
        "Perform the run without slowing down, maintaining top pace through the finish line.",
      ],
      filmingInstructions: [
        "Place the camera at the side, with a clear view of the 15m sprint path.",
        "Ensure the entire run and the player's movement are visible.",
        "Use a tripod or ask someone to record the video.",
        "Camera should remain still throughout the challenge.",
      ],
    ),
    "11": TestData(
      title: "Zig Zag Dash Drill",
      description:
          "Testing players' agility, dribbling, and speed while dribbling in tight spaces.",
      equipmentImages: ["x1 ball", "x3 low plot"],
      playerInstructions: [
        "Set up the 3 plots in a zig-zag pattern, with 3 meters between each plot.",
        "Dribble quickly from plot to plot, weaving around each one while keeping the ball under control.",
        "Maintain a low body position and quick touches as you move through the drill.",
      ],
      filmingInstructions: [
        "Position the camera to fully capture the player and all 3 plots.",
        "The entire dribbling path must be visible in the frame.",
        "Place your phone on a tripod or ask someone to record.",
        "Camera should remain still throughout the challenge.",
      ],
    ),
    "8": TestData(
      title: "Jumping Drill",
      description:
          "Testing players' body strength, explosive power, composure and landing control.",
      equipmentImages: ["x4 low plot"],
      playerInstructions: [
        "Set up the 4 plots to form a square, with 0.5 meters between each plot.",
        "Stand at the center of the square.",
        "Jump with maximum force.",
        "After jumping, land and hold your position for 1 second.",
        "Maintain good form and balance throughout the drill.",
      ],
      filmingInstructions: [
        "Position the camera to fully capture the player and the square of plots.",
        "Make sure the entire body and jumping movement are clearly visible.",
        "Place your phone on a tripod or ask someone to record.",
        "Camera should remain still throughout the challenge.",
      ],
    ),
    "6": TestData(
      title: "Strength Hold Drill",
      description:
          "Testing players' lower-body and core strength, endurance, and stability.",
      equipmentImages: ["x4 low plot"],
      playerInstructions: [
        "Use the 4 plots to mark your position and form a square space around you.",
        "Raise both arms straight in front of you, shoulder height, keeping them parallel to the ground.",
        "Hold this position for 1 minute without moving or shaking.",
      ],
      filmingInstructions: [
        "Position the camera to fully capture your body and the 4 plot markers.",
        "Make sure your arms, legs, and posture are clearly visible.",
        "Use a tripod or ask someone to record.",
        "Camera must stay still during the entire hold.",
      ],
    ),
    "12": TestData(
      title: "Penalty Decision Drill",
      description:
          "Testing players' decision-making, composure, and accuracy under pressure.",
      equipmentImages: ["x1 ball", "x2 low plot", "x1 goalkeeper"],
      playerInstructions: [
        "Place the ball on the penalty spot and make sure it is completely still before shooting.",
        "Position 2 low plots on the goal line, one at each side, to mark the arrival line for video analysis.",
        "Once ready, shoot the penalty with confidence and precision.",
        "The goalkeeper should actively try to save the shot.",
      ],
      filmingInstructions: [
        "Position the camera to face both the player and the goal, capturing the full view from beside the goalkeeper.",
        "The camera must remain still during the entire sequence.",
        "Use a tripod or ask someone to record.",
      ],
    ),
    "13": TestData(
      title: "Volley Decision Drill",
      description:
          "Testing players' timing, coordination, and finishing ability with volleys under pressure.",
      equipmentImages: ["x1 ball", "x1 teammate"],
      playerInstructions: [
        "Position yourself inside the box, ready to receive the cross.",
        "Your teammate should stand near the touch line, ready to deliver an accurate cross.",
        "As the ball is crossed, hit a volley directly at goal without controlling it.",
        "The goal is to finish the volley with precision and power.",
      ],
      filmingInstructions: [
        "Place the camera behind or beside the teammate, ensuring a full view of the crossing action, the player, and the goal.",
        "The entire movement, from the cross to the volley shot must be visible in the frame.",
        "Make sure both the player and the ball are clearly visible during the shot.",
        "Use a tripod or ask someone to record, and keep the camera completely still throughout the drill.",
      ],
    ),
    "15": TestData(
      title: "15m Dribbling with Run Drill",
      description:
          "Testing players' dribbling skills, ball control, and acceleration over a short distance.",
      equipmentImages: ["x1 ball", "x4 low plot"],
      playerInstructions: [
        "Set up 2 plots at the start line (on the right side) and 2 plots at the arrival line, ensuring 15 meters between the pairs.",
        "Start from a stationary position behind the right start plot with the ball at your feet.",
        "Dribble the ball touching it with every step as you move forward.",
      ],
      filmingInstructions: [
        "Position the camera at a side view, capturing the entire 15m dribbling path.",
        "Ensure both start and arrival lines, the ball, and the player are visible throughout the drill.",
        "Use a tripod or ask someone to record. Keep the camera still during the challenge.",
      ],
    ),
    "7": TestData(
      title: "Endurance Sprint Drill",
      description:
          "Testing players' sprinting endurance, speed recovery, and explosive consistency.",
      equipmentImages: ["x4 low plot"],
      playerInstructions: [
        "Mark your start line with 2 plots and your arrival line with the other 2, spaced 20 meters apart.",
        "Start from behind the right plot of the start line.",
        "Sprint from start to arrival line, then immediately sprint back to the start.",
        "Complete this back-and-forth sprint 6 times in total without stopping.",
        "Keep your pace high, no walking allowed.",
      ],
      filmingInstructions: [
        "Set up the camera at a side angle or elevated diagonal position to capture the full 20m sprint path.",
        "Ensure both start and arrival lines, the entire player body, and movements are clearly visible.",
        "Use a tripod or someone to record. The camera must stay fixed throughout the full sprint set.",
      ],
    ),
    "14": TestData(
      title: "Power shoot",
      description:
          "Testing defensive positioning, reaction speed, and tackling ability in real-game situations.",
      equipmentImages: ["x1 ball", "x4 low plot"],
      playerInstructions: [
        "The attacker starts with the ball. Once the drill begins, they attempt to dribble past the defender and cross the arrival line or mini-goal.",
        "Prevent the attacker from getting past or force them out wide.",
        "The round ends when the attacker passes or you win the ball or block the path.",
        "No fouls, focus on clean defense and body positioning.",
      ],
      filmingInstructions: [
        "Place the camera at a diagonal angle where it can view the entire interaction zone.",
        "Ensure both players are fully visible, including their legs and the ball.",
        "Make sure the jersey colors are clearly different.",
        "Use a tripod or a person to record, and keep the camera completely still.",
      ],
    ),
    "4": TestData(
      title: "Interception Zone Drill",
      description:
          "Testing players' reaction time, positioning, and ability to read and intercept passes in a defined zone.",
      equipmentImages: ["x1 ball", "x4 low plot", "x2 players"],
      playerInstructions: [
        "Mark a 4m-wide interception zone using the 4 plots (2 on each side).",
        "You start inside the zone, standing ready.",
        "The passer and receiver stand outside the zone, facing each other, 10 meters apart.",
        "On signal, the passer tries to pass the ball through the zone to the receiver.",
        "You must anticipate the pass, intercept it cleanly, or deflect it without stepping out of the zone.",
        "Complete 5 passes, with the defender attempting to intercept each one.",
        "No diving, you must stay within the zone and use positioning and timing to intercept.",
      ],
      filmingInstructions: [
        "Set up the camera facing the zone from the side, showing the full triangle: passer → defender → receiver.",
        "All 3 players, the ball, and all 4 zone markers must be clearly visible.",
        "Use a tripod or ask someone to record. Camera must stay still.",
      ],
    ),
    "2": TestData(
      title: "Crossing Drill",
      description:
          "Testing players' ability to deliver accurate crosses into a designated target area.",
      equipmentImages: ["x1 ball", "x1 low plot"],
      playerInstructions: [
        "Place the target plot 20 meters away from your crossing position.",
        "Position yourself at the crossing spot, near the sideline.",
        "Aim to land the ball directly on or as close as possible to the plot.",
        "The ball must not bounce more than once before reaching the plot to be considered valid.",
        "Focus on your crossing form, timing, and direction, you get only one attempt.",
      ],
      filmingInstructions: [
        "Position the camera at a side or diagonal angle to capture the player, ball flight, and plot in one continuous shot.",
        "Ensure the entire body of the player, the ball, and the target plot are fully visible.",
        "Use a tripod or ask someone to record, and keep the camera completely still during the shot.",
      ],
    ),
    "1": TestData(
      title: "Short Pass Drill",
      description:
          "Testing players' short passing accuracy, control, and rhythm using a single ball and a wall or rebound surface.",
      equipmentImages: ["x1 ball", "x2 low plots"],
      playerInstructions: [
        "Find a flat wall or solid rebound surface.",
        "Mark your passing zone using two low plots about 2 meters apart, and stand 4 meters away from the wall.",
        "Stay inside this zone and begin passing the ball firmly against the wall so that it comes back to you.",
        "Keep your rhythm: one-touch passes if possible, or two touches (control + pass) if needed.",
        "Pass continuously for 30 seconds, making sure each pass is accurate and controlled.",
      ],
      filmingInstructions: [
        "Place the camera facing the player from the front or at a diagonal so that both the player and the wall are in the frame.",
        "Ensure the player, plots, and wall are clearly visible.",
        "Use a tripod or a steady hand, and keep the camera completely still throughout the recording.",
      ],
    ),
/*
    "3": TestData(
      title: "Long Pass Precision Drill",
      description:
          "Testing players' long passing accuracy and control using a single ball and a defined target zone.",
      equipmentImages: ["x1 ball", "x2 low plots"],
      playerInstructions: [
        "Mark 2 plots on the ground to create a target zone 20 meters away in a straight line from your starting position.",
        "Attempt to deliver one accurate long pass toward the target zone, your goal is to land the ball inside the target zone or as close as possible.",
        "You get one single attempt in this challenge, focus on precision.",
      ],
      filmingInstructions: [
        "Set the camera at a side angle or diagonal wide angle so the player, ball flight, and target zone are all visible in the same frame.",
        "Make sure the entire body of the player, the target zone, and the ball are fully visible.",
        "Use a tripod or someone steady, and keep the camera completely still.",
      ],
    ),
    "16": TestData(
      title: "Shadow Defending Drill",
      description:
          "Develops defensive stance, lateral movement, and reaction control.",
      equipmentImages: ["x4 low plots (mark a zone)"],
      playerInstructions: [
        "Create a square zone (about 2m x 2m) using the plots.",
        "Get into a defensive stance (low, knees bent, arms ready).",
        "Imagine a player is dribbling in front of you — start lateral shuffling, mimicking their fake movements.",
        "Keep your eyes forward, stay balanced.",
        "Drill lasts 30 seconds non-stop."
      ],
      filmingInstructions: [
        "Camera must be front-facing or diagonal to see body movement and stance clearly.",
      ],
    ),*/
    // Placeholder for 14 to be continued...
  };

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() async {
    final response = await http.get(
      Uri.parse(
          'https://api.kickplayer.net/challenge/video?challenge_id=${widget.videoTitle}'),
      headers: {'accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final videoUrl = data['video_url'];

      if (videoUrl != null && videoUrl.isNotEmpty) {
        _controller = VideoPlayerController.network(videoUrl)
          ..initialize().then((_) {
            setState(() {});
            _controller?.play();
          });
      } else {
        print('No video URL available.');
      }
    } else {
      print('Failed to fetch video: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final testData = testDataMap[widget.videoTitle]!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(testData.title, style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Skip', style: TextStyle(color: Colors.black)),
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.30,
            child: _controller != null
                ? GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FullScreenVideo(controller: _controller!),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      ),
                    ),
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.7,
            minChildSize: 0.7,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: deepgrey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        _buildTitle(testData.title),
                        _buildText(testData.description),
                        _buildEquipments(testData.equipmentImages),
                        _buildSectionTitle('Player Instructions'),
                        ...testData.playerInstructions
                            .map((instr) => _buildInstruction(instr)),
                        SizedBox(
                          height: 24,
                        ),
                        _buildSectionTitle('Filming Instructions'),
                        ...testData.filmingInstructions
                            .map((instr) => _buildInstruction(instr)),
                        SizedBox(height: 24),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width *
                                0.7, // 70% of screen width
                            child: ElevatedButton(
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => VideoCaptureScreen(
                                            videoTitle: widget.videoTitle,
                                          )),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: mainblue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Start',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Color(0xFF161731),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 28,
        color: mainblue,
      ),
    );
  }

  Widget _buildText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, color: Color(0xFF161731)),
    );
  }

  Widget _buildInstruction(String instruction) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.arrow_forward, color: mainblue),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            instruction,
            style: TextStyle(fontSize: 16, color: Color(0xFF161731)),
            overflow: TextOverflow.ellipsis, // Prevents overflow
            maxLines: 3, // Limits text to 3 lines
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _buildEquipments(List<String> equipmentList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
        ),
        _buildSectionTitle('Equipments'),
        SizedBox(
          height: 12,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 20,
          runSpacing: 20,
          children: equipmentList.map((equipment) {
            final numberMatch = RegExp(r'x(\d+)').firstMatch(equipment);
            final number = numberMatch != null ? numberMatch.group(1) : '?';

            final lower = equipment.toLowerCase();
            String imagePath;

            if (lower.contains('ball')) {
              imagePath =
                  'assets/images/a5dfcc23be21e7df629f08ad50cc5b10ddc291a3.png';
            } else if (lower.contains('plot')) {
              imagePath =
                  'assets/images/121d43407b30dab51f50692e4a324faf0237617e.png';
            } else if (lower.contains('player')) {
              imagePath =
                  'assets/images/14525d18392b5193bb84561057a07a6f3f82e170.png';
            } else {
              imagePath =
                  'assets/images/121d43407b30dab51f50692e4a324faf0237617e.png'; // fallback
            }

            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5), // light grey background
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(imagePath, fit: BoxFit.contain),
                  ),
                  // Quantity badge
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Text(
                        'x$number',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        SizedBox(
          height: 24,
        ),
      ],
    );
  }
}

class TestData {
  final String title;
  final String description;
  final List<String> equipmentImages;
  final List<String> playerInstructions;
  final List<String> filmingInstructions;

  TestData({
    required this.title,
    required this.description,
    required this.equipmentImages,
    required this.playerInstructions,
    required this.filmingInstructions,
  });
}

class FullScreenVideo extends StatefulWidget {
  final VideoPlayerController controller;

  const FullScreenVideo({Key? key, required this.controller}) : super(key: key);

  @override
  _FullScreenVideoState createState() => _FullScreenVideoState();
}

class _FullScreenVideoState extends State<FullScreenVideo> {
  bool _showControls = true;
  late VideoPlayerController _controller;
  late VoidCallback _listener;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.play(); // Auto-play
    _listener = () => setState(() {});
    _controller.addListener(_listener);
  }

  @override
  void dispose() {
    _controller.removeListener(_listener);
    super.dispose();
  }

  String _formatDuration(Duration position) {
    final hours = position.inHours;
    final minutes = position.inMinutes.remainder(60);
    final seconds = position.inSeconds.remainder(60);
    return [
      if (hours > 0) hours.toString().padLeft(2, '0'),
      minutes.toString().padLeft(2, '0'),
      seconds.toString().padLeft(2, '0'),
    ].join(':');
  }

  void _toggleControls() {
    setState(() => _showControls = !_showControls);
  }

  void _seekForward() {
    final newPosition = _controller.value.position + Duration(seconds: 10);
    _controller.seekTo(newPosition);
  }

  void _seekBackward() {
    final newPosition = _controller.value.position - Duration(seconds: 10);
    _controller
        .seekTo(newPosition >= Duration.zero ? newPosition : Duration.zero);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Center(
              child: AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
            ),
            if (_showControls)
              Positioned.fill(
                child: Container(
                  color: Colors.black45,
                  child: Column(
                    children: [
                      // Top Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 32.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      // Center Controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.replay_10,
                                color: Colors.white, size: 36),
                            onPressed: _seekBackward,
                          ),
                          IconButton(
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                              size: 50,
                            ),
                            onPressed: () {
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.forward_10,
                                color: Colors.white, size: 36),
                            onPressed: _seekForward,
                          ),
                        ],
                      ),

                      // Bottom Bar with Slider
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              colors: VideoProgressColors(
                                playedColor: Colors.red,
                                bufferedColor: Colors.white30,
                                backgroundColor: Colors.white10,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_controller.value.position),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  _formatDuration(_controller.value.duration),
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
