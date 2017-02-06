class Panner::Tumblr::Post
  attr_reader :id, :image_urls, :html, :text

  def initialize(package, node)
    @package = package
    @node = node
  end

  def scrape
    @id = @node['data-post-id']

    post_content = @node.search(".post-content").first

    @html = post_content.to_html
    @text = Deba.extract(@html)

    @dependent_urls = []

    iframe = post_content.at("iframe")
    scrape_images(@package.agent.get(iframe['src'])) if iframe

    scrape_images(post_content)

    scrape_dependencies

    @package.add("#{@id}.json", serialize.to_json)
  end

  def serialize
    {
      id: @id,
      html: @html,
      text: @text,
      dependent_urls_map: @dependent_urls_map
    }
  end

  def scrape_images(container)
    images = container.search("img").reject { |image| image.matches?(".avatar img") }
    @dependent_urls.concat(images.map { |image| image['src'] })
  end

  def scrape_dependencies
    @dependent_urls_map = {}

    @dependent_urls.each do |url|
      begin
        file_saver = @package.agent.get(url)
        @dependent_urls_map[url] = file_saver.filename
      rescue Exception => e
        puts "#{e.message}"
      end
    end
  end
end