# dart_now_time_filename

generate now time string for filename.

## Getting Started
Sometimes it needs a time string for filename.
The time stamp is useful for logging and searching.

## Usage
final filename = NowFilename.genNowFilename(prefix: 'header-', ext: '.mp3');

And you'll get:

header-20210508-084919-314-149.mp3
