class News {
  String? newsId;
  String? newsTitle;
  String? newsDescription;
  String? newsDate;

  News({this.newsId, this.newsTitle, this.newsDescription, this.newsDate});

  News.fromJson(Map<String, dynamic> json) {
    newsId = json['news_id'];
    newsTitle = json['news_title'];
    newsDescription = json['news_des'];
    newsDate = json['news_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['news_id'] = newsId;
    data['news_title'] = newsTitle;
    data['news_description'] = newsDescription;
    data['news_date'] = newsDate;
    return data;
  }
}
