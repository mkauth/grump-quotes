API_KEY = "AIzaSyD2vvpQb0YZSbFlkV_nNa0GtGe9c4i2T1A"

Thread.new do
	
	

	while true do  #main while loop. each pass checks for and adds new videos
		nextPageToken=String.new
		more_pages=true
		more_new_videos = true
		count=0
		begin
			Episode.transaction do #bulk episode is transaction to avoid problems with updating algorithm
				while more_pages and more_new_videos do  #if there are more result pages and more videos to add then keep going
					#we can only get a maximum of 50 results per request page
					
					#build request url
					request_url = "https://www.googleapis.com/youtube/v3/playlistItems?"\
									"part=contentDetails"\
									"&maxResults=50"\
									"&pageToken=#{ nextPageToken }"\
									"&playlistId=UU9CuvdOVfMPvKCiwdGKL3cQ"\
									"&fields=items%2FcontentDetails%2FvideoId%2CnextPageToken"\
									"&key=#{ API_KEY }"
					
					#send request
					response = Net::HTTP.get(URI.parse(request_url))

					#convert response string into hash
					data = JSON.parse(response)
					data["items"].each do |i|
						video = Episode.find_by(video_id: i["contentDetails"]["videoId"])
						if video == nil
							#video not in database so add it and move onto next
							add_video(i["contentDetails"]["videoId"])
						else
							#video is in database. We can assume all videos after this one are also in database
							#so we don't need to check any more right now
							more_new_videos = false
							break
						end
					end
					
					nextPageToken=data["nextPageToken"]
					if nextPageToken == nil
					#if nextPageToken is nil then we are at the last page of results
						more_pages = false
					end
				end
			end
		rescue
			retry
		end
		puts "transaction complete"
		#calculates time till next video upload then sleep for that time
		current = Time.now
		time_value = current.hour * 10000 + current.min * 100 + current.sec
		remaining = 0
		if time_value < 120000
			remaining = 120000 - time_value
		elsif time_value < 140000
			remaining = 140000 - time_value
		elsif time_value < 160000
			remaining = 160000 - time_value
		else
			remaining = 240000 - time_value + 120000
		end
			
		sleep((remaining/10000).hours)
		sleep((remaining%10000/100).minutes)
		sleep((remaining%100).seconds)
	end
end


