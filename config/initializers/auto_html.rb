require "auto_html"

AutoHtml.add_filter(:sized_image).with(:width => 200, :height => 200) do |text, options|

  text.gsub(/htt(p|ps):\/\/.+\.(jpg|jpeg|bmp|gif|png)(\?\S+)?/i) do |match|
    width = options[:width]
    height= options[:height]
    %|<img src="#{match}" alt="" width="#{width}" height="#{height}" />|
  end
end
