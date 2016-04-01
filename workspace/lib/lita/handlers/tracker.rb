require './lib/lita/spotifier'
require 'redis'

module Lita
  module Handlers
    class Tracker < Handler
      route(/\Ahttps?:\/\/open\.spotify\.com\/track\/(\w+)/i, :find_and_save_track, command: false, help: {
        '/\Ahttps?:\/\/open\.spotify\.com\/track\/(\w+)/i' => 'uploads your track and related info up to the BlueApron music site'
      })

      http.get "/tracks" do |request, response|
        track_array = redis.smembers("tracks").map do |track|
          JSON.parse(track)
        end
        response.body << { tracks: track_array }.to_json
      end

      http.get "/tracks/:user" do |request, response|
        response.body = redis.smembers(:user)
      end

      http.get "/tracks/:genre" do |request, response|
        response.body << redis.smembers(:genre)
      end

      http.get "/tracks/:id" do |request, response|
        response.body = redis.hgetall(:id)
      end

      def find_and_save_track(response)
        track = obtain_spotify_track(response)

        unless track
          message = "Sorry, I couldn't find the Spotify track that you asked for."
        else
          # store all tracks
          redis.sadd("tracks", single_track_json(track, response.user.name))

          # store individual track
          redis.mapped_hmset(track.id, single_track_json(track, response.user.name))

          # store individual track for user, set add
          redis_user_key = response.user.name + track.id
          redis.sadd(redis_user_key, track.id)

          # store individual track for genre. this doesnt' work because apparently last.fm relies on user input which may not be helpful
          redis.sadd(track.album.genres.first, track.id)

          message = "We saved and uploaded your track: #{track.name}"
        end
      end

      Lita.register_handler(Tracker)

      private

      def obtain_spotify_track(response)
        user_input = response.message.body

        Lita::Handlers::Spotifier.find(user_input)
      end

      def single_track_json(track, user)
        track_name = track.name
        artist = track.artists.first.name
        preview_url = track.preview_url
        track_release_date = track.album.release_date
        track_album_name = track.album.name
        track_duration_time = Time.at(track.duration_ms / 1000).utc.strftime("%M:%S")
        images = track.album.images
        track_id = track.id

        {
          user: user,
          track_name: track_name,
          artist: artist,
          preview_url: preview_url,
          track_release_date: track_release_date,
          track_album_name: track_album_name,
          track_duration_time: track_duration_time,
          images: images,
          track_id: track_id
        }.to_json

      end
    end
  end
end
