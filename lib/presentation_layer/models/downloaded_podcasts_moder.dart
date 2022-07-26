import 'dart:math';

class DownloadedPodCastModel {
  static List getPodcastInformation = [];
  static List downloadedPodcastFiles = [];
  static List<String> podcastNames = [];

  static List getPodCastFiles() {
    return downloadedPodcastFiles;
  }

  static List getPodCastNames() {
    downloadedPodcastFiles.forEach((element) {
      String name = element.toString().substring(
          78,
          element.toString().length -
              5); // start 78 to get name from the file and -5 to remove [.wav']
      if (podcastNames.isEmpty) {
        podcastNames.add(name);
      } else {
        if (podcastNames.contains(name)) {
          print('iam in');
        } else {
          podcastNames.add(name);
        }
      }
    });
    return podcastNames;
  }

  static Map<String, dynamic> getPodCastAudio(int index) {
    return getPodcastInformation[index]['data'][0]['audio'];
  }

  static int getPodcastLikes(int index) {
    return getPodcastInformation[index]['data'][0]['likes'];
  }

  static String getPodcastID(int index) {
    return getPodcastInformation[index]['data'][0]['_id'].toString() + 'local';
  }

  static String? getPodcastCategory(int index) {
    return getPodcastInformation[index]['data'][0]['category'].toString();
  }

  static bool podcastLikeState(int index) {
    return getPodcastInformation[index]['data'][0]['isLiked'];
  }

  static Map<String, dynamic> getPodcastUserPublishInform(int index) {
    return getPodcastInformation[index]['data'][0]['createdBy'];
  }

  static String getPodcastName(int index) {
    return getPodcastInformation[index]['data'][0]['name'];
  }
}
