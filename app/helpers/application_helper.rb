module ApplicationHelper
  
  # Return a title on a per-page basis.
  def title
    base_title = 'NoteHive'

    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end

  def markdown(text)
    options = [:hard_wrap, :filter_html, :autolink, :no_intraemphasis]
    Redcarpet.new(text, *options).to_html.html_safe
  end

  def shorten_text(text, maximum_length = 70)
    return "#{text[0..maximum_length]}..." unless text.length < maximum_length
    text
  end
end
