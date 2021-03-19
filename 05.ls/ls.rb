# frozen_string_literal: true

require 'etc'
require 'optparse'

def max_word_count(file_names)
  max_element = file_names.max_by(&:length).length

  file_names.map do |element|
    element.ljust(max_element)
  end
end

COLUMN_COUNT = 3
def process_ls(file_names)
  file_count = file_names.count

  column = (file_count.to_f / COLUMN_COUNT).ceil

  sliced_files = max_word_count(file_names).each_slice(column).to_a

  blank_count = sliced_files[0].length - sliced_files[COLUMN_COUNT - 1].length
  blank_count.times do
    sliced_files[COLUMN_COUNT - 1] << ''
  end

  sliced_files.transpose.each do |element|
    puts element.join('  ')
  end
end

def block_size(file_names)
  file_names.sum { |file_name| File.stat(file_name).blocks }
end

def file_type(file_stat)
  file_stat.ftype == 'file' ? '-' : 'd'
end

def permission_connect(file_stat)
  file_octal = file_stat.mode.to_s(8)
  "#{permission(file_octal[-3].to_i)}#{permission(file_octal[-2].to_i)}#{permission(file_octal[-1].to_i)}"
end

def permission(file_octal)
  case file_octal
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

def user_name(file_stat)
  Etc.getpwuid(file_stat.uid).name
end

def group_name(file_stat)
  Etc.getgrgid(file_stat.gid).name
end

def time(file_stat)
  file_stat.ctime.strftime('%-m %e %R')
end

def process_ls_l(file_names)
  puts "total #{block_size(file_names)}"
  file_names.each do |file_name|
    stat = File.stat(file_name)
    puts "#{file_type(stat)}#{permission_connect(stat)}  #{stat.nlink}  #{user_name(stat)}   #{group_name(stat)}  #{stat.size}  #{time(stat)}  #{file_name}"
  end
end

# 処理開始
option = ARGV.getopts('l', 'a', 'r')
file_names =
  if option['a']
    Dir.glob('*', File::FNM_DOTMATCH).sort
  else
    Dir.glob('*').sort
  end

file_names.reverse! if option['r']

if option['l']
  process_ls_l(file_names)
else
  process_ls(file_names)
end
