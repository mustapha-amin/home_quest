import 'dart:async';

import 'package:flutter/material.dart';
import 'package:home_quest/core/colors.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/models/agent_stat.dart';
import 'package:hugeicons/hugeicons.dart';

class AgentStatWidget extends StatefulWidget {
  final AgentStat agentStat;
  const AgentStatWidget({required this.agentStat, super.key});

  @override
  State<AgentStatWidget> createState() => _AgentStatWidgetState();
}

class _AgentStatWidgetState extends State<AgentStatWidget> {
  StreamController<int> streamCtrl = StreamController<int>();

  void countdown() async {
    for (int i = 0;
        i <= widget.agentStat.count;
        widget.agentStat.title == "Revenue" ? i += 1000 : i++) {
      await Future.delayed(const Duration(microseconds: 1));
      streamCtrl.sink.add(i);
    }
  }

  @override
  void initState() {
    super.initState();
    countdown();
  }

  @override
  Widget build(BuildContext context) {
    return Card.filled(
      child: Column(
        spacing: 16,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HugeIcon(
                    icon: widget.agentStat.iconData,
                    color: AppColors.brown,
                    size: 30),
                Text(
                  widget.agentStat.title,
                  style: kTextStyle(18, color: AppColors.brown),
                ),
              ]),
          StreamBuilder(
            stream: streamCtrl.stream,
            builder: (context, snap) {
              return switch (snap.hasData) {
                true => Text(
                    widget.agentStat.title == "Ratings"
                        ? snap.data!.toDouble().toString()
                        : widget.agentStat.title == 'Revenue'
                            ? snap.data!.toMoney
                            : snap.data!.toString(),
                    style: kTextStyle(28, color: AppColors.brown),
                  ),
                false => Text("Loading")
              };
            },
          )
        ],
      ).padAll(12).padAll(5),
    );
  }
}
