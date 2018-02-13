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
# docker run -it --rm -v /Users/junki.kikuchi/Documents/Projects/poodr/:/app ruby:2.4
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
