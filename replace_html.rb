@page_num = 13
def replace_html_tag(args)
  File.open(args[:write_file_path], "w") do |write_file|
    File.open(args[:read_file_path], "r") do |read_file|
      html = read_file.read
      write_file.puts(%Q[<% @body_id = "article" %>
<% @page_number = #{@page_num} %>
<% @description = "" %>
<div class="text-content">
        ])
      write_file.write(html.gsub(%r@<h2.*?>@, '<div class="text-sub-title"><h2 class="sub-title-border">&nbsp;')
                           .gsub(%r@<marquee>@, '<pre class="prettyprint linenums"><code>')
                           .gsub(%r@</h1>@, "</h1></div>")
                           .gsub(%r@</h2>@, "</h2></div>")
                           .gsub(%r@</marquee>@, "</code></pre>"))
      write_file.puts(%Q[</div>])
    end
  end
end

replace_html_tag(
  :write_file_path => "/Users/chika/Documents/my_site_temp/source/articles/page#{@page_num}.html.erb",
  :read_file_path  => "/Users/chika/Documents/my_site_temp/read.html",
)
