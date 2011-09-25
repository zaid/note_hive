module NotesHelper
  
  def make_title(text)
    return "#{text[0..70]}..." unless text.length < 70 
    text
  end
end
