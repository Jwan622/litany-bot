require 'rspotify'

module Lita
  module Handlers
    class Spotifier
      def self.find(url)
        url_regex = /https?:\/\/open\.spotify\.com\/track\/(\w+)/
        track_id = url_regex.match(url)[1]

        RSpotify::Track.find(track_id)
      end
    end
  end
end
