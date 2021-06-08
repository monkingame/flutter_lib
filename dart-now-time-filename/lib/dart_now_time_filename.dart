library dart_now_time_filename;

/// generate now time string for filename.
class NowFilename {
  /// generate now file name
  static String genSpecifyTime({
    String? prefix: '',
    String? ext: '',
    String? seperator: '-',
    required DateTime? time,
  }) {
    // final now = DateTime.now();
    final now = time == null ? DateTime.now() : time;

    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    final h = now.hour.toString().padLeft(2, '0');
    final mi = now.minute.toString().padLeft(2, '0');
    final s = now.second.toString().padLeft(2, '0');
    final ml = now.millisecond.toString().padLeft(3, '0');
    final mc = now.microsecond.toString().padLeft(3, '0');

    final p = prefix ?? '';
    final e = ext ?? '';
    final sp = seperator ?? '';
    return p + y + m + d + sp + h + mi + s + sp + ml + sp + mc + e;
  }

  static String gen({
    String? prefix: '',
    String? ext: '',
    String? seperator: '-',
  }) {
    return genSpecifyTime(
        prefix: prefix, ext: ext, seperator: seperator, time: DateTime.now());
  }

  @Deprecated('Use NowFilename.gen() instead. '
      'This feature was deprecated after v2.0')
  static String genNowFilename(
      {String? prefix: '', String? ext: '', String? seperator: '-'}) {
    return gen(prefix: prefix, ext: ext, seperator: seperator);
  }
}
