# articlesファイルがいくつあるか数える
@page_num = Dir.open('source/articles').to_a.length - 1

def replace_html_tag(args)
  File.open(args[:write_file_path], "w") do |write_file|
    File.open(args[:read_file_path], "r") do |read_file|
      html = read_file.read
      write_file.puts(
%Q[<% @body_id = "article" %>
<% @page_number = #{@page_num} %>
<% @description = "" %>
<div class="text-content">
        ])
      # 文字列の一部を抜き出し、その中から正規表現で探すことを一行ではできないため、
      # 文字列全体から;から;を抜き出し、タグなどのエスケープ文字を置き換えたら変数に入れておく
      # 次で文字全体から;から;を変数の文字に置き換える
      rewrite_html_escape_char = html.match(/\[(\s|\S)*?\]/).to_s.gsub!(/<br>/, "").gsub!(/[<>"\/\[\]]/, "[" => "", "]" => "", "<" => "&lt;", ">" => "&gt;", '"' => "&quot;", "/" => "&#047;")
      write_file.write(html.gsub(/\[(\s|\S)*?\]/, rewrite_html_escape_char)
                           .gsub(%r@<h2.*?>@, '<div class="text-sub-title"><h2 class="sub-title-border">&nbsp;')
                           .gsub(%r@<marquee>@,    '<pre class="prettyprint linenums"><code>')
                           .gsub(%r@</h1>@,   "</h1></div>")
                           .gsub(%r@</h2>@,   "</h2></div>")
                           .gsub(%r@</marquee>@,   "</code></pre>"))
      write_file.puts(%Q[</div>])
    end
  end
end

replace_html_tag(
  :write_file_path => "/Users/chika/Documents/my_site_temp/source/articles/page#{@page_num}.html.erb",
  # :write_file_path => "/Users/chika/Documents/test-file/ruby-src/x.html.erb",
  :read_file_path  => "/Users/chika/Documents/my_site_temp/read.html",
)
