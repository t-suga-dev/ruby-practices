# frozen_string_literal: true

require 'optparse'

# 行数を数える(パイプなし)
def string_count(file)
  File.read(file).count("\n")
end

# 単語を数える(パイプなし)
def word_count(file)
  files = File.read(file)
  word = files.split(/\s+/).size
  word.size
end

# バイト数を数える(パイプなし)
def bite_size(file)
  File.stat(file).size
end

# 行数を数える(パイプあり)
def pipe_string_count(file)
  file.count("\n")
end

# 単語数を数える(パイプあり)
def pipe_word_count(file)
  word = file.split(/\s+/)
  word.size
end

# バイト数を数える(パイプあり)
def pipe_load_bytes(file)
  file.bytesize
end

# 処理開始
# パイプがあるかどうかを判定
if File.pipe?($stdin) == false
  option = ARGV.getopts('l')
  files = ARGV
  string_count = 0
  word_count = 0
  bite_size = 0
  if option['l'] == false
    files.each do |file|
      string_count += string_count(file)
      word_count += word_count(file)
      bite_size += bite_size(file)
      puts "#{string_count(file).to_s.rjust(8)}#{word_count(file).to_s.rjust(8)}#{bite_size(file).to_s.rjust(8)} #{file}"
    end
    puts "#{string_count.to_s.rjust(8)}#{word_count.to_s.rjust(8)}#{bite_size.to_s.rjust(8)} total" if files.size >= 2
  else
    files.each do |file|
      string_count += string_count(file)

      puts "#{string_count(file).to_s.rjust(8)} #{file}"
    end
    puts "#{string_count.to_s.rjust(8)} total" if files.size >= 2
  end
else
  # パイプがあるときの処理
  input = $stdin.read
  lines = pipe_string_count(input)
  words = pipe_word_count(input)
  bytes = pipe_load_bytes(input)
  puts "#{lines.to_s.rjust(8)}#{words.to_s.rjust(8)}#{bytes.to_s.rjust(8)}"
end
