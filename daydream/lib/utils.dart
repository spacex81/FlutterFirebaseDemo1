import 'dart:math';

String generatePin() {
  const _chars = 'abcdefghijklmnopqrstuvwxyz1234567890';
  Random _rnd = Random();

  return String.fromCharCodes(Iterable.generate(
      7, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}

String generateConversationId(String uid1, String uid2) {
  if (uid1.compareTo(uid2) < 0) {
    return "${uid1}_${uid2}";
  } else {
    return "${uid2}_${uid1}";
  }
}
