#!/usr/bin/env ruby

require 'rubygems'
require 'cgi'
require 'RMagick'
require 'scrobbler2'

@sig = Magick::ImageList.new("/home/jason/bin/images/lastbg.png")
@text = Magick::Draw.new
@font = "/usr/share/fonts/mikachan-font-ttf/mikachan.ttf"

def annotate(str, xoff, yoff, size = 16, font = @font)
	@text.annotate(@sig, 0, 0, xoff, yoff, CGI.unescapeHTML(str)) do
		self.pointsize = size
		self.font = font
		self.stroke = 'transparent'
		self.fill = '#FFFFFF'
	end
end

y = 48

user = Scrobbler2::User.new('VxJasonxV')
#user.api_key = 'g3ty0ur0wn'
#user.api_secret = 'th1s12'

if user.recent_tracks["track"][0]["@attr"] #["nowplaying"]
	t = user.recent_tracks["track"][0]
	annotate("Now Playing:", 4, y + 3, 20)
	annotate("\"#{t["name"]}\"", 4, y * 2 - (y / 2), 18)
	annotate("by #{t["artist"]["#text"]}", 4, y * 2 - 3, 18)
	if !t["album"]["#text"].empty?
		annotate("from #{t["album"]["#text"]}", 4, y * 2 + 18, 18)
	end
else
	user.recent_tracks["track"][0..2].each do |t|
		if t["name"].empty?
			break
		end
		annotate("\"#{t["name"]}\" by #{t["artist"]["#text"]}", 4, y)
		annotate('@ ' + Time.at(t["date"]["uts"].to_i).strftime('%a, %b %d, %I:%M %p %z'), 14, y + 18, 12)
		y += 38
	end
end

annotate('Y', 465, 30, 10, '/usr/share/fonts/corefonts/webdings.ttf')

@sig.write("/home/jason/public_html/images/lastfm.png")
