
class ModelVideo {
  String? videoUrl;

  ModelVideo({required this.videoUrl});

  ModelVideo.fromJson(Map<String, dynamic> json) {
    videoUrl = json['video_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['video_url'] = this.videoUrl;
    return data;
  }
}
