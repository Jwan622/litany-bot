=begin

loop through all track objects then:

This is the info to release to the api.
spotify_track = RSpotify::Track.find(track_id)
spotfiy_track.preview_url
spotfiy_track.name
spotfiy_track.album
spotfiy_track.album.name
track_duration_time = Time.at(spotify_track.duration_ms / 1000).utc.strftime("%M:%S")

full_track_json_url = spotify_track.href

=end
