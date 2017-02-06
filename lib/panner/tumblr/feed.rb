class Panner::Tumblr::Feed
  attr_reader :posts

  def initialize(package, url)
    url =~ /^https?:\/\/(.*?).tumblr.com/
    @username = $1
    @index = 1

    @package = package
  end

  def scrape
    loop { break unless next_page }
  end

  def next_page
    new_posts = scrape_page(@package.agent.get(url))
    @index += 1
    new_posts.length > 0
  end

  def scrape_page(page)
    page.search("article[data-post-id]").map do |post|
      scrape_post(post)
    end
  end

  def scrape_post(post_node)
    post = Panner::Tumblr::Post.new(@package, post_node)
    post.scrape
    post
  end

  def url
    if @index == 1
      "https://#{@username}.tumblr.com/"
    else
      "https://#{@username}.tumblr.com/page/#{@index}"
    end
  end
end