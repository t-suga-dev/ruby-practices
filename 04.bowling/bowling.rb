# frozen_string_literal: true

# コマンドライン引数を取得する
result = ARGV[0]
shots = result.split(',')
# Xを10に置き換える
scores = shots.map { |shot| shot == 'X' ? 10 : shot.to_i }
frame_result = []
frames = []
frame_count = 1
# 10フレームに分ける
scores.each do |score|
  frame_result << score
  if frame_count < 10
    if frame_result[0] == 10 || frame_result.length == 2
      frames << frame_result
      frame_result = []
      frame_count += 1
    end
  elsif frame_count == 10
    frames << frame_result
    frame_count += 1
  end
end

point = 0
# スコアの計算
frames.each_with_index do |frame, index|
  # 10フレーム目で終了
  return puts point += frame.sum if index == 9

  # 9投目がストライクの時、10フレーム目の1、２を見る
  point += if frame[0] == 10 && index == 8
             frame.sum + frames[1 + index][0] + frames[1 + index][1]
           # ストライクの時、次もストライクの時はその次のフレームを見る
           elsif frame[0] == 10 && frames[1 + index][0] == 10
             frame.sum + frames[1 + index][0] + frames[2 + index][0]
           # ストライクの時は次の２投足す
           elsif frame[0] == 10
             frame.sum + frames[1 + index][0].to_i + frames[1 + index][1]
           # スペアの時は次の1投足す
           elsif frame.sum == 10
             frame.sum + frames[1 + index][0]
           # 通常時
           else
             frame.sum
           end
end
