def replace_html_tag(args)
  File.open(args[:write_file_path], "w") do |write_file|
    File.open(args[:read_file_path], "r") do |read_file|
      html = read_file.read
      page_num = 11
      write_file.puts(%Q[<%= partial "article_info" %>
<% @body_id = "article" %>
<% @title = @article_contents[#{page_num}][0] %>
<% @posted_date = "投稿日：\#{@article_contents[#{page_num}][1]}" %>
<% @page_number = "page\#{@article_contents[#{page_num}][2]}" %>

<div class="text-content">
        ])
      write_file.write(html.gsub(%r@<h1.*?>.*<@, '<div class="text-title"><h1><%= @title %><')
                           .gsub(%r@<h2.*?>@, '<div class="text-sub-title"><h2 class="sub-title-border">&nbsp;')
                           .gsub(%r@<marquee>@, '<pre class="prettyprint linenums"><code>')
                           .gsub(%r@</h1>@, "</h1></div>")
                           .gsub(%r@</h2>@, "</h2></div>")
                           .gsub(%r@</marquee>@, "</code></pre>"))
      write_file.puts(%Q[</div>])
    end
  end
end

replace_html_tag(
  :write_file_path => "/Users/chika/Documents/my_site_temp/source/articles/page12.html.erb",
  :read_file_path  => "/Users/chika/Documents/my_site_temp/read.html",
)
