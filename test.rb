class Test
  def initialize(args)
    @write_file_path = args[:write_file_path]
    @read_file_path  = args[:read_file_path]
    page_num = Dir.open('source/articles').to_a.length - 1
    @head = <<~USAGE
      <% @body_id = "article" %>
      <% @page_number = #{page_num} %>
      <% @description = "" %>
    USAGE
  end

  def html_escape(html)
    # 文字列の一部を抜き出し、その中から正規表現で探すことを一行ではできないため、
    # 文字列全体から[から]を抜き出し、タグなどのエスケープ文字を置き換えたら変数に入れておく
    # 次で文字全体から[から]を変数の文字に置き換える
    loop do
      if html.match(/\[(\s|\S)*?\]/)
        # マッチした文字列を変換
        html_match = html.match(/\[(\s|\S)*?\]/).to_s.gsub(/<br>/, "")
          .gsub!(/[<>"\/\[\]]/, "[" => "", "]" => "", "<" => "&lt;", ">" => "&gt;", '"' => "&quot;", "/" => "&#047;")
        # 変換した文字列を適用
        html = html.sub!(/\[(\s|\S)*?\]/, html_match)
      else
        break
      end
    end
    html
  end

  def replace_html_tag
    File.open(@write_file_path, "w") do |write_file|
      File.open(@read_file_path, "r") do |read_file|
        html = read_file.read
        write_file.puts(@head)
        rewrite_html_escape_char = html_escape(html)
        write_file.write(html.gsub(/\[(\s|\S)*?\]/, rewrite_html_escape_char)
         .gsub(%r@<h2.*?>@,    %Q[<div class="text-sub-title"><h2 class="sub-title-border">&nbsp;])
         .gsub(%r@<marquee>@,  %Q[<div class="language-tag"><B>▼</B></div><pre class="prettyprint linenums"><code>])
         .gsub(%r@</h1>@,      %Q[</h1></div>])
         .gsub(%r@</h2>@,      %Q[</h2></div>])
         .gsub(%r@</marquee>@, %Q[</code></pre>])
         .gsub(%r@<h3.*?>@,    %Q[<h3>]))
      end
    end
  end

end
Test.new(
  write_file_path: "/Users/chika/Documents/my_site_temp/test.html",
  read_file_path:  "/Users/chika/Documents/my_site_temp/read.html",
).replace_html_tag
