# frozen_string_literal: true

require 'etc'
require 'optparse'

# lオプションがないときの処理
def max_word_count(files)
  # 要素の中で一番大きい文字数を持つものを抽出
  max_element = files.map(&:length).max

  files.map do |element|
    element.ljust(max_element)
  end
end

COLUMN_COUNT = 3
def process_ls(files)
  file_count = files.count

  # 要素の数をもとに一列にいくつの要素が並ぶかを計算
  column = (file_count.to_f / COLUMN_COUNT).ceil

  sliced_files = max_word_count(files).each_slice(column).to_a

  blank_count = sliced_files[0].length - sliced_files[COLUMN_COUNT - 1].length
  blank_count.times do
    sliced_files[COLUMN_COUNT - 1] << ''
  end

  sliced_files.transpose.each do |element|
    puts element.join('  ')
  end
end

# lオプションがあるときの処理
def block_size(files)
  files.sum { |file| File.stat(file).blocks }
end

def file_type(ftype)
  ftype == 'file' ? '-' : 'd'
end

def file_details(file)
  file_type(file.ftype)
end

# パーミッション識別のためにファイルモードにして８進数にする
def octal(file)
  file.mode.to_s(8)
end

def owner(file)
  permission_judge(octal(file)[-3].to_i)
end

def group(file)
  permission_judge(octal(file)[-2].to_i)
end

def other(file)
  permission_judge(octal(file)[-1].to_i)
end

# パーミッションをつなげる
def permission(file)
  "#{owner(file)}#{group(file)}#{other(file)}"
end

# パーミッション置き換え
def permission_judge(octal)
  case octal
  when 0
    '---'
  when 1
    '--x'
  when 2
    '-w-'
  when 3
    '-wx'
  when 4
    'r--'
  when 5
    'r-x'
  when 6
    'rw-'
  else
    'rwx'
  end
end

def hard_link(file)
  file.nlink
end

def user_name(file)
  Etc.getpwuid(file.uid).name
end

def group_name(file)
  Etc.getgrgid(file.gid).name
end

def byte_size(file)
  file.size
end

def time(file)
  file.ctime.strftime('%-m %e %R')
end

# 最終的なlオプションの結果を表示
def process_ls_l(files)
  puts "total #{block_size(files)}"
  files.each do |file|
    stat = File.stat(file)
    puts "#{file_details(stat)}#{permission(stat)}  #{hard_link(stat)}  #{user_name(stat)}   #{group_name(stat)}  #{byte_size(stat)}  #{time(stat)}  #{file}"
  end
end

# 処理開始
option = ARGV.getopts('l', 'a', 'r')
files =
  if option['a']
    Dir.glob('*', File::FNM_DOTMATCH).sort
  else
    Dir.glob('*').sort
  end

files.reverse! if option['r']

if option['l']
  process_ls_l(files)
else
  process_ls(files)
end
