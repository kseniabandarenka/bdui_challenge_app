/// Челлендж с указанным идентификатором не существует.
class ChallengeNotFoundException implements Exception {
  final String challengeId;

  ChallengeNotFoundException(this.challengeId);

  @override
  String toString() => 'Challenge not found: $challengeId';
}
