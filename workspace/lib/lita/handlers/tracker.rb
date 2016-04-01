require './lib/lita/spotifier'
require 'redis'

module Lita
  module Handlers
    class Tracker < Handler
      route(/\Ahttps?:\/\/open\.spotify\.com\/track\/(\w+)/i, :find_and_save_track, command: false, help: {
        '/\Ahttps?:\/\/open\.spotify\.com\/track\/(\w+)/i' => 'uploads your track and related info up to the BlueApron music site'
      })

      route(/hi/) do |response|

      end

      def find_and_save_track(response)
        track = obtain_spotify_track(response)

        unless track
          message = "Sorry, I couldn't find the Spotify track that you asked for."
        else
          redis_track_key = response.user.name + track.id
          # individual track key stored
          db_connection.mapped_hmset(redis_track_key, single_track_json(track))

          # store for all users using set add
          db_connection.sadd(response.user, redis_track_key)

          # store for genre this doesnt' work because apparently last.fm relies on user input which may not be helpful
          db_connection.sadd(track.album.genres.first, redis_track_key)

          message = "We saved and uploaded your track: #{track.name}"
        end
      end

      Lita.register_handler(Tracker)

      private

      def db_connection
        $redis ||= Redis.new
      end

      def obtain_spotify_track(response)
        user_input = response.message.body

        Lita::Handlers::Spotifier.find(user_input)
      end

      def single_track_json(track)
        track_name = track.name
        preview_url = track.preview_url
        track_album = track.album
        track_album_name = track.album.name
        track_duration_time = Time.at(track.duration_ms / 1000).utc.strftime("%M:%S")

        {
          track_name: track_name,
          preview_url: preview_url,
          track_album: track_album,
          track_album_name: track_album_name,
          track_duration_time: track_duration_time
        }

      end
    end
  end
end
