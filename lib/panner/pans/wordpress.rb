class Panner::Pans::Wordpress
  def self.eligible?(url)
    url =~ /^https?:\/\/[^\/]+\.wordpress\.com/
  end

  def initialize(url)
    @agent = Mechanize.new
    @next_url = url
    @page = nil
  end

  def authenticate(options)
  end

  def download
    @page = @agent.get(@next_url)
    puts "got page content"

    if @next_url.nil?
      puts "no more content"
      return
    end
    
    @page.search("article.post").map do |article|
      parse_article(article)
    end
  end

  def next
    link = @page.search("div.nav-links div.nav-previous a").first
    @next_url = link ? link['href'] : nil
    puts "next_url: @next_url"
  end
  
  def parse_article(article)
    out = {}
    out[:title] = article.at_css(".entry-title").text
    out[:body] = Deba.extract(article.at_css(".entry-content").inner_html)
    
    out
  end
end