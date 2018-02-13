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

ここで、追加の要求

車輪の違いによる影響（gear_inches)も計算するようにしてほしいとのこと。

- rim
  - 車輪の外輪。ここではリムの直径を指す。
- tire
  - タイヤ。ここではタイヤの厚みを指す
- 車輪の直径
  - rim + tire * 2
- gear_inches
  - 車輪の直径 * ratio

```ruby
module B
  class Gear
    attr_reader :chainring, :cog, :rim, :tire
    def initialize(chainring, cog, rim, tire)
      @chainring = chainring
      @cog = cog
      @rim = rim
      @tire = tire
    end
    
    def ratio
      chainring / cog.to_f
    end
    
    def gear_inches
      ratio * (rim + tire * 2)
    end
  end
end
```

晴れてgear_inchesが測れるようになった。
```ruby
irb(main):002:0> B::Gear.new(52, 11, 26, 1.5).gear_inches
=> 137.0909090909091
irb(main):003:0> B::Gear.new(52, 11, 24, 1.25).gear_inches
=> 125.27272727272728
```

しかし、以前は動いていたメソッドがバグるようになった。
```ruby
irb(main):004:0> B::Gear.new(52, 11).ratio
ArgumentError: wrong number of arguments (given 2, expected 4)
	from /app/chapter_2.rb:18:in `initialize'
	from (irb):5:in `new'
	from (irb):5
	from /usr/local/bin/irb:11:in `<main>'
```

さて、これはいい方法なのか？

このコードは変更が簡単なのか？アプリケーションの一部として、効率的に進化していけるのか？

ここで、あるべきコードの姿を振り返る

- 見通しが良い: Transparent
  - 変更がもたらす影響が、すべての影響範囲において明白である
- 合理的: Reasonable
  - 変更にかかるコストが利益にふさわしい
- 利用性が高い: Usable
  - 新しい予期せぬ環境で再利用可能
- 模範的: Exemplary
  - 誰でも品質を自然と保てる 

これを達成するには、クラスの責任を明確に定義し、着脱可能にしていくことが必要。そうすれば、依存なく、再利用しやすいコードになり、上記を達成できる。

逆に、2つ以上の責任を持つクラスは、簡単に再利用できない。

コードをコビーすれば再利用できるかもしれないが、それは将来にわたって2倍のメンテナンスをしていくことを意味し、メンテナンス漏れによるエンバグリスクが高まってしまう。

それでは、クラスが必要な振る舞いにだけアクセス出来るように構成されていれば、クラス全体を再利用できる。・・・のか？いやいや、そのようなクラスは、複数の責任が絡み合っているので、変更が起こる理由も多岐に渡ってしまい、変更により依存部分すべてを破壊する可能性が生まれてしまう。

クラスは単一の責任を持つべきだ。

### 単一責任かどうかを見分けるには？

- 質問する。Gearが応答できるメッセージを確かめる。
  - Gearさん、あなたの比を教えてくれませんか？
  - Gearさん、あなたのgear_inchesを教えてくれませんか？
  - Gearさん、あなたのタイヤのサイズを教えてくれませんか？

最後の質問に向かうほどGearへの質問としておかしい気がしないか？

- 1文でクラスを説明する。
  - Gearクラスは、歯のある2つのスプロケットの間の比を計算する。

現状の振る舞いに合わせるために「それと」「または」が含まれるなら、単一責任でないし、責任同士もあまり関係しないかもしれない。

Gearは2つ以上の責任を持っている。しかし、これからすべきことは明らかでない。

### 設計の決定にはタイミングがある

なにか異常に気づいたとき、すぐに設計を変更する判断をするのは危険なことである。

なぜなら、今後どんなことも起こり得るから。

「今日何もしないことの、将来的なコストはどれだけだろう？」

現状Gearクラスは依存関係を持たないため、変更が加わっても周りへの影響がない。

もし依存関係を持った場合、それら2つの目標を阻害するかもしれない。

再構成するなら、そのタイミングが適切で、それらの依存関係が、設計の決定基準に必要な情報になる。

何もしないことによる将来的なコストがそのままなら、設計の決定は延期してよい。

しかし、そのコードのパターンを踏襲したコードが将来作られる可能性には注意しよう。

## 変更を歓迎する
