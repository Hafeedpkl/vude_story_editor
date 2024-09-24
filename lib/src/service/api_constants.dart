class ApiConstants {
  static const giphyBaseUrl = 'https://api.giphy.com/v1/';
}

class ApiEndPoints {
  ApiEndPoints._();
  static giphyTrending(String key) =>
      'stickers/trending?api_key=$key&limit=48&offset=0&rating=g&bundle=messaging_non_clips';
  static giphySearch(String key, String query) =>
      'stickers/search?api_key=$key&q=$query&limit=48&offset=0&rating=g&lang=en&bundle=messaging_non_clips';
}
