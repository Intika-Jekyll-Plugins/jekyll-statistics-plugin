require 'date' #needed to do date stuff
module Jekyll
  class RenderTotalWords < Liquid::Tag

    def render(context)
    	#reg-ex to strip html
      re = /<("[^"]*"|'[^']*'|[^'">])*>/

	#init vars
      no_of_words = 0
      no_of_days_writing = 0
      no_of_posts = 0
      no_of_words_per_day_written = 0

	#NOTE: change the value of the parameter date for date_start to the date you actually started. Look up the date you first published your very first post, if that helps. I remember starting to write, and publish daily since the start of this year. Hence 1-1-2015.
      date_start = Date.new(2015,1,1)
      date_end = DateTime.now

	#calculate the number of days since the blog has started based on date_start and date_end
      no_of_days_writing = date_end - date_start
      no_of_days_writing = no_of_days_writing.to_i

      #fetch all the posts from the site object, using context.registers since we're essentially creating a custom tag
      posts = context.registers[:site].posts

	#calculate the approximate number of words written in the entire blog. Using posts, and not pages.
       posts.each do |post|
        stripped_post = post.content.gsub(re,''); #strip html tags using re above.
        no_of_words += stripped_post.gsub(/[^-a-zA-Z]/, ' ').split.size #calculate, and add the number of words.
        no_of_posts += 1 #calculate the total no of posts, all posts.
      end

	#calculate the approximate, average no of words written, and published on this blog, per day.
      no_of_words_per_day_written = (no_of_words / no_of_posts).to_i

	##print it out as a string - feel free to customise this to your hearts content.
      "<strong>~#{no_of_words}</strong>  Words Written In All Posts. <br><br> <strong>~#{no_of_days_writing}</strong>  Days Since The Start Of This Blog. <br><br> <strong>~#{no_of_posts}</strong> Posts Published Here, So Far.  <br><br> <strong>~#{no_of_words_per_day_written}</strong> Avg Words Written Per Day For This Blog. "
    end
  end #class ends here
end #module ends here

#register the custom template tag.
Liquid::Template.register_tag('content_statistics', Jekyll::RenderTotalWords)
