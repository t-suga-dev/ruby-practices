# frozen_string_literal: true

require 'optparse'

def string_count(file)
  file.count("\n")
end

def word_count(file)
  word = file.split(/\s+/)
  word.size
end

def bite_size(file)
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
      file_name = file.dup
      file = File.read(file)
      string_count += string_count(file)
      word_count += word_count(file)
      bite_size += bite_size(file)
      puts "#{string_count(file).to_s.rjust(8)}#{word_count(file).to_s.rjust(8)}#{bite_size(file).to_s.rjust(8)} #{file_name}"
    end
    puts "#{string_count.to_s.rjust(8)}#{word_count.to_s.rjust(8)}#{bite_size.to_s.rjust(8)} total" if files.size >= 2
  else
    files.each do |file|
      file_name = file.dup
      file = File.read(file)
      string_count += string_count(file)

      puts "#{string_count(file).to_s.rjust(8)} #{file_name}"
    end
    puts "#{string_count.to_s.rjust(8)} total" if files.size >= 2
  end
else
  # パイプがあるときの処理
  input = $stdin.read
  lines = string_count(input)
  words = word_count(input)
  bytes = bite_size(input)
  puts "#{lines.to_s.rjust(8)}#{words.to_s.rjust(8)}#{bytes.to_s.rjust(8)}"
end
