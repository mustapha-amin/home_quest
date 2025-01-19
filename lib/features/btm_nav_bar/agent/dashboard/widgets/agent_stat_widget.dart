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
                    icon: agentStat.iconData, color: AppColors.brown, size: 30),
                Text(
                  agentStat.title,
                  style: kTextStyle(18, color: AppColors.brown),
                ),
              ]),
          Text(
            agentStat.count.toString(),
            style: kTextStyle(28, color: AppColors.brown),
          ),
        ],
      ).padAll(12).padAll(5),
    );
  }
}
