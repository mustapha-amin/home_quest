import 'package:flutter/material.dart';
import 'package:home_quest/core/colors.dart';
import 'package:home_quest/core/extensions.dart';
import 'package:home_quest/core/utils/textstyle.dart';
import 'package:home_quest/models/agent_stat.dart';
import 'package:hugeicons/hugeicons.dart';

class AgentStatWidget extends StatelessWidget {
  final AgentStat agentStat;
  const AgentStatWidget({required this.agentStat, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.brown,
            Colors.brown,
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HugeIcon(icon: agentStat.iconData, color: Colors.amber, size: 30),
          Text(
            agentStat.title,
            style: kTextStyle(28, color: Colors.white),
          ),
          Text(
            agentStat.count.toString(),
            style: kTextStyle(20, color: Colors.white),
          ),
        ],
      ),
    ).padAll(5);
  }
}
