http.get "/musics" do |request, response|
  response.body << # database connection and get all of it
end

http.get "/music/:user" do |request, response|
  response.body << # database connection and get all music by user
end

http.get "/music/:genre" do |request, response|
  response.body << # database connection and get all music by genre
end
