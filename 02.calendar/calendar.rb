require 'date'

# コマンドライン引数があるかどうか
dates = Date.today
if ARGV[0] == "-y" && ARGV[2] == "-m"
  dates = Date.new(ARGV[1].to_i, ARGV[3].to_i)
elsif ARGV[0] == "-y"
  dates = Date.new(ARGV[1].to_i, dates.month) 
elsif ARGV[0] == "-m"
  dates = Date.new(dates.year, ARGV[1].to_i)
else ARGV[0] == nil
  dates
end

# カレンダー上部の月、年、曜日を表示
puts ("      #{dates.month}月 ") + "#{dates.year}"
puts (" 日 月 火 水 木 金 土")


# 月の最終日を取得
last_day = Date.new(dates.year, dates.month, -1)
# 月の初日を取得
first_day = Date.new(dates.year, dates.month, 1)

# 最初の週の曜日と日付の位置を合わせる設定
first_day.wday.times do |i|
  print "   "
end 

# その月の日数を計算
days = [*first_day..last_day]

# 土曜日が来る毎に折り返し表示する
days.each do |i|
  if i.wday == 6
    puts (" #{i.day.to_s.rjust(2)}")
  else
    print (" #{i.day.to_s.rjust(2)}")
  end
end