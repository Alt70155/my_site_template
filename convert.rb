# 任意の名前のファイルの特定文字列を一括で置き換えるRubyスクリプト

def batch_str_replace(args)
  Dir.glob("#{args[:dir_path]}#{args[:file_name_to_replace]}") do |file_path|
    # readモードでファイルを開く
    File.open(file_path, 'r') do |r|
      read_file = r.read
      @str = read_file.gsub(args[:before_replace_regexp], args[:after_replace_str])
    end

    # ファイルの上書きはw指定のwriteのみで可能なため新規で開く
    File.open(file_path, 'w') do |w|
      w.write(@str)
    end
  end
end

batch_str_replace(
  dir_path:              "/Users/chika/Documents/test-file/html-src/",
  file_name_to_replace:  "step*.html",
  before_replace_regexp: %r[], # 正規表現
  after_replace_str:     "no"
)


# before_replace_regexpで指定した文字列が複数ある場合、全て置き換えます。
# 指定した文字列を一つだけ置き換えたい場合は6行目のgsubをsubにすれば可能です。
