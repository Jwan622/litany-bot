require './spotifier'

module Lita
  module Handlers
    class Spotify< Handler
      route(/\Ahttps?:\/\/open\.spotify\.com\/track\/(\w+)/i, :find_and_save_track, command: true, help: {
        'db' => 'uploads your track and related info up to the BlueApron music site'
      })

      def find_and_save_track(response)
        found_track = Lita::Handlers::Spotifier.find


        if resp.contents.empty?
          message = "Sorry, I couldn't find the Spotify track that you asked for."
        else
          message = "We saved and uploaded your track: #{found_track.name}"
        end

        #persist track to db_connection
        response.reply_privately(message)
      end

      private

      def db_connection
        # @db = #open connection
      end
    end
  end
end
