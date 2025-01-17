var url = "qdZLz1PLwutJMZUDokL2Td96hiWLIDlhQ6LEJ0zHfGs3uqp7mucvO9Yu";

String baseUrl(String query,int perPage, int Pageno){
  return "https://api.pexels.com/v1/search?query=${query.trim()}&per_page=${perPage}&page=${Pageno}";
}

Map <String, String> header = {
  "Authorization" : url
};