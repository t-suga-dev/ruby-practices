require 'etc'
require 'optparse'

# lオプションがないときの処理
def ls_l_other(files)
  # 要素の中で一番大きい文字数を持つものを抽出
  max_element = files.map(&:length).max

  # 要素を左寄せにする
  files.map do |element|
    element.ljust(max_element)
  end
end

def ls(files)
  # 要素の数を算出
  element_num = ls_l_other(files).length

  # 要素の数をもとに一列にいくつの要素が並ぶかを計算
  column = if (element_num % 3).zero?
             element_num / 3
           else
             element_num / 3 + 1
           end

  # 要素を上で計算した要素の数で切り分ける
  slice_elements = []
  ls_l_other(files).each_slice(column) do |left_element|
    slice_elements << left_element
  end

  # 要素の数が一緒ではない時空白を作る
  unless slice_elements[0].length == slice_elements[2].length
    blank_num = slice_elements[0].length - slice_elements[2].length
    blank_num.times do
      slice_elements[2] << ''
    end
  end

  # 行と列の入れ替え
  swap_elements = slice_elements.transpose

  # 要素同士をつなげる
  swap_elements.each do |element|
    puts element.join('  ')
  end
end

# lオプションがあるときの処理
# ブロックサイズを算出
def block_size(files)
  blocksize = 0
  files.each do |file|
    blocksize += File.stat(file).blocks
  end
  blocksize
end

# ファイルタイプを識別する
def file_type(ftype)
  if ftype == 'file'
    '-'
  else
    'd'
  end
end

def file_details(file)
  file_type(File.stat(file).ftype)
end

# パーミッション識別のためにファイルモードにして８進数にする
def octal(file)
  File.stat(file).mode.to_s(8)
end

# パーミッション所有者の権限を識別
def owner(file)
  permission_judge(octal(file)[-3].to_i)
end

# パーミッション所有グループの権限を識別
def group(file)
  permission_judge(octal(file)[-2].to_i)
end

# パーミッションその他のユーザーの権限を識別
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

# ハードリンクを取得
def hard_link(file)
  File.stat(file).nlink
end

# ユーザー名
def user_name(file)
  Etc.getpwuid(File.stat(file).uid).name
end

# グループ名
def group_name(file)
  Etc.getgrgid(File.stat(file).gid).name
end

# ファイルの大きさ
def bite_size(file)
  File.stat(file).size
end

# 最終更新時刻
def time(file)
  File.stat(file).ctime.strftime('%-m %e %R')
end

# 最終的なlオプションの結果を表示
def ls_l(files)
  puts "total #{block_size(files)}"
  files.each do |file|
    puts "#{file_details(file)}#{permission(file)}  #{hard_link(file)}  #{user_name(file)}   #{group_name(file)}  #{bite_size(file)}  #{time(file)}  #{file}"
  end
end

# 処理開始
option = ARGV.getopts('l', 'a', 'r')
files = \
  if option['a'] == true && option['r'] == true
    Dir.entries('.').sort.reverse
  elsif option['a'] == true && option['r'] == false
    Dir.entries('.').sort
  elsif option['a'] == false && option['r'] == true
    Dir.glob('*').sort.reverse
  else
    Dir.glob('*').sort
  end
if option['l'] == true
  ls_l(files)
else
  ls(files)
end
