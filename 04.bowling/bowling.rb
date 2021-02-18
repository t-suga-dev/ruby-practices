score = ARGV[0]
scores = score.split(',')
# 後ろの３投を抜き出す
score_10_frame = scores.slice!(-3, 3)
shots = []
# ストライクがある時は[10, 0]にする
shots = scores.map do |s|
  if s == 'X'
    [10, 0]
  else
    s.to_i
  end
end
# 抜き出していた３投を追加する
shots_10_frame = score_10_frame.map do |s|
  if s == 'X'
    10
  else
    s.to_i
  end
end
shots << shots_10_frame
shots.flatten!
# 9フレームに分ける
frames = []
9.times do |_i|
  frames << shots.slice!(0..1)
end

# 残りの10フレーム目を追加する
frames << shots
point = 0

# スコアの計算
frames.each_with_index do |i, index|
  # 10フレーム目で終了
  return p point += i.sum if index == 9

  # 9投目がストライクの時、10フレーム目の1、２を見る
  point += if i[0] == 10 && index == 8
             i.sum.to_i + frames[1 + index][0].to_i + frames[1 + index][1].to_i
           # ストライクの時、次もストライクの時はその次のフレームを見る
           elsif i[0] == 10 && frames[1 + index][0] == 10
             i.sum.to_i + frames[1 + index][0].to_i + frames[2 + index][0].to_i
           # ストライクの時は次の２投足す
           elsif i[0] == 10
             i.sum.to_i + frames[1 + index][0].to_i + frames[1 + index][1].to_i
           # スペアの時は次の1投足す
           elsif i.sum == 10
             i.sum.to_i + frames[1 + index][0].to_i
           # 通常時
           else
             i.sum
           end
end
