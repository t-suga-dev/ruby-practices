require 'date'

# コマンドライン引数があるかどうか
dates = Date.today
if ARGV[0] == "-y" && ARGV[2] == "-m"
  dates = Date.new(ARGV[1].to_i, ARGV[3].to_i)
elsif ARGV[0] == "-y"
  dates = Date.new(ARGV[1].to_i, dates.month) 
elsif ARGV[0] == "-m"
  dates = Date.new(dates.year, ARGV[1].to_i)
else ARGV[0] == nil or /.*/
  dates
end

# カレンダー上部の月、年、曜日を表示
print ("      #{dates.month}月 ")
puts dates.year
puts (" 日 月 火 水 木 金 土")


# 月の最終日を取得
last_day = Date.new(dates.year, dates.month, -1)
# 月の初日を取得
first_day = Date.new(dates.year, dates.month, 1)

# 最初の週の曜日と日付の位置を合わせる設定
if first_day.wday == 0
  print ""
elsif
  first_day.wday == 1
  print "   "
elsif
  first_day.wday == 2
  print "      "
elsif
  first_day.wday == 3
  print "         "
elsif
  first_day.wday == 4
  print "            "
elsif
  first_day.wday == 5
  print "               "
elsif
  first_day.wday == 6
  print "                  "
end

# その月の日数を計算
days = [*first_day..last_day]

# 土曜日が来る毎に折り返し表示する、日にちが一桁のところは空白を入れる
days.each do |i|
  if i.wday == 6 && i.day.to_s.length == 1
    puts ("  #{i.day}")
  elsif i.day.to_s.length == 1
    print ("  #{i.day}")
  elsif i.wday == 6
    puts (" #{i.day}")
  else
    print (" #{i.day}")
  end
end