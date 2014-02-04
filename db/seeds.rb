# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
University.destroy_all()
Faculty.destroy_all()
Subject.destroy_all()
Teacher.destroy_all()
tokodai = University.create(:name => "東工大", :address => "大岡山", :website => "http://www.titech.ac.jp/")
kougakubu = Faculty.create(:name => "工学部", :university => tokodai)
sensei = Teacher.create(first_name_kanji: '順平', last_name_kanji: '林')
sensei.faculty = kougakubu
sensei.university = tokodai
sensei.save
sub_name = ["フーリエ変換とラープラス変換","確率と統計","基礎集積回廊","論理回路理論","計算基礎論","プログラミング第一","プログラミング第二",
    "プログラミング第三","プログラミング第四","数理論理学","オートマトンと言語","計算機論理設計","代数系と符号理論","離散構造とアルゴリズム",
     "計算機アーキテクチャ第一","計算機アーキテクチャ第二","オペレーティングシステム","数値計算法","電気回路基礎論","人工知能基礎論","コンパイラ構成",
     "関数解析学","集積回路設計","線形回路設計","ディジタル通信","信号処理","情報認識","生命知識論第一","生命知識論第二","数理計画法","線形電子回路",
     "情報ネットワーク設計論","データベース","計算機ネットワーク"]
time_names = %w(一時限 二時限 三時限 四時限 五時限 六時限)
day_names = %w(月曜日 火曜日 水曜日 木曜日 金曜日 土曜日)
description = "5類1年次の学生を対象として，情報工学の基礎となる概念や手法について講義する。"
sub_name.each do | name |
  time = rand(6)
  day = rand(6)
  semester = 1 + rand(8)
  sub = Subject.create(name: name, time: time, time_name: time_names[time], day: day, day_name: day_names[day], place: 'S421', description: description, semester: semester)
  sub.faculties << kougakubu
  sub.teachers << sensei
  sub.save
end 
