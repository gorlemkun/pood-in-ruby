# poodr

Practical Object-Oriented Design in Ruby

# Getting Started

for Mac user

1. Install Docker
https://www.docker.com/docker-mac

2. Checkout this repository

3. Run irb

```
chmod +x run
# docker run -it --rm -v $(pwd):/app ruby:2.4
./run
```

4. Use `require` method

```ruby
irb(main):001:0> require '/app/chapter_2'
=> true
```

5. You can use classes

```ruby
irb(main):002:0> A::Gear.new(51, 11).ratio
=> 4.636363636363637
```

# Chapter 2: 単一責任のクラスを設計する

## 前提
オブジェクト指向設計のシステムの基礎は「メッセージ」である。これが設計の核になる。
この構造で最も目立つのは「クラス」である。

## この章のスコープ
クラスに属するものをどのように決めるのか、について
今後の章ではクラスからメッセージへ設計の話題がシフトしていく。

## 目標
アプリケーションをクラスを使ってモデル化したい。その上で
- 今すぐ求められる動作を行い
- 後にも簡単に変更出来る
ようにしたい。
難しいのは、後者を担保しながら前者をやること。

## 変更が簡単であるコードとはなんなのか？
定義してみる
- 変更に副作用をもたらさない
- 要件とコードの変更量が比例する
- 再利用しやすい
- 最もかんたんな変更方法は、変更が簡単なコードを追加していくこと

もしそうなら、コードはこうあるべき
- 見通しが良い: Transparent
  - 変更がもたらす影響が、すべての影響範囲において明白である
- 合理的: Reasonable
  - 変更にかかるコストが利益にふさわしい
- 利用性が高い: Usable
  - 新しい予期せぬ環境で再利用可能
- 模範的: Exemplary
  - 誰でも品質を自然と保てる

## 単一責任
クラスは出来る限り最小で有用なことをすべきである。

### 例：自転車とギア
- chainring
  - 自転車のペダルがついたギア
- cog
  - 自転車の車輪についたギア
- ratio
  - ペダルを一度漕ぐと、車輪は何回転するか？
  - chainring / cog
  - 52 / 11 => 4.73 : ペダルを一度漕ぐと、車輪は約5回転する

ratio: ギア比を計算するアプリケーションが欲しい
登場人物はchainring, cog, ratio...
これらは自転車の構成要素ではあるものの、自転車の振る舞いには言及する必要がないので自転車クラスはふさわしくない
ギアにはデータと振る舞いを定義出来そうなので、Gearクラスをつくる

```ruby
module A
  class Gear
    attr_reader :chainring, :cog
    def initialize(chainring, cog)
      @chainring = chainring
      @cog       = cog
    end

    def ratio
      chainring / cog.to_f
    end
  end
end
```

```ruby
irb(main):003:0> A::Gear.new(52, 11).ratio
=> 4.7272727272727275
irb(main):004:0> A::Gear.new(30, 27).ratio
=> 1.1111111111111112
```
