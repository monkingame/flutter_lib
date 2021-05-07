library dart_now_time_filename;

/// generate now time string for filename.
class NowFilename {
  static String genNowFilename(
      {String prefix: '', String ext: '', String seperator: '-'}) {
    final now = DateTime.now();
    final y = now.year.toString().padLeft(4, '0');
    final m = now.month.toString().padLeft(2, '0');
    final d = now.day.toString().padLeft(2, '0');
    final h = now.hour.toString().padLeft(2, '0');
    final mi = now.minute.toString().padLeft(2, '0');
    final s = now.second.toString().padLeft(2, '0');
    final ml = now.millisecond.toString().padLeft(3, '0');
    final mc = now.microsecond.toString().padLeft(3, '0');

    // return '$prefix$y$m$d$seperator$h$mi$s$seperator$ml$seperator$mc$ext';
    final p = prefix ?? '';
    final e = ext ?? '';
    final sp = seperator ?? '';
    return p + y + m + d + sp + h + mi + s + sp + ml + sp + mc + e;
  }
}
