import 'dart:math';

class DownloadedPodCastModel {
  static Map<String, dynamic> getPodcastInformation = {};
  static List downloadedPodcastFiles = [];
  static List<String> podcastNames = [];

  static List getPodCastFiles() {
    return downloadedPodcastFiles;
  }

  static List getPodCastNames() {
    downloadedPodcastFiles.forEach((element) {
      podcastNames.add(element.toString().substring(
          78,
          element.toString().length -
              5)); // start 78 to get name from the file and -5 to remove [.wav']
    });
    return podcastNames;
  }

  static Map<String, dynamic> getPodCastAudio(int index) {
    return getPodcastInformation['data'][index]['audio'];
  }

  static int getPodcastLikes(int index) {
    return getPodcastInformation['data'][index]['likes'];
  }

  static String getPodcastID(int index) {
    return getPodcastInformation['data'][index]['_id'].toString();
  }

  static String? getPodcastCategory(int index) {
    return getPodcastInformation['data'][index]['category'].toString();
  }

  static bool podcastLikeState(int index) {
    return getPodcastInformation['data'][index]['isLiked'];
  }

  static Map<String, dynamic> getPodcastUserPublishInform(int index) {
    return getPodcastInformation['data'][index]['createdBy'];
  }

  static String getPodcastName(int index) {
    return getPodcastInformation['data'][index]['name'];
  }
}
