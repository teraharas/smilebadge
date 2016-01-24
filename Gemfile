source 'https://rubygems.org'
ruby "2.3.0"

gem 'rails', '4.2.4'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'bcrypt', '~> 3.1.7'

group :production do
  gem 'pg'
  gem 'rails_12factor'
  gem 'puma'
end

group :development, :test do
  gem 'sqlite3'
  gem 'byebug'
  gem 'web-console', '~> 2.0'
  gem 'spring'
  # pry関連(デバッグなど便利)
  gem 'pry-rails'    # rails cの対話式コンソールがirbの代わりにリッチなpryになる
  gem 'pry-doc'      # pry中に show-source [method名] でソース内を読める
  gem 'pry-byebug'   # binding.pryをソースに記載すると、ブレイクポイントとなりデバッグが可能になる
  gem 'pry-stack_explorer' # pry中にスタックを上がったり下がったり行き来できる
  # 表示整形関連(ログなど見やすくなる)
  gem 'hirb'         # モデルの出力結果を表形式で表示する
  gem 'hirb-unicode' # hirbの日本語などマルチバイト文字の出力時の出力結果がすれる問題に対応
  gem 'rails-flog', require: 'flog' # HashとSQLのログを見やすく整形
  gem 'better_errors'     # 開発中のエラー画面をリッチにする
  gem 'binding_of_caller' # 開発中のエラー画面にさらに変数の値を表示する
  gem 'awesome_print'     # Rubyオブジェクトに色をつけて表示して見やすくなる
  gem 'quiet_assets'      # ログのassetsを表示しないようにし、ログを見やすくしてくれる
end

group :development do
  # viewの構造を表示 (Ctrl + Shift + x)
  gem 'xray-rails'
  # セキュリティチェック
  gem 'brakeman', require: false
end

# .ENV対応
gem 'dotenv-rails'

# かみなり
gem 'kaminari'
# CarrierWave
gem 'carrierwave'
gem 'mini_magick'
# Cloudinary
gem 'cloudinary'

# グラフ描画
gem 'lazy_high_charts'

# スマホ対応
gem 'jpmobile'

# 時間のかかる処理を非同期実行
gem 'delayed_job'
gem 'delayed_job_active_record'
gem 'daemons'

# デモデータ作成
gem 'faker'

# ページネーション
gem 'will_paginate'
gem 'bootstrap-will_paginate'

# ピボットテーブル
gem 'pivot_table'
