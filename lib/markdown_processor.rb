class MarkdownProcessor < Struct.new(:content)
  def has_explicit_slides?
    content =~ /^\<?!SLIDE/m
  end

  def processed_content
    autoslide
  end

  def slides
    content.split(/^<?!SLIDE/).delete_if(&:empty?)
  end

  private

  def autoslide
    if has_explicit_slides?
      content
    else
      content.gsub(/^# /m, "<!SLIDE bullets>\n# ")
    end
  end
end
