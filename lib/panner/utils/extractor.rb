class Panner::Utils::Extractor
  #These tags should be recursively replaced by their contents and the resulting content appended to the current paragraph
  CONFORMING_TEXT_TAGS = %w(a abbr b bdi bdo cite code command datalist del dfn em i img ins kbd label mark math meter noscript output q ruby s samp small span strong sub sup textarea time var wbr)
  NONCONFORMING_TEXT_TAGS = %w(acronym big center dir font listing plaintext spacer strike tt u xmp)
  TEXT_TAGS = CONFORMING_TEXT_TAGS + NONCONFORMING_TEXT_TAGS

  HEADING_TAGS = %w(h1 h2 h3 h4 h5 h6)

  BLOCK_PASSTHROUGH_TAGS = %w(div dl form ol table tbody thead tfoot tr ul)

  BLOCK_INITIATING_TAGS = %w(article aside body blockquote dd dt header li nav p pre section td th ul)

  BLOCK_PLAIN_TEXT_TAGS = %w(pre plaintext listing xmp)

  ENHANCERS = { %w(b strong) => "*", %(i em) => "_" }
  
  def initialize(text)
    @doc = Nokogiri::HTML(text)
    @current_text_run = ""

    @text = ""
  end
  
  def extract
    process(@doc.root)
    
    @text << normalise(@current_text_run)
    @current_text_run = ""
    @just_appended_br = false
    
    @text
  end

  def process(node)
    node_name = node.name.downcase

    return if node_name == 'head'

    if node.text?
      @current_text_run << node.inner_text unless normalise(node.inner_text) == ''

      return
    end

    #Handle repeated brs by making a paragraph break
    if node_name == 'br'
      @text << normalise(@current_text_run) << "\n"
      @current_text_run = ""

      return
    end

    #These tags terminate the current paragraph, if present, and start a new paragraph
    if BLOCK_INITIATING_TAGS.include?(node_name)
      node.children.each { |n| process(n) }

      @text << normalise(@current_text_run) << "\n\n"
      @current_text_run = ""

      return
    end
    
    if ENHANCERS.keys.flatten.include?(node_name)
      ENHANCERS.each_pair do |tags, nsf_rep|
        if tags.include?(node_name)
          @current_text_run << nsf_rep
          node.children.each { |n| process(n) }
          @current_text_run << nsf_rep
        end
      end

      return
    end
    
    if HEADING_TAGS.include?(node_name)
      node.children.each { |n| process(n) }

      @text << "#{"#" * node_name[1..-1].to_i} #{normalise(@current_text_run)}\n\n" unless normalise(@current_text_run) == ''
      @current_text_run = ""

      return
    end

    #Pretend that the children of this node were siblings of this node (move them one level up the tree)
    node.children.each { |n| process(n) }
  end
  
  def normalise(string)
    string.gsub(/[\f\n\r\t\v ]+/, ' ').gsub(/\A[\f\n\r\t\v ]+/, '').gsub(/[\f\n\r\t\v ]+\Z/, '')
  end
end