import 'dart:math';

class DownloadedPodCastModel {
  static List downloadedPodcastFiles = [];
  static List getPodCastFiles() {
    return downloadedPodcastFiles;
  }

  static List getPodCastNames() {
    List<String>? podcastNames = [];
    downloadedPodcastFiles.forEach((element) {
      podcastNames.add(element.toString().substring(
          78,
          element.toString().length -
              5)); // start 78 to get name from the file and -5 to remove [.wav']
    });
    return podcastNames;
  }
}
