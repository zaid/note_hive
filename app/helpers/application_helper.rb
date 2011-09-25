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
end
