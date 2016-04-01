module Lita
  class Router < Handler
    http.get "/musics" do |request, response|
      response.body << db_connection.hgetall(redis_track_key)
    end

    http.get "/music/:user" do |request, response|
      response.body << db_connection.hgetall(user)
    end

    http.get "/music/:genre" do |request, response|
      response.body << db_connection.hgetall(genre)
    end
  end
end