def add_video(video_id)
	request_url = "https://www.googleapis.com/youtube/v3/videos?"\
					"part=snippet%2C+contentDetails"\
					"&id=#{video_id}"\
					"&fields=items(contentDetails%2Fduration%2Csnippet(title%2Cthumbnails%2Fdefault))"\
					"&key=#{ API_KEY }"
	
	response = Net::HTTP.get(URI.parse(request_url))
	data = JSON.parse(response)
	video_title = data["items"][0]["snippet"]["title"]
	duration = data["items"][0]["contentDetails"]["duration"][2..-1]
	thumbnail = data["items"][0]["snippet"]["thumbnails"]["default"]["url"]
	#checking if video title is of the form "gameTitle - episodeTitle - Part # - showName" where the gameTitle has a :
	title_parts1 = /\A(?<game>.+:.+)\s-\s(?<title>.+)\s-\s(?<part>.+)\s?-\s(?<show>.+)/.match(video_title)
	#checking if video title is of the form "gameTitle: episodeTitle - Part # - showName"
	title_parts2 = /\A(?<game>.+):\s(?<title>.+)\s-\s(?<part>.+)\s?-\s(?<show>.+)/.match(video_title)
	#checking if video title is of the form "gameTitle - episodeTitle - Part # - showName"
	title_parts3 = /\A(?<game>.+)\s-\s(?<title>.+)\s-\s(?<part>.+)\s?-\s(?<show>.+)/.match(video_title)
	#checking if video title is of the form "gameTitle - episodeTitle/Part# - showName"
	title_parts4 = /\A(?<game>.+)\s-\s(?<title_part>.+)\s?-\s(?<show>.+)/.match(video_title)
	#checking if video title is of the form "gameTitle - showName"
	title_parts5 = /\A(?<game>.+)\s?-\s(?<show>.+)/.match(video_title)
	#do this because some videos have show name of "GameGrumps"
	#we don't want this show name to be interpreted as different than "Game Grumps"
	
	
	
	
	
	if title_parts1 != nil
		#check if video title contains a game grumps show name
		show = title_parts1[:show]
		if show == "GameGrumps"
			show = "Game Grumps"
		elsif show.include? "Grumpcade"
			show = "Grumpcade"
		elsif show.include? "Steam Train"
			show = "Steam Train"
		end
		#do this to make sure this video is an episode
		if contains_show_name(title_parts1[:show])
			#this is an episode so add it to the database
			Episode.create(video_id: video_id, 
							game: title_parts1[:game],
							title: title_parts1[:title],
							show: show,
							part: title_parts1[:part],
							duration: duration,
							thumbnail_url: thumbnail)
		else
		#video is not an episode so don't add it
		Rejected.create(name: video_title)
		end
	elsif title_parts2 != nil
		#check if video title contains a game grumps show name
		
		show = title_parts2[:show]
		if show == "GameGrumps"
			show = "Game Grumps"
		elsif show.include? "Grumpcade"
			show = "Grumpcade"
		elsif show.include? "Steam Train"
			show = "Steam Train"
		end
		#do this to make sure this video is an episode
		if contains_show_name(title_parts2[:show])
			#this is an episode so add it to the database
			Episode.create(video_id: video_id, 
							game: title_parts2[:game],
							title: title_parts2[:title],
							show: show,
							part: title_parts2[:part],
							duration: duration,
							thumbnail_url: thumbnail)
		else
		#video is not an episode so don't add it
		Rejected.create(name: video_title)
		end
	elsif title_parts3 != nil
		#check if video title contains a game grumps show name
		show = title_parts3[:show]
		if show == "GameGrumps"
			show = "Game Grumps"
		elsif show.include? "Grumpcade"
			show = "Grumpcade"
		elsif show.include? "Steam Train"
			show = "Steam Train"
		end
		#do this to make sure this video is an episode
		if contains_show_name(title_parts3[:show])
			#this is an episode so add it to the database
			Episode.create(video_id: video_id, 
							game: title_parts3[:game],
							title: title_parts3[:title],
							show: show,
							part: title_parts3[:part],
							duration: duration,
							thumbnail_url: thumbnail)
			return
		else
		#video is not an episode so don't add it
		Rejected.create(name: video_title)
		end
	elsif title_parts4 != nil
		#check if video title contains a game grumps show name
		show = title_parts4[:show]
		if show == "GameGrumps"
			show = "Game Grumps"
		elsif show.include? "Grumpcade"
			show = "Grumpcade"
		elsif show.include? "Steam Train"
			show = "Steam Train"
		end
		#do this to make sure this video is an episode
		if contains_show_name(title_parts4[:show])
			#this is an episode so add it to the database
			Episode.create(video_id: video_id, 
							game: title_parts4[:game],
							title: title_parts4[:title_part],
							show: show,
							part: title_parts4[:title_part],
							duration: duration,
							thumbnail_url: thumbnail)
		else
		#video is not an episode so don't add it
		Rejected.create(name: video_title)
		end
	elsif title_parts5 != nil
		#check if video title contains a game grumps show name
		show = title_parts5[:show]
		if show == "GameGrumps"
			show = "Game Grumps"
		elsif show.include? "Grumpcade"
			show = "Grumpcade"
		elsif show.include? "Steam Train"
			show = "Steam Train"
		end
		#do this to make sure this video is an episode
		if contains_show_name(title_parts5[:show])
			#this is an episode so add it to the database
			Episode.create(video_id: video_id, 
							game: title_parts5[:game],
							show: show,
							duration: duration,
							thumbnail_url: thumbnail)
		else
		#video is not an episode so don't add it
		Rejected.create(name: video_title)
		end
	else
		#video is not an episode so don't add it
		Rejected.create(name: video_title)
	end
end

def contains_show_name(title_part)
	#list of all the different game grumps show names
	show_names = ["Game Grumps", "Steam Train", "Grumpcade", "Steam Rolled", "Game Grumps VS", "Guest Grumps", "GameGrumps"]
	
	show_names.each do |show_name|
		if title_part.include? show_name
			return true
		end
	end
	return false
end

