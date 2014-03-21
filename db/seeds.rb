# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
University.destroy_all
Faculty.destroy_all
Course.destroy_all
Subject.destroy_all
Teacher.destroy_all
Outline.destroy_all
UniYear.destroy_all
Semester.destroy_all

tokodai = University.create(name: "東工大", address: "大岡山", website: "http://www.titech.ac.jp/")
tkd_year_name = ["1年","2年","3年","4年"]
i=1
tkd_year_name.each do |year|
  year = UniYear.create(no: i, name: year, university: tokodai)
  i+=1
  semester1 = Semester.create(no: 1, name: "前期", uni_year: year)
  semester2 = Semester.create(no: 2, name: "後期", uni_year: year)
end

todai = University.create(name: "東大", address: "東大前", website: "http://www.u-tokyo.ac.jp/")
td_year_name = ["教養1年","教養2年","後期1年","後期2年"]
i=1
td_year_name.each do |year|
  year = UniYear.create(no: i, name: year, university: todai)
  i+=1
  semester1 = Semester.create(no: 1, name: "夏", uni_year: year)
  semester2 = Semester.create(no: 2, name: "冬", uni_year: year)
end

sub_tags = ["通年","集中講義","ゼミ","文理共通"]

igakubu = Faculty.create(name: "医学部", university: todai)
kenkogakka = Course.create(name: '健康総合科学科', faculty: igakubu)

td_sensei = Teacher.create(first_name_kanji: '村田', last_name_kanji: '金子', faculty: igakubu, university: todai)
td_sub_name = ["英語一列","英語二列","数学1","数学2","力学","化学熱力学","生命科学","健康科学実習","基礎物理学"]
td_desc = "毎週予習としてon campusを一課ずつ読んで出席し、授業ではビデオを見てちょっとした問題を解いて終わり。"
td_sub_name.each do | name |
  semesterNo = 1 + rand(2)
  yearNo = 1 + rand(4)
  uni_year = todai.uni_years.find_by_no(yearNo)
  semester = uni_year.semesters.find_by_no(semesterNo)
  sub = Subject.new(name: name, place: 'W300', description: td_desc, number_of_outlines: 15, year: 2014, university: todai)
  sub.periods << Period.create(time: 1 + rand(Period.MAX_TIME), day: 1 + rand(Period.MAX_DAY))
  sub.courses << kenkogakka
  sub.teachers << td_sensei
  sub.semester = semester
  sub.uni_year = uni_year
  sub.tag_list.add(sub_tags[rand(4)])
  (1..15).each do | j |
    outline = Outline.create(number: j, content: '')
    sub.outlines << outline
  end
  sub.save
end

kougakubu = Faculty.create(name: "工学部", university: tokodai)
jouhou = Course.create(name: '情報工学科', faculty: kougakubu)

sensei = Teacher.create(first_name_kanji: '順平', last_name_kanji: '林', faculty: kougakubu, university: tokodai)
sensei2 = Teacher.create(first_name_kanji: '小林', last_name_kanji: '次郎', faculty: kougakubu, university: tokodai)
sensei3 = Teacher.create(first_name_kanji: '篠田', last_name_kanji: '太郎', faculty: kougakubu, university: tokodai)
sub_name = ["フーリエ変換とラープラス変換","確率と統計","基礎集積回路","論理回路理論","計算基礎論","プログラミング第一","プログラミング第二",
    "プログラミング第三","プログラミング第四","数理論理学","オートマトンと言語","計算機論理設計","代数系と符号理論","離散構造とアルゴリズム",
     "計算機アーキテクチャ第一","計算機アーキテクチャ第二","オペレーティングシステム","数値計算法","電気回路基礎論","人工知能基礎論","コンパイラ構成",
     "関数解析学","集積回路設計","線形回路設計","ディジタル通信","信号処理","情報認識","生命知識論第一","生命知識論第二","数理計画法","線形電子回路",
     "情報ネットワーク設計論","データベース","計算機ネットワーク"]

description = "5類1年次の学生を対象として，情報工学の基礎となる概念や手法について講義する。"
sub_name.each do | name |
  semesterNo = 1 + rand(2)
  yearNo = 1 + rand(4)
  uni_year = tokodai.uni_years.find_by_no(yearNo)
  semester = uni_year.semesters.find_by_no(semesterNo)
  sub = Subject.create(name: name, place: 'S421', description: description, number_of_outlines: 15, year: 2014, university: tokodai)
  sub.periods << Period.create(time: 1 + rand(Period.MAX_TIME), day: 1 + rand(Period.MAX_DAY))
  sub.courses << jouhou
  sub.teachers << sensei
  sub.semester = semester
  sub.uni_year = uni_year
  sub.tag_list.add(sub_tags[rand(5)])
  (1..15).each do | j |
    outline = Outline.create(number: j, content: '')
    sub.outlines << outline
  end
  sub.save
end