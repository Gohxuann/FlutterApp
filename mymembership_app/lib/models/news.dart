class News {
  String? newsId;
  String? newsTitle;
  String? newsDescription;
  String? newsDate;
  int likes = 0;
  int dislikes = 0;

  News(
      {this.newsId,
      this.newsTitle,
      this.newsDescription,
      this.newsDate,
      this.likes = 0,
      this.dislikes = 0});

  News.fromJson(Map<String, dynamic> json) {
    newsId = json['news_id'];
    newsTitle = json['news_title'];
    newsDescription = json['news_des'];
    newsDate = json['news_date'];
    likes = json['likes'] ?? 0;
    dislikes = json['dislikes'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['news_id'] = newsId;
    data['news_title'] = newsTitle;
    data['news_description'] = newsDescription;
    data['news_date'] = newsDate;
    data['likes'] = likes;
    data['dislikes'] = dislikes;
    return data;
  }
}
