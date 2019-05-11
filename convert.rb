# 指定ディレクトリの全ファイルの特定文字列を置き換えるスクリプト

dir_path = "/Users/chika/Documents/my_site_temp/source/articles/"

Dir.glob("#{dir_path}*.html.erb") do |path|

  File.open(path, 'r') do |r|
    html = r.read
    @str = html.gsub!(%r@<div class="text-content">@, '')
    # ファイルの最後のdivを消したいので
    div_len = html.scan(%r@</div>@).length
    ct = 0
    @str = html.gsub(%r@</div>@) do |match_char|
      ct += 1
      # 最後の要素なら空文字に、そうでなければ同じ文字を返してそれに置き換える。
      ct == div_len ? '' : match_char
    end
  end

  # ファイルの上書きはw指定のwriteのみで可能なため新規で開く
  File.open(path, 'w') do |w|
    w.write(@str)
  end
end
