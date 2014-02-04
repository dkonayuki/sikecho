# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
University.destroy_all()
Faculty.destroy_all()
tokodai = University.create(:name => "東工大", :address => "大岡山", :website => "http://www.titech.ac.jp/")
kougakubu = Faculty.create(:name => "工学部", :university => tokodai)
sub_name = ["フーリエ変換とラープラス変換","確率と統計","基礎集積回廊","論理回路理論","計算基礎論","プログラミング第一","プログラミング第二",
    "プログラミング第三","プログラミング第四","数理論理学","オートマトンと言語","計算機論理設計","代数系と符号理論","離散構造とアルゴリズム",
     "計算機アーキテクチャ第一","計算機アーキテクチャ第二","オペレーティングシステム","数値計算法","電気回路基礎論","人工知能基礎論","コンパイラ構成",
     "関数解析学","集積回路設計","線形回路設計","ディジタル通信","信号処理","情報認識","生命知識論第一","生命知識論第二","数理計画法","線形電子回路",
     "情報ネットワーク設計論","データベース","計算機ネットワーク"]
sub_name.each do | name |
  sub = Subject.create(:name => name)
  sub.faculties << kougakubu
  kougakubu.subjects << sub
end 