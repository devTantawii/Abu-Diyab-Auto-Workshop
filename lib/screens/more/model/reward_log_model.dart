
class RewardLog {
  final int id;
  final int points;
  final String type; // 'referral', 'task', etc.
  final bool isAddition; // true = + , false = -

  RewardLog({
    required this.id,
    required this.points,
    required this.type,
    required this.isAddition,
  });

  factory RewardLog.fromJson(Map<String, dynamic> json) {
    return RewardLog(
      id: json['id'],
      points: json['points'],
      type: json['type'],
      isAddition: json['is_addition'],
    );
  }
}

class RewardLogsResponse {
  final int countLogs;
  final String sumLogs;
  final List<RewardLog> logs;

  RewardLogsResponse({
    required this.countLogs,
    required this.sumLogs,
    required this.logs,
  });

  factory RewardLogsResponse.fromJson(Map<String, dynamic> json) {
    return RewardLogsResponse(
      countLogs: json['data']['countLogs'],
      sumLogs: json['data']['sumLogs'],
      logs: (json['data']['logs'] as List)
          .map((log) => RewardLog.fromJson(log))
          .toList(),
    );
  }
}